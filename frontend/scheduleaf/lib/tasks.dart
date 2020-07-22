import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'task_input.dart';
import 'task_data.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TaskData taskData = TaskData();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput(taskData: taskData),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                // Navigate back to first route when tapped.
                Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
            Card(
              child: ListTile(
                title: Text('Add a task'),
                leading: Icon(Icons.add_circle_outline),
                onTap: () {
                  /* react to the tile being tapped */
                  _showMyDialog();
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                print(taskData);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
