import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:thankx_user/utils/logger.dart';


typedef Future<dynamic> MessageHandler(Map<String, dynamic> message);

class PlatformChannel {

  factory PlatformChannel() {
    return _instance;
  }
//  PlatformChannel._internal();
  static PlatformChannel _instance = new PlatformChannel._internal();

  static const _channelName = "com.app.glide_golf";
  MethodChannel _platform = const MethodChannel(PlatformChannel._channelName);

  PlatformChannel._internal(){
    this._platform.setMethodCallHandler((MethodCall call) {
      Logger().e("call.method ${call.method}  call.arguments :: ${call.arguments}" );
      return;
    });
  }

  //region Get Screen Width
  Future<double> getScreenWidth() async {
    try {
      final double result = await _platform.invokeMethod('getScreenWidth');
      return result;
    } on PlatformException catch (e) {
      print("Exception :: ${e.message}");
      return 320.0;
    }
  }
  //endregion

  //region Get Screen Height
  Future<double> getScreenHeight() async {
    try {
      final double result = await _platform.invokeMethod('getScreenHeight');
      return result;
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return 568.0;
    }
  }
  //endregion

  //region Update Statusbar Color
  Future<void> updateStatusBarColor(List<int> colors) async {
    if (Platform.isIOS) {
      try {
        final double result = await _platform.invokeMethod('updateStatusBarColor', colors);
        return result;
      } on PlatformException catch (e) {
        Logger().e("Exception :: ${e.message}");
      }
    }
  }
  //endregion

  //region open App Setting
  Future<bool> openAppSetting() async {

    if (Platform.isAndroid) { return true; }
    try {
      final bool result = await _platform.invokeMethod('openSetting');
      if ((result != null) && (result is bool)) {
        return result;
      } else {
        return false;
      }
    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return false;
    }
  }
  //endregion

  //region Check for camera permission
  Future<bool> checkForCameraPermission() async {

    if (Platform.isAndroid) { return true; }
    try {
      final bool result = await _platform.invokeMethod('checkForCameraAccess');
      if ((result != null) && (result is bool)) {
        return result;
      } else {
        return false;
      }

    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return false;
    }
  }
  //endregion

  //region Check for photo permission
  Future<bool> checkForPhotoPermission() async {

    if (Platform.isAndroid) { return true; }

    try {
      final bool result = await _platform.invokeMethod('checkForPhotoAccess');
      if ((result != null) && (result is bool)) {
        return result;
      } else {
        return false;
      }

    } on PlatformException catch (e) {
      Logger().e("Exception :: ${e.message}");
      return false;
    }
  }
  //endregion

}



