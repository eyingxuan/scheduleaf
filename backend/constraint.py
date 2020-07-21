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
SENTIMENT_PENALTY_CONSTANT = 5000

# PRIORITY FUNCTION
def deadline_penalty(end, deadline):
    return DEADLINE_PENALTY_CONSTANT * (NUM_SLOTS - (deadline - end))

class Task:
    def __init__(self, duration, start_time, concurrent, precedes, sentiment, deadline, name):
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
                start = model.NewIntVar(0, NUM_SLOTS, f'Task {t.name} start')
                end = model.NewIntVar(1, NUM_SLOTS, f'Task {t.name} end')
            else:
                start = model.NewIntVar(t.start_time, t.start_time, f'Task {t.name} start')
                end = model.NewIntVar(t.start_time + t.duration, t.start_time + t.duration, f'Task {t.name} end')

            model.Add(end <= t.deadline)
            interval = model.NewIntervalVar(start, t.duration, end, f'Task {t.name} interval')
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

    def create_scheduling_penalties(self):
        cumul = 0
        for i, s in enumerate(self.schedule):
            tmp = self.model.NewIntVar(-400, 400, '')
            squared = self.model.NewIntVar(0, 3000000, '')
            p = deadline_penalty(s.end, self.tasks[i].deadline)
            self.model.Add(tmp == p)
            self.model.AddMultiplicationEquality(squared, [tmp, tmp])
            cumul += squared
        return cumul

    # def create_sentiment_penalties(self):
    #     cumul = 0
    #     for i, s in enumerate(self.schedule):
    #         tmp = self.model.NewIntVar(0, WORKING_HOURS * SUBDIVISIONS)
    #         self.model.AddModuloEquality(tmp, s.end, WORKING_HOURS * SUBDIVISIONS)

    def create_penalties(self):
        self.penalty = self.model.NewIntVar(0, 2000000000, 'Scheduling Penalties')
        target = self.create_scheduling_penalties()
        self.model.Add(target == self.penalty)

    def solve_model(self):
        self.model = cp_model.CpModel()
        self.solver = cp_model.CpSolver()

        self.create_interval_variables()
        self.create_overlapping_constraints()
        self.create_precedence_constraints()
        self.create_penalties()
        self.model.Minimize(self.penalty)

        self.solver.parameters.num_search_workers = 4
        m = self.solver.Solve(self.model)
        # print(self.solver.StatusName())

        if m in [cp_model.FEASIBLE, cp_model.OPTIMAL]:
            return [(self.solver.Value(s.start), self.solver.Value(s.end)) for s in self.schedule]


if __name__ == "__main__":
    scheduler = TaskScheduler([Task(1, None,False, [], None, 160, "A")])
    print(scheduler.solve_model())

