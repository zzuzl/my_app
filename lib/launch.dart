import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'login.dart';
import 'main.dart';
import 'Staff.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Basics',
      initialRoute: '/',
      routes: {
        '/': (context) => LaunchPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class LaunchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    checkToken(context);

    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void checkToken(BuildContext context) async {
    Response response = await api.checkToken();
    if (response.data['success']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(staff: Staff(response.data['data']))));
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

}