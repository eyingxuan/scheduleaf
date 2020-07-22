import 'package:flutter/material.dart';
import "tasks.dart";

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
      home: LoginPage(title: 'Login'),
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
  final usernameController = TextEditingController();

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
                  print(usernameController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tasks()),
                  );
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
