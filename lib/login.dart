import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'main.dart';
import 'Staff.dart';
import 'launch.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String buttonText = '登录';
  Function callback;

  @override
  Widget build(BuildContext context) {
    callback = login;

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
                TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                RaisedButton(
                  child: Text(this.buttonText),
                  onPressed: login,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    setState(() {
      this.buttonText = '登录中';
      this.callback = null;
    });
    Response response =
        await api.login("672399171@qq.com", "123456.com");
    if (response.data['success']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(staff: Staff(response.data['data']))));
    } else {
      setState(() {
        this.buttonText = '登录';
        this.callback = login;
      });
    }
  }
}
