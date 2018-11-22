import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'login.dart';
import 'home.dart';
import 'Staff.dart';
import 'search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '中原分公司数字人事',
      home: LaunchPage(),
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(staff: Staff(response.data['data']))),
            (Route<dynamic> route) { return false; },
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) { return false; },
      );
    }
  }

}