package com.yourcompany.myapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/battery";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("installApk")) {
                    try {
                        installApk(String.valueOf(call.argument("filePath")));
                        result.success("success");
                    } catch (Exception e) {
                        result.error("error:", e.getMessage(), e);
                    }
                } else {
                  result.notImplemented();
                }
              }
            });
  }


  private void installApk(String fiePath) {
      Intent install = new Intent(Intent.ACTION_VIEW);
      install.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      File apkFile = new File(fiePath);
      install.setDataAndType(Uri.fromFile(apkFile), "application/vnd.android.package-archive");

      startActivity(install);
  }
}
