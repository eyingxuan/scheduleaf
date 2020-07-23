import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'task_data.dart';

class TaskInput3 extends StatefulWidget {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  TaskInput3({Key key, @required this.taskData, @required this.taskDataList})
      : super(key: key);

  @override
  _TaskInputState3 createState() =>
      _TaskInputState3(taskData: taskData, taskDataList: taskDataList);
}

class _TaskInputState3 extends State<TaskInput3> {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  _TaskInputState3(
      {Key key, @required this.taskData, @required this.taskDataList});

  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text('Dependent on...'),
          Container(
            width: double.maxFinite,
            child: new ListView.builder(
              shrinkWrap: true,
              itemCount: taskDataList.value.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return new Card(
                  child: CheckboxListTile(
                    title: Text(taskDataList.value[index].name),
                    value: checkboxValue,
                    onChanged: (bool value) {
                      setState(() {
                        checkboxValue = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          FlatButton(
            child: Text('Finish'),
            onPressed: () {
              setState(() {
                // TODO: set procedes in the task
//                taskData.setInput3Props(
//                  hourController.text,
//                  minController.text,
//                  startTime,
//                  endTime,
//                  checkboxValue,
//                );
                taskDataList.value.add(taskData);
                Navigator.of(context).pop();
                taskDataList.notifyListeners();
              });
            },
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
