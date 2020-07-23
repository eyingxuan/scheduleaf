from typing import Optional
from .sentiment import SentimentIntensityAnalyzer
from ..models.task import UserTasks, UserSchedule, ScheduledTask
from .solver import Task, TaskScheduler, Sentiment


def plan_schedule(
    user: UserTasks, sentiment: SentimentIntensityAnalyzer
) -> Optional[UserSchedule]:
    task_pos = {}
    tasks = []
    for i, t in enumerate(user.task_list):
        polarity = sentiment.polarity_scores(t.description)
        # TODO: Assumes everyone is a morning person
        task = Task(
            t.duration,
            t.start_time,
            t.concurrent,
            [],
            Sentiment.MORN if polarity["compound"] < 0 else Sentiment.AFT,
            t.deadline if t.deadline else 160,
            t.title,
        )
        tasks.append(task)
        task_pos[t.task_id] = i

    for i, t in enumerate(tasks):
        for prec in user.task_list[i].precedes:
            t.precedes.append(task_pos[prec])

    scheduler = TaskScheduler(tasks)
    ans = scheduler.solve_model()
    if not ans:
        return None
    else:
        scheduled_tasks = []
        for i, t in enumerate(user.task_list):
            scheduled_tasks.append(ScheduledTask(**t.dict(), scheduled_start=ans[i][0]))

        return UserSchedule(username=user.username, task_list=scheduled_tasks)
