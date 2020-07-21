import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "test_response.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<TestResponse> responseObject;

  Future<TestResponse> createResponse(String msg, String name) async {
    final http.Response response = await http.put(
      'http://10.0.2.2:8000/sched/1',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'msg': msg,
        'name': name,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TestResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update response');
    }
  }

  void submitForm() {
    // TODO

//    setState(() {
//      _counter++;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  responseObject = createResponse("test2", "will2");
                  print("response received");
                });
              },
              child: Text(
                "Submit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
