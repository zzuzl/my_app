import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:ui' as ui;

class QrPage extends StatefulWidget {

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final _qrController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String info = 'Unknow';
  GlobalKey globalKey = GlobalKey(debugLabel: 'QrPage');
  GlobalKey _scaffoldKey = GlobalKey(debugLabel: 'Scaffold');

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo deviceInfo) {
        setState(() {
          info = deviceInfo.identifierForVendor;
          Clipboard.setData(new ClipboardData(text: info));
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
          title: Text('二维码工具'),
        ),
        body: Builder(builder: (context) {
          return ListView(
            children: <Widget>[
              Text('输入二维码数据自动刷新二维码'),
              TextField(
                  decoration: InputDecoration(
                    labelText: '二维码数据或URL',
                  ),
                  controller: _qrController),
              RepaintBoundary(
                  key: globalKey,
                  child: Center(child: new QrImage(
                    data: _qrController.text == null
                        ? "https://www.google.com/"
                        : _qrController.text,
                    size: 200.0,
                  ),)
              ),
              RaisedButton(
                child: new Text("保存"),
                onPressed: () async {
                  RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
                  ui.Image image = await boundary.toImage();
                  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                  Uint8List pngBytes = byteData.buffer.asUint8List();
                  String path = '/tmp/${new DateTime.now().millisecondsSinceEpoch}.png';
                  print(path);
                  new File(path).writeAsBytes(pngBytes);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('已保存：$path'),
                  ));
                },
              ),
            ],
          );
        }));
  }
}
