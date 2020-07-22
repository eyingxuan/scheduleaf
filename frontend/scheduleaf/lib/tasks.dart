import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'task_input.dart';
import 'task_data.dart';
import "test_response.dart";

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<TaskData> taskDataList = [];
  Future<bool> responseObject;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput(taskData: taskDataList[taskDataList.length - 1]),
        );
      },
    );
  }

  Future<bool> createResponse() async {
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
    for (int i = 0; i < taskDataList.length; i++) {
      taskJsonList.add(taskDataList[i].taskJson(i));
    }

    return {
      "username": "will", // TODO: grab from login
      "task_list": taskJsonList,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Center(
        child: Column(
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
                itemCount: taskDataList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new Card(
                    child: ListTile(
                      title: Text(taskDataList[index].name),
                      leading: Icon(Icons.check_circle_outline),
                      trailing: Icon(Icons.more_vert),
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
                  TaskData taskData = TaskData();
                  taskDataList.add(taskData);
                  _showMyDialog();
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                print(taskDataList);
                print(toJson());
                responseObject = createResponse();
                print("response received");
                print(responseObject);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
