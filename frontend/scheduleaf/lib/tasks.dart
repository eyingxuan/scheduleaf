import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'task_input.dart';
import 'task_data.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<TaskData> taskDataList = [];

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

  toJson() {
    List<Object> taskJsonList = [];
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
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
