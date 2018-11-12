import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Company.dart';
import 'Project.dart';

class Api {
  String token = "";
  static const String TOKEN_KEY = "token";
  final Dio dio = new Dio();
  SharedPreferences sp = null;

  Api() {
    initSp();
  }

  void initSp() async {
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
      this.token = sp.getString(TOKEN_KEY);
    }
  }

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
    sp.setString(TOKEN_KEY, token);
  }
}