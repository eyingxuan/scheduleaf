import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_data.dart';
import 'task_input.dart';
import 'calendar.dart';

class Tasks extends StatefulWidget {
  final String username;

  Tasks({Key key, @required this.username}) : super(key: key);

  @override
  _TasksState createState() => _TasksState(username: username);
}

class _TasksState extends State<Tasks> {
  final String username;
  int selectedIndex = 0;

  _TasksState({Key key, @required this.username});

  var taskDataList = new ValueNotifier([]);
  Future<bool> taskResponse;

  void onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Calendar(username: username),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    generateExistingTasks();
    super.initState();
  }

  generateExistingTasks() async {
    var response = await generateExistingTasksRequest();
    setState(() {
      taskDataList.value = response.taskList;
    });
  }

  Future<TaskResponse> generateExistingTasksRequest() async {
    final http.Response response = await http.get(
      'http://10.0.2.2:8000/tasks/$username',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TaskResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update task list with username: $username');
    }
  }

  Future<void> _showMyDialog(TaskData taskData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput(taskData: taskData, taskDataList: taskDataList),
        );
      },
    );
  }

  Future<bool> submitTasks() async {
    final http.Response response = await http.put(
      'http://10.0.2.2:8000/tasks',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(toJson()),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update task list');
    }
  }

  Map<String, dynamic> toJson() {
    List<dynamic> taskJsonList = [];
    for (int i = 0; i < taskDataList.value.length; i++) {
      taskJsonList.add(taskDataList.value[i].taskJson(i));
    }

    return {
      "username": username,
      "task_list": taskJsonList,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        onTap: onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Tasks'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<dynamic>>(
        valueListenable: taskDataList,
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskDataList.value.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Card(
                        child: ListTile(
                          title: Text(taskDataList.value[index].name),
                          leading: Icon(Icons.check_circle_outline),
                          key: UniqueKey(),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Add a task'),
                    leading: Icon(Icons.add_circle_outline),
                    onTap: () {
                      /* react to the tile being tapped */
                      setState(() {
                        TaskData taskData = TaskData();
                        _showMyDialog(taskData);
                        // taskDataList.add(taskData);
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: RaisedButton(
                    onPressed: () {
                      print(taskDataList);
                      print(toJson());
                      taskResponse = submitTasks();
                      print("response received");
                      print(taskResponse);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
