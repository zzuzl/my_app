import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'Company.dart';
import 'Project.dart';
import 'demo.dart';

class Api {
  static String token = "";
  static const String TOKEN_KEY = "token";
  static const String BASE = "http://www.zlihj.cn/";
  static final Dio dio = new Dio();
  static SharedPreferences sp = null;

  List<Category> _types = new List();

  Api() {
    dio.interceptor.request.onSend = (Options options) {
      options.contentType=ContentType.parse("application/x-www-form-urlencoded");
      options.headers = {TOKEN_KEY: token};

      return options;
    };
    dio.interceptor.response.onSuccess = (Response response) {
      String token = response.headers.value(TOKEN_KEY);
      if (token != null && token.length > 0) {
        storeToken(token);
      }

      return response; // continue
    };
    /*dio.interceptor.response.onError = (DioError e){
      return  e;//continue
    };*/
  }

  void initSp(SharedPreferences s) {
    /*const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });*/
    sp = s;
    token = sp.getString(TOKEN_KEY);
    print('init token:${token}');
  }

  List<Category> get types => _types;

  Future<Response> login(String email, String password) {
    return dio.post(BASE + "rest/staff/login", data: {
      "user": email,
      "password": password
    });
  }

  void logout() {
    sp.remove(TOKEN_KEY);
  }

  Future<Response> search(String key) {
    return dio.get(BASE + "rest/search?key=${key}");
  }

  Future<Response> listCompany(int pid) {
    return dio.get(BASE + "rest/company/list?pid=${pid}");
  }

  Future<Response> listProject(int pid) {
    return dio.get(BASE + "rest/project/list?pid=${pid}");
  }

  Future<Response> listStaff(int pid, int page, int source, int type) {
    return dio.get(BASE + "rest/staff/findByPid?pid=${pid}&page=${page}&source=${source}&type=${type}");
  }

  Future<Response> getStaff(int id) {
    return dio.get(BASE + "rest/staff/findById?id=${id}");
  }

  Future<Response> getCompany(int id) {
    return dio.get(BASE + "rest/company/findById?id=${id}");
  }

  Future<Response> getProject(int id) {
    return dio.get(BASE + "rest/project/findById?id=${id}");
  }

  Future<Response> checkToken() {
    dio.get(BASE + "rest/resource/workTypes").then((Response response) {
      if (response.data['success'] && response.data['data'] != null) {
        this._types.clear();
        for (Map map in response.data['data']) {
          this._types.add(Category(name: map['name'], type: map['type']));
        }
      }
    });
    return dio.get(BASE + "rest/checkLogin");
  }

  Future<Response> download(String uri, String savePath) {
    return dio.download(uri, savePath);
  }

  Future<Response> checkVersion() {
    return dio.get(BASE + "rest/checkVersion");
  }

  Future<Response> checkUpdate() {
    return dio.get(BASE + "rest/checkVersion?platform=" + Platform.operatingSystem);
  }

  Future<Response> checkUpdate2(Options options, String uuid) {
    return dio.get(BASE + "rest/checkVersion?uuid=${uuid}&platform=" + Platform.operatingSystem, options: options);
  }

  void storeToken(String _token) {
    token = _token;
    sp.setString(TOKEN_KEY, token);
  }
}