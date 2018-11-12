import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Navigation Basics', home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('images/diamond.png'),
                SizedBox(height: 16.0),
                // TODO: Add TextField widgets (101)
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    controller: _usernameController),
                SizedBox(height: 12.0),
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    controller: _passwordController)
              ],
            ),
            SizedBox(height: 120.0),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    // TODO: Show the next page (101)
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
