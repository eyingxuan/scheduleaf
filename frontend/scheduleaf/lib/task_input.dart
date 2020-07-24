import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scheduleaf/task_data.dart';
import 'task_data.dart';
import 'task_input2.dart';

class TaskInput extends StatefulWidget {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  TaskInput({Key key, @required this.taskData, @required this.taskDataList})
      : super(key: key);

  @override
  _TaskInputState createState() =>
      _TaskInputState(taskData: taskData, taskDataList: taskDataList);
}

class _TaskInputState extends State<TaskInput> {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  _TaskInputState(
      {Key key, @required this.taskData, @required this.taskDataList});

  final nameController = TextEditingController();
  final descController = TextEditingController();

  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput2(taskData: taskData, taskDataList: taskDataList),
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
          Container(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: RaisedButton(
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green,
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
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
