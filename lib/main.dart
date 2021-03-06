import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'helper.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'login.dart';
import 'home.dart';
import 'Staff.dart';
import 'search.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:package_info/package_info.dart';
import 'qr.dart';
import 'package:device_info/device_info.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '二维码生成',
      home: LaunchPage(),
    );
  }
}

class LaunchPage extends StatelessWidget {
  static const platform = const MethodChannel('samples.flutter.io/battery');
  bool download;

  Future<dynamic> installApk(String filePath) {
    try {
      Map<String, String> map = new Map();
      map['filePath'] = filePath;
      return platform.invokeMethod('installApk', map);
    } on PlatformException catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    download = false;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      api.initSp(sp);

      if (Platform.isAndroid) {
        /*PermissionHandler()
            .checkPermissionStatus(PermissionGroup.storage)
            .then((PermissionStatus status) {
          if (status != PermissionStatus.granted) {
            PermissionHandler()
                .requestPermissions([PermissionGroup.storage]).then(
                    (Map<PermissionGroup, PermissionStatus> map) {
              if (map[PermissionGroup.storage] == PermissionStatus.granted) {
                goNext(context);
              }
            });
          } else {
            goNext(context);
          }
        });*/
      } else {
        checkUpdate(context);
      }
    });

    return Scaffold(
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  void checkUpdate(BuildContext context) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((IosDeviceInfo deviceInfo) {
        String uuid = deviceInfo.identifierForVendor;
        checkUpdateCore(context, uuid);
      });
    } else {
      checkUpdateCore(context, "");
    }
  }

  void checkUpdateCore(BuildContext context, String uuid) async {
    try {
      Response response = await api.checkUpdate2(
          Options(connectTimeout: 3000, receiveTimeout: 3000), uuid
      );
      if (response.data['success'] && response.data['data'] != null) {
        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          String newVersion = response.data['data']['version'];
          if (response.data['data']['msg'] != null) {
            checkToken(context);
            return;
          }

          if (packageInfo.version != newVersion) {
            showDialog<dynamic>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('发现新版本请前往appStore升级'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('确定'),
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrPage()),
                              (Route<dynamic> route) {
                            return false;
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => QrPage()),
                  (Route<dynamic> route) {
                return false;
              },
            );
          }
        });
      }
    } on DioError catch(e) {
      print(e);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => QrPage()),
            (Route<dynamic> route) {
          return false;
        },
      );
    }
  }

  void goNext(BuildContext context) async {
    Response response = await api.checkVersion();
    if (response.data['success'] && response.data['data'] != null) {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        String newVersion = response.data['data']['version'];
        if (packageInfo.version != newVersion) {
          String url = response.data['data']['url'];

          showDialog<dynamic>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('发现新版本请升级[$newVersion]'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('取消'),
                    onPressed: () async {
                      checkToken(context);
                    },
                  ),
                  FlatButton(
                    child: Text('确定'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      download = true;
                    },
                  ),
                ],
              );
            },
          )
        .then((dynamic d) async {
            if (download) {
              Directory directory = await getExternalStorageDirectory();
              String path = directory.path + '/tmp/app.apk';

              api.download(url, path).then((Response response) async {
                await installApk(path);
              });
            } else {
              checkToken(context);
            }
        });
        } else {
          checkToken(context);
        }
      });
    } else {
      checkToken(context);
    }
  }

  void checkToken(BuildContext context) async {
    Response response = await api.checkToken();
    if (response.data['success']) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyHomePage(staff: Staff(response.data['data']))),
        (Route<dynamic> route) {
          return false;
        },
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) {
          return false;
        },
      );
    }
  }
}
