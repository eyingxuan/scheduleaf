from ortools.sat.python import cp_model
from enum import Enum


class Sentiment(Enum):
    MORN = 1
    AFT = 2


# CONSTANTS
WORKING_HOURS = 8
SUBDIVISIONS = 4
DAYS = 5
NUM_SLOTS = WORKING_HOURS * SUBDIVISIONS * DAYS
DEADLINE_PENALTY_CONSTANT = 1
SENTIMENT_PENALTY_CONSTANT = 3000

# PRIORITY FUNCTION
# end: var, deadline: int, model: CPModel
def deadline_penalty(end, deadline, model: cp_model.CpModel):
    slots = WORKING_HOURS * SUBDIVISIONS * 2
    flag = model.NewBoolVar("more than 2 days")
    model.Add(deadline - end > slots).OnlyEnforceIf(flag)
    model.Add(deadline - end <= slots).OnlyEnforceIf(flag.Not())
    penalty = model.NewIntVar(0, 160, "penalty")
    model.Add(slots - deadline + end == penalty).OnlyEnforceIf(flag.Not())
    model.Add(96 - (deadline - end - slots) == penalty).OnlyEnforceIf(flag)
    return penalty
    # return DEADLINE_PENALTY_CONSTANT * (NUM_SLOTS - (deadline - end))


class Task:
    def __init__(
        self, duration, start_time, concurrent, precedes, sentiment, deadline, name
    ):
        self.duration = duration
        # OPTIONAL
        self.start_time = start_time
        self.concurrent = concurrent
        # INDEX IN ARRAY
        self.precedes = precedes
        self.sentiment = sentiment
        self.deadline = deadline
        self.name = name


class TaskScheduler:
    def __init__(self, tasks):
        self.tasks = tasks

    def create_interval_variables(self):
        model = self.model
        self.schedule = []
        self.demands = []
        for t in self.tasks:
            start, end, interval = None, None, None
            if t.start_time == None:
                start = model.NewIntVar(0, NUM_SLOTS, f"Task {t.name} start")
                end = model.NewIntVar(1, NUM_SLOTS, f"Task {t.name} end")
            else:
                start = model.NewIntVar(
                    t.start_time, t.start_time, f"Task {t.name} start"
                )
                end = model.NewIntVar(
                    t.start_time + t.duration,
                    t.start_time + t.duration,
                    f"Task {t.name} end",
                )

            model.Add(end <= t.deadline)
            interval = model.NewIntervalVar(
                start, t.duration, end, f"Task {t.name} interval"
            )
            interval.start = start
            interval.end = end
            self.demands.append(0 if t.concurrent else 1)
            self.schedule.append(interval)

    def create_overlapping_constraints(self):
        model = self.model
        model.AddCumulative(self.schedule, self.demands, 1)

    def create_precedence_constraints(self):
        for i, t in enumerate(self.tasks):
            for succ in t.precedes:
                self.model.Add(self.schedule[i].end <= self.schedule[succ].start)

    def create_nosplit_constraints(self):
        model = self.model
        for s in self.schedule:
            start_r, end_r = (
                model.NewIntVar(0, DAYS - 1, ""),
                model.NewIntVar(0, DAYS - 1, ""),
            )
            end_m_one = model.NewIntVar(0, NUM_SLOTS, "")
            model.Add(s.end == end_m_one + 1)
            model.AddDivisionEquality(start_r, s.start, WORKING_HOURS * SUBDIVISIONS)
            model.AddDivisionEquality(end_r, end_m_one, WORKING_HOURS * SUBDIVISIONS)
            model.Add(start_r == end_r)

    def create_scheduling_penalties(self):
        cumul = 0
        for i, s in enumerate(self.schedule):
            tmp = self.model.NewIntVar(-400, 400, "")
            squared = self.model.NewIntVar(0, 3000000, "")
            p = deadline_penalty(s.end, self.tasks[i].deadline, self.model)
            self.model.Add(tmp == p)
            self.model.AddMultiplicationEquality(squared, [tmp, tmp])
            cumul += squared
        return cumul

    def create_sentiment_penalties(self):
        cumul = 0
        for i, s in enumerate(self.schedule):
            if self.tasks[i].sentiment:
                tmp = self.model.NewIntVar(0, WORKING_HOURS * SUBDIVISIONS, "")
                sched_penalty = self.model.NewIntVar(0, 5000, "")
                indicator = self.model.NewBoolVar("tmp >= half work day?")
                self.model.AddModuloEquality(tmp, s.start, WORKING_HOURS * SUBDIVISIONS)
                self.model.Add(tmp >= WORKING_HOURS * SUBDIVISIONS // 4).OnlyEnforceIf(
                    indicator
                    if self.tasks[i].sentiment == Sentiment.MORN
                    else indicator.Not()
                )
                self.model.Add(tmp < WORKING_HOURS * SUBDIVISIONS // 4).OnlyEnforceIf(
                    indicator.Not()
                    if self.tasks[i].sentiment == Sentiment.MORN
                    else indicator
                )

                self.model.Add(sched_penalty == 5000).OnlyEnforceIf(indicator)
                self.model.Add(sched_penalty == 0).OnlyEnforceIf(indicator.Not())
                cumul += sched_penalty
        return cumul

    def create_penalties(self):
        self.penalty = self.model.NewIntVar(0, 2000000000, "Scheduling Penalties")
        p1, p2 = self.create_scheduling_penalties(), self.create_sentiment_penalties()
        self.model.Add(p1 + p2 == self.penalty)

    def solve_model(self):
        self.model = cp_model.CpModel()
        self.solver = cp_model.CpSolver()

        self.create_interval_variables()
        self.create_overlapping_constraints()
        self.create_precedence_constraints()
        self.create_nosplit_constraints()
        self.create_penalties()
        self.model.Minimize(self.penalty)

        self.solver.parameters.num_search_workers = 4
        m = self.solver.Solve(self.model)
        # print(self.solver.StatusName())

        if m in [cp_model.FEASIBLE, cp_model.OPTIMAL]:
            return [
                (self.solver.Value(s.start), self.solver.Value(s.end))
                for s in self.schedule
            ]


if __name__ == "__main__":
    task1 = Task(2, None, False, [1], Sentiment.AFT, 56, "A")
    task2 = Task(5, None, False, [], Sentiment.MORN, 100, "B")
    task3 = Task(10, None, False, [], Sentiment.MORN, 30, "C")
    task4 = Task(3, None, True, [1], Sentiment.AFT, 95, "D")
    task5 = Task(8, None, False, [], Sentiment.MORN, 30, "E")
    task6 = Task(1, None, False, [4], Sentiment.MORN, 70, "F")
    task7 = Task(3, None, False, [7], Sentiment.MORN, 120, "G")
    task8 = Task(12, None, False, [], Sentiment.MORN, 150, "H")
    task9 = Task(3, None, False, [], Sentiment.MORN, 10, "I")
    task10 = Task(4, None, False, [], Sentiment.AFT, 140, "J")

    scheduler = TaskScheduler(
        [task1, task2, task3, task4, task5, task6, task7, task8, task9, task10]
    )
    print(scheduler.solve_model())
