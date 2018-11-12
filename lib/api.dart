import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Company.dart';
import 'Project.dart';

class Api {
  String token = "";
  final Dio dio = new Dio();
  SharedPreferences sp = null;

  void login(String email, String password) async {
    // todo


  }

  void listCompany(int pid) {
    // todo
  }

  void listProject(int pid) {
    // todo
  }

  void listStaff(int pid, int page) {
    // todo
  }

  void storeToken(String token) {
    this.token = token;


  }


}