// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() {
  test('test get', () async {
    Dio dio = new Dio();
    Response<String> response = await dio.get("https://www.sohu.com/");
    print(response.data);
  });

  test('test post', () async {
    Options options = new Options(
        baseUrl: "https://www.xx.com/api",
        connectTimeout: 5000,
        receiveTimeout: 3000,
        // contentType: ContentType.parse("application/x-www-form-urlencoded");
    );

    Dio dio = new Dio(options);

    dio.interceptor.request.onSend = (Options options) {
      // Do something before request is sent
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    };
    dio.interceptor.response.onSuccess = (Response response) {
      return response; // continue
    };
    dio.interceptor.response.onError = (DioError e) {
      return e; //continue
    };

    Response<String> response = await dio.post(
        "/test", data: {"id": 12, "name": "wendu"});
    print(response.data);
  });
}
