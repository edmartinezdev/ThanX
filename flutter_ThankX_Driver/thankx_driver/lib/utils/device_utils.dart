import 'dart:io';

import 'package:device_info/device_info.dart';
import 'logger.dart';

class DeviceUtil {
  factory DeviceUtil() {
    return _singleton;
  }

  static final DeviceUtil _singleton = DeviceUtil._internal();

  DeviceUtil._internal() {
    Logger().v("Instance created DevideUtil");
  }

  String currentLanguageCode = "en";
  String _deviceId = 'sgdsg454sdgdsg545';
  String get deviceId => _deviceId;

  String get deviceType => Platform.isIOS ? 'ios' : 'android';

  Future<void> updateDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    }
  }
}