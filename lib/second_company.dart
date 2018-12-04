import 'package:flutter/material.dart';
import 'Company.dart';
import 'Staff.dart';
import 'staff_info.dart';
import 'package:dio/dio.dart';
import 'helper.dart';
import 'demo.dart';

class SecondCompanyPage extends BackdropDemo {
  final Company company;
  List<Company> companyList = new List();
  List<Staff> staffList = new List();

  SecondCompanyPage(this.company) : super(company, 0);
}
