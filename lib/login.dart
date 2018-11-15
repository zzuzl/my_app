import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';

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
                RaisedButton(
                  child: Text('LOGIN'),
                  onPressed: () async {
                    Response response =
                        await api.login("672399171@qq.com", "123456.com");
                    print(response.data);
                    if (response.data['success']) {
                      Navigator.pushNamed(context, "/");
                    }
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
