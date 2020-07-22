class CalendarResponse {
  final String username;
  final List<CalendarTask> taskList;

  CalendarResponse({this.username, this.taskList});

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    List<CalendarTask> taskList = [];
    for (var i = 0; i < json['task_list'].length; i++) {
      taskList.add(new CalendarTask.fromJson(json['task_list'][i]));
    }

    return CalendarResponse(
      username: json['username'],
      taskList: taskList,
    );
  }
}

class CalendarTask {
  String title;
  int duration;
  String description;
  int scheduledStart;

  CalendarTask.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.description = json['description'];
    this.duration = json['duration'];
    this.scheduledStart = json['scheduled_start'];
  }
}
