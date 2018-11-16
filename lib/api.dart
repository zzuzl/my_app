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
  static const String BASE = "http://www.zlihj.cn/";
  static final Dio dio = new Dio();
  static SharedPreferences sp = null;

  Api() {
    dio.interceptor.request.onSend = (Options options) {
      options.contentType=ContentType.parse("application/x-www-form-urlencoded");
      options.headers = {TOKEN_KEY: token};

      print("send token:${token}");
      return options;
    };
    dio.interceptor.response.onSuccess = (Response response) {
      String token = response.headers.value(TOKEN_KEY);
      print("success token:${token}");

      if (token != null && token.length > 0) {
        storeToken(token);
      }

      return response; // continue
    };
    dio.interceptor.response.onError = (DioError e){
      // print('出错了');
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

  Future<Response> test() {
    return dio.get("http://www.baidu.com/");
  }

  Future<Response> listCompany(int pid) {
    return dio.get(BASE + "rest/company/list?pid=${pid}");
  }

  Future<Response> listProject(int pid) {
    return dio.get(BASE + "rest/project/list?pid=${pid}");
  }

  Future<Response> listStaff(int pid, int page, int source) {
    return dio.get(BASE + "rest/staff/findByPid?pid=${pid}&page=${page}&source=${source}");
  }

  Future<Response> checkToken() {
    return dio.get(BASE + "rest/checkLogin");
  }

  void storeToken(String _token) {
    token = _token;
    sp.setString(TOKEN_KEY, token);
  }
}