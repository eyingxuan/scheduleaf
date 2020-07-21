import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskInput extends StatefulWidget {
  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Task name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Task description'),
            maxLines: 4,
          ),
          // TODO: Dependencies
        ],
      ),
    );
  }
}
