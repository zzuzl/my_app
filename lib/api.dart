import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'Company.dart';
import 'Project.dart';

class Api {
  static String token = "";
  static const String TOKEN_KEY = "token";
  static const String BASE = "http://localhost:8080/";
  static final Dio dio = new Dio();
  static SharedPreferences sp = null;

  Api() {
    dio.interceptor.request.onSend = (Options options) {
      options.contentType=ContentType.parse("application/x-www-form-urlencoded");
      options.headers = {"token": token};
      return options;
    };
    dio.interceptor.response.onError = (DioError e){
      if(e.response.statusCode == 401) {
        // Navigator.pushNamed(context, "/login");
      }
      return  e;//continue
    };
    initSp();
  }

  void initSp() async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
    if (sp == null) {
      sp = await SharedPreferences.getInstance();
      token = sp.getString(TOKEN_KEY);
    }
  }

  Future<Response> login(String email, String password) {
    return dio.post(BASE + "rest/staff/login", data: {
      "user": email,
      "password": password
    });
  }

  Future<Response> listCompany(int pid) {
    return dio.get(BASE + "rest/company/list?pid=${pid}");
  }

  Future<Response> listProject(int pid) {
    return dio.get(BASE + "rest/project/list?pid=${pid}");
  }

  Future<Response> listStaff(int pid, int page) {
    return dio.get(BASE + "rest/staff/findByPid?pid=${pid}&page=${page}");
  }

  void storeToken(String _token) {
    token = _token;
    sp.setString(TOKEN_KEY, token);
  }
}