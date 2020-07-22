class TaskData {
  String name;
  String description;
  int durationMinutes;
  DateTime start;
  DateTime end;
  bool isConcurrent;

  TaskData() {
    name = '';
    description = '';
    durationMinutes = 0;
    start = null;
    end = null;
    isConcurrent = false;
  }

  TaskData.fullConstructor(String n, String desc, int hours, int mins,
      DateTime s, DateTime e, bool concur) {
    name = n;
    description = desc;
    durationMinutes = (60 * hours) + mins;
    start = s;
    end = e;
    isConcurrent = concur;
  }

  setInput1Props(String n, String desc) {
    name = n;
    description = desc;
  }

  setInput2Props(
      String hours, String mins, DateTime s, DateTime e, bool concur) {
    int h;
    try {
      h = int.parse(hours);
    } catch (FormatException) {
      h = 0;
    }

    int m;
    try {
      m = int.parse(mins);
    } catch (FormatException) {
      m = 0;
    }

    durationMinutes = (60 * h) + m;
    start = s;
    end = e;
    isConcurrent = concur;
  }
}
