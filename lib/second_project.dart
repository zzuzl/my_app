import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';
import 'demo.dart';

/*void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map map = new Map();
    map['id'] = 1;
    map['pid'] = 0;
    map['name'] = 'test';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'demo',
      home: SecondProjectPage(Project(map)),
    );
  }
}*/

class SecondProjectPage extends BackdropDemo {
  final Project project;
  List<Project> projectList = new List();
  List<Staff> staffList = new List();

  SecondProjectPage(this.project) : super(project, 1);
}
