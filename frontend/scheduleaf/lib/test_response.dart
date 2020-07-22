class TestResponse {
  final String username;
  final List<dynamic> taskList;

  TestResponse({this.username, this.taskList});

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    return TestResponse(
      username: json['id'],
      taskList: json['task_list'],
    );
  }
}
