class TestResponse {
  final int id;
  final String msg;
  final String name;

  TestResponse({this.id, this.msg, this.name});

  factory TestResponse.fromJson(Map<String, dynamic> json) {
    return TestResponse(
      id: json['id'],
      msg: json['msg'],
      name: json['name'],
    );
  }
}
