import unittest
from solver import TaskScheduler, Task


class TestConstraintSolver(unittest.TestCase):
    def test_provided_timeslot(self):
        scheduler = TaskScheduler(
            [
                Task(1, 0, False, [], None, 160, "Coffee"),
                Task(10, None, False, [], None, 60, "Task1"),
                Task(3, None, False, [1], None, 140, "Task2"),
            ]
        )
        self.assertListEqual(scheduler.solve_model(), [(0, 1), (1, 11), (73, 76)])

    def test_not_provided_timeslot(self):
        scheduler = TaskScheduler(
            [
                Task(1, None, False, [], None, 159, "Coffee"),
                Task(10, None, False, [], None, 60, "Task1"),
                Task(3, None, False, [1], None, 140, "Task2"),
            ]
        )
        self.assertListEqual(scheduler.solve_model(), [(94, 95), (0, 10), (73, 76)])

    def test_dependencies_resp(self):
        scheduler = TaskScheduler(
            [
                Task(1, None, False, [], None, 4, "Task1"),
                Task(3, None, False, [0], None, 140, "Task2"),
            ]
        )
        self.assertListEqual(scheduler.solve_model(), [(0, 1), (73, 76)])

    def test_no_deps(self):
        scheduler = TaskScheduler(
            [
                Task(1, None, False, [], None, 4, "Task1"),
                Task(3, None, False, [], None, 140, "Task2"),
            ]
        )
        self.assertListEqual(scheduler.solve_model(), [(0, 1), (73, 76)])

    def test_infeasible_provided(self):
        scheduler = TaskScheduler(
            [
                Task(3, None, False, [], None, 140, "Task2"),
                Task(5, 2, False, [0], None, 100, "Task1"),
            ]
        )
        self.assertIsNone(scheduler.solve_model())

    def test_priorities(self):
        scheduler = TaskScheduler(
            [
                Task(3, None, False, [], None, 4, "Task1"),
                Task(3, None, False, [], None, 140, "Task2"),
            ]
        )
        self.assertListEqual(scheduler.solve_model(), [(0, 3), (73, 76)])


if __name__ == "__main__":
    unittest.main()
