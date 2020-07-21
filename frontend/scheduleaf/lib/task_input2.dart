import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskInput2 extends StatefulWidget {
  @override
  _TaskInputState2 createState() => _TaskInputState2();
}

class _TaskInputState2 extends State<TaskInput2> {
  bool checkboxValue = false;

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
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(labelText: 'Minutes'),
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
                      onChanged: (date) {},
                      onConfirm: (date) {},
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
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
                      onChanged: (date) {},
                      onConfirm: (date) {},
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
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
          )
          // TODO: Dependencies
        ],
      ),
    );
  }
}
