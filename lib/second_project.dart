import 'package:flutter/material.dart';
import 'Project.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';
import 'demo.dart';

class SecondProjectPage extends BackdropDemo {
  final Project project;
  List<Project> projectList = new List();
  List<Staff> staffList = new List();

  SecondProjectPage(this.project) : super(project, 1);
}
