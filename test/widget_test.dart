// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:my_app/helper.dart';
import 'package:my_app/Company.dart';

void main() {
  test('test get', () async {
    Dio dio = new Dio();

    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    dio.options.headers = {
      "token": ".eyJpc3MiOiI2NzIzOTkxNzFAcXEuY29tIiwiZXhwIjoxNTQyMDA3OTM5fQ.KZbzxFsL4hJBH_tZWmQGLAjaRswYcY05EVPFF4XOJ_c"
    };
    dio.interceptor.response.onSuccess = (Response response) {
      return response; // continue
    };
    dio.interceptor.response.onError = (DioError e) {
      return e; //continue
    };

    Response response = await dio.post("http://localhost:8080/rest/staff/login", data: {
       "user": "672399171@qq.com",
       "password": "123456.com"
    });
    // Response response = await dio.get("http://localhost:8080/rest/company/list?pid=0");

    print(response.data.toString());
  });

  test('test api', () async {
    /*Response response = await api.login("672399171@qq.com", "123456.com");
    api.storeToken(response.data['msg']);*/

    Response response = await api.listCompany(0);
    print(response.data);
    Company company = new Company(response.data['data'][0]);
    print(company);
  });
}
