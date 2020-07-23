import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'task_data.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text('Duration'),
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
              FlatButton(
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
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
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
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Concurrent',
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
          FlatButton(
            child: Text('Finish'),
            onPressed: () {
              setState(() {
                taskData.setInput2Props(
                  hourController.text,
                  minController.text,
                  startTime,
                  endTime,
                  checkboxValue,
                );
                taskDataList.value.add(taskData);
                taskDataList.notifyListeners();
                Navigator.of(context).pop();
              });
            },
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
