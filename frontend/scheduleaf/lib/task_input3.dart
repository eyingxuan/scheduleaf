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

  List<bool> checkboxList = [];

  @override
  void initState() {
    checkboxList =
        new List<bool>.filled(taskDataList.value.length, false, growable: true);
    super.initState();
  }

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
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return new Card(
                  child: CheckboxListTile(
                    title: Text(taskDataList.value[index].name),
                    value: checkboxList[index],
                    onChanged: (bool value) {
                      setState(() {
                        checkboxList[index] = value;
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
                taskData.setInput3Props(checkboxList);
                Navigator.of(context).pop();
                checkboxList.add(false);
                taskDataList.value.add(taskData);
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
