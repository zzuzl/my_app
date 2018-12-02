import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final _qrController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String info = 'Unknow';

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo deviceInfo) {
        setState(() {
          info = deviceInfo.utsname.machine;
        });
      });
    } else if (Platform.isAndroid) {
      deviceInfo.androidInfo.then((AndroidDeviceInfo deviceInfo) {
        setState(() {
          info = deviceInfo.model;
        });
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('二维码生成'),
        ),
        body: iosView());
  }

  Widget iosView() {
    return ListView(
      children: <Widget>[
        Text('设备信息：${info}'),
        TextField(
            decoration: InputDecoration(
              labelText: '二维码数据：',
            ),
            controller: _qrController),
        RaisedButton(
          child: new Text("生成"),
          onPressed: () async {
            setState(() {});
          },
        ),
        Center(
          child: new QrImage(
            data: _qrController.text == null
                ? "https://www.google.com/"
                : _qrController.text,
            size: 200.0,
          ),
        )
      ],
    );
  }
}
