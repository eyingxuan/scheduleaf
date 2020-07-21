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
      title: 'ScheduLeaf',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(title: 'ScheduLeaf'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<TestResponse> responseObject;
  final usernameController = TextEditingController();

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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    super.dispose();
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
            Text(
              'TODO: Logo here',
              style: TextStyle(fontSize: 30.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Enter your username'),
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  responseObject = createResponse("test2", "will2");
                  print("response received");
                  print(usernameController.text);
                  // dispose();
                });
              },
              child: Text(
                "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
