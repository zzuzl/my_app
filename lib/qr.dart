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
  IosDeviceInfo iosInfo;
  GlobalKey globalKey = GlobalKey(debugLabel: 'QrPage');
  GlobalKey _scaffoldKey = GlobalKey(debugLabel: 'Scaffold');
  static const platform = const MethodChannel('cn.zlihj/zjdp');

  Future<void> savePhoto(String path) async {
    try {
      await platform.invokeMethod('savePhoto', [path]);
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo deviceInfo) {
        setState(() {
          this.iosInfo = deviceInfo;
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
              Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                          decoration: InputDecoration(
                            labelText: '输入二维码数据或URL自动刷新',
                          ),
                          controller: _qrController),
                      RepaintBoundary(
                          key: globalKey,
                          child: Center(child: new QrImage(
                            data: _qrController.text == null
                                ? ""
                                : _qrController.text,
                            version: 6,
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

                          String tempDir = (await getTemporaryDirectory()).path;
                          String path = '${tempDir}/${new DateTime.now().millisecondsSinceEpoch}.png';
                          await new File(path).writeAsBytes(pngBytes);

                          if (Platform.isIOS) {
                            savePhoto(path);
                          }

                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('已保存：$path'),
                          ));
                        },
                      ),
                      ListTile(
                        title: Text('设备名称'),
                        subtitle: Text(iosInfo == null ? '' : iosInfo.name),
                      ),
                      ListTile(
                        title: Text('设备型号'),
                        subtitle: Text(iosInfo == null ? '' : iosInfo.utsname.machine),
                      ),
                      ListTile(
                        title: Text('UUID'),
                        subtitle: Text(iosInfo == null ? '' : iosInfo.identifierForVendor),
                          trailing: IconButton(
                            icon: const Icon(Icons.content_copy),
                            onPressed: () {
                              if (iosInfo != null) {
                                Clipboard.setData(new ClipboardData(text: iosInfo.identifierForVendor));
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('已复制到剪切板'),
                                ));
                              }
                            },
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
