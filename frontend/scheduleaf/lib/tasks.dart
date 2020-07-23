import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_data.dart';
import 'task_data.dart';
import 'task_input.dart';
import 'task_data.dart';
import 'calendar.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final taskDataList = new ValueNotifier([]);
  Future<bool> taskResponse;
  String username = 'will'; // TODO: change to username from login

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
      "username": username, // TODO: grab from login
      "task_list": taskJsonList,
    };
  }

//  listWithoutEmpty() {
//    if (taskDataList.length > 0 &&
//        taskDataList[taskDataList.length - 1].durationMinutes == 0) {
//      return taskDataList.sublist(0, taskDataList.length - 1);
//    } else {
//      return taskDataList;
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Center(
        child: ValueListenableBuilder<List<dynamic>>(
          valueListenable: taskDataList,
          builder: (context, value, child) {
            return Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    // Navigate back to first route when tapped.
                    Navigator.pop(context);
                  },
                  child: Text('Logout'),
                ),
                Container(
                  child: new ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskDataList.value.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return new Card(
                        child: ListTile(
                          title: Text(taskDataList.value[index].name),
                          leading: Icon(Icons.check_circle_outline),
                          trailing: Icon(Icons.more_vert),
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
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        print(taskDataList);
                        print(toJson());
                        taskResponse = submitTasks();
                        print("response received");
                        print(taskResponse);
                      },
                      child: Text('Submit'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        print("response received");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Calendar(),
                          ),
                        );
                      },
                      child: Text('Calendar'),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
