import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'task_data.dart';
import 'task_input3.dart';

class TaskInput2 extends StatefulWidget {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  TaskInput2({Key key, @required this.taskData, @required this.taskDataList})
      : super(key: key);

  @override
  _TaskInputState2 createState() =>
      _TaskInputState2(taskData: taskData, taskDataList: taskDataList);
}

class _TaskInputState2 extends State<TaskInput2> {
  final TaskData taskData;
  final ValueNotifier<List<dynamic>> taskDataList;

  _TaskInputState2(
      {Key key, @required this.taskData, @required this.taskDataList});

  bool checkboxValue = false;
  DateTime endTime;
  DateTime startTime;
  final hourController = TextEditingController();
  final minController = TextEditingController();

  Future<void> _showMyDialog3() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: TaskInput3(taskData: taskData, taskDataList: taskDataList),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Hours'),
                  controller: hourController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Minutes'),
                  controller: minController,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Concurrent Task?',
              ),
              Checkbox(
                value: checkboxValue,
                onChanged: (bool value) {
                  setState(() {
                    checkboxValue = value;
                  });
                },
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(1, 0, 1, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    color: Colors.white,
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2020, 7, 20, 10, 0),
                          maxTime: DateTime(2020, 7, 24, 18, 0),
                          onChanged: (date) {}, onConfirm: (date) {
                        startTime = date;
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      'Start Time',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Expanded(
                  child: OutlineButton(
                    color: Colors.white,
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2020, 7, 20, 10, 0),
                          maxTime: DateTime(2020, 7, 24, 18, 0),
                          onChanged: (date) {}, onConfirm: (date) {
                        endTime = date;
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      'Deadline',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
            onPressed: () {
              setState(() {
                taskData.setInput2Props(
                  hourController.text,
                  minController.text,
                  startTime,
                  endTime,
                  checkboxValue,
                );
                Navigator.of(context).pop();
                _showMyDialog3();
              });
            },
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
