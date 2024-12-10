import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/device_utils.dart';
import 'package:thankxdriver/utils/firebase_cloud_messaging.dart';

import 'api_provider/reachability.dart';
import 'localization/app_model.dart';
import 'localization/language_scope_wrapper.dart';
import 'utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Wait until setup reachbility
  Reachability reachability = Reachability();
  await reachability.setUpConnectivity();
  Logger().v("Network status : ${reachability.connectStatus}");

  // Update FCM Token
  await DeviceUtil().updateDeviceInfo();

  bool isUserLogin = await User.isUserLogin();
  print("==========================isUser Login" + isUserLogin.toString());
  if (isUserLogin) {
    // wait untill user details load
    await User.currentUser.loadPastUserDetails();
  }

  Future.delayed(Duration(seconds: 3), () async {
    await FirebaseCloudMessagagingWapper().getFCMToken();
  });

  PluginGooglePlacePicker.initialize(
    androidApiKey: "AIzaSyB0F_sMOm_1BPPjamdbKacFxwHjaoF_a5Q",
    iosApiKey: "AIzaSyB0F_sMOm_1BPPjamdbKacFxwHjaoF_a5Q",
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  AppModel appModel = AppModel("en");
  runApp(new ScopeModelWrapper(
    appModel: appModel,
    isUserLogin: isUserLogin,
  ));
}
