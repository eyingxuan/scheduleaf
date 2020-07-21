import unittest
from constraint import TaskScheduler, Task

class TestConstraintSolver(unittest.TestCase):
    def test_provided_timeslot(self):
        scheduler = TaskScheduler([Task(1, 0, False, [], None, 160, "Coffee"), Task(10, None, False, [], None, 60, "Task1"), Task(3, None, False, [1], None, 140, "Task2")])
        self.assertListEqual(scheduler.solve_model(), [(0, 1), (4, 14), (1, 4)])

    def test_not_provided_timeslot(self):
        scheduler = TaskScheduler([Task(1, None, False, [], None, 159, "Coffee"), Task(10, None, False, [], None, 60, "Task1"), Task(3, None, False, [1], None, 140, "Task2")])
        self.assertListEqual(scheduler.solve_model(), [(13, 14), (3, 13), (0, 3)])

    def test_dependencies_resp(self):
        scheduler = TaskScheduler([Task(1, None, False, [], None, 4, "Task1"), Task(3, None, False, [0], None, 140, "Task2")])
        self.assertListEqual(scheduler.solve_model(), [(3, 4), (0, 3)])

    def test_no_deps(self):
        scheduler = TaskScheduler([Task(1, None, False, [], None, 4, "Task1"), Task(3, None, False, [], None, 140, "Task2")])
        self.assertListEqual(scheduler.solve_model(), [(0, 1), (1, 4)])

    def test_infeasible_provided(self):
        scheduler = TaskScheduler([Task(5, 2, False, [], None, 100, "Task1"), Task(3, None, False, [0], None, 140, "Task2")])
        self.assertIsNone(scheduler.solve_model())

    def test_priorities(self):
        scheduler = TaskScheduler([Task(3, None, False, [], None, 4, "Task1"), Task(3, None, False, [], None, 140, "Task2")])
        self.assertListEqual(scheduler.solve_model(), [(0, 3), (3, 6)])


if __name__ == '__main__':
    unittest.main()

