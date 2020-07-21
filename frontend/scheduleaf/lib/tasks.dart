import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('TODO.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
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
          ],
        ),
      ),
    );
  }
}