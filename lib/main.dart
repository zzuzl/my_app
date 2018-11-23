import 'package:flutter/material.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'login.dart';
import 'home.dart';
import 'Staff.dart';
import 'search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '中原分公司数字人事',
      home: LaunchPage(),
    );
  }
}

class LaunchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      api.initSp(sp);

      // 检查最新版本
      String newVersion = "1.0.1";

      if (Platform.isAndroid) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('发现新版本请升级'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定'),
                  onPressed: () async {
                    String path = './app.apk';
                    api.download('https://zlihj-zpk-1251746773.cos.ap-beijing.myqcloud.com/app-release.apk', path);
                    String url = 'file://' + path;
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        checkToken(context);
      }
    });

    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void checkToken(BuildContext context) async {
    Response response = await api.checkToken();
    if (response.data['success']) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(staff: Staff(response.data['data']))),
            (Route<dynamic> route) { return false; },
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) { return false; },
      );
    }
  }

}