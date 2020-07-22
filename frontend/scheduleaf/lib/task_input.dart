import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'task_data.dart';
import 'task_input2.dart';

class TaskInput extends StatefulWidget {
  final TaskData taskData;

  TaskInput({Key key, @required this.taskData}) : super(key: key);

  @override
  _TaskInputState createState() => _TaskInputState(taskData: taskData);
}

class _TaskInputState extends State<TaskInput> {
  final TaskData taskData;
  _TaskInputState({Key key, @required this.taskData});

  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput2(taskData: taskData),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Task name'),
            controller: nameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Task description'),
            maxLines: 4,
            controller: descController,
          ),
          FlatButton(
            child: Text('Continue'),
            onPressed: () {
              setState(() {
                taskData.setInput1Props(
                    nameController.text, descController.text);
                print(taskData.name);
                Navigator.of(context).pop();
                _showMyDialog2();
              });
            },
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
