class TaskData {
  String name;
  String description;
  int durationMinutes;
  DateTime start;
  DateTime end;
  bool isConcurrent;
  List<int> precedes;

  TaskData() {
    name = '';
    description = '';
    durationMinutes = 0;
    start = null;
    end = null;
    isConcurrent = false;
    precedes = [];
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

  setInput3Props(List<bool> dependencies) {
    for (int i = 0; i < dependencies.length; i++) {
      if (dependencies[i]) {
        precedes.add(i);
      }
    }
  }

  // Return a number between 0 and 160 representing which time interval the
  // DateTime object best represents, where an interval represents
  // 15 minutes in a 40 hour work week
  int timeInterval(DateTime d) {
    int interval = 0;

    // if null, return 0
    if (d == null) {
      return null;
    }

    // add 15*8 intervals for each day past monday
    if (d.weekday == DateTime.tuesday) {
      interval += 32;
    } else if (d.weekday == DateTime.wednesday) {
      interval += 2 * 32;
    } else if (d.weekday == DateTime.thursday) {
      interval += 3 * 32;
    } else if (d.weekday == DateTime.friday) {
      interval += 4 * 32;
    }

    // if deadline is before 10am, act like it is due at 6 the night before
    if (d.hour < 10) {
      return interval;
    }

    // if deadline is after 6pm, act like it is due at 6pm that day
    if (d.hour > 18) {
      return interval + 32;
    }

    // otherwise, add 4 intervals for each hour and 1 for each 15 minutes
    interval += (d.hour - 10) * 4;
    interval += d.minute ~/ 15;
    return interval;
  }

  int convertMinutesToSlots(int mins) {
    return durationMinutes ~/ 15;
  }

  Map<String, dynamic> taskJson(id) {
    return {
      "task_id": id,
      "title": name,
      "duration": convertMinutesToSlots(durationMinutes),
      "deadline": timeInterval(end),
      "start_time": timeInterval(start),
      "concurrent": isConcurrent,
      "precedes": [],
      "description": description
    };
  }
}
