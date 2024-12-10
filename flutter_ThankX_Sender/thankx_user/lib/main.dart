import 'package:flutter/material.dart';
import 'package:thankx_user/utils/device_utils.dart';
import 'localization/app_model.dart';
import 'localization/language_scope_wrapper.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Wait until setup reachbility
//  Reachability reachability = Reachability();
//  await reachability.setUpConnectivity();
//  Logger().v("Network status : ${reachability.connectStatus}");

  // Update FCM Token
  await DeviceUtil().updateDeviceInfo();


//  bool isUserLogin = await LoginData.isUserLogin();
//  print("isUser Login"+isUserLogin.toString());
//  if (isUserLogin) { // wait untill user details load
//    await LoginData.currentUser.loadPastUserDetails();
//  }

//  FirebaseCloudMessagagingWapper().getFCMToken();
//  Future.delayed(Duration(seconds: 3), () async {
//    await FirebaseCloudMessagagingWapper().getFCMToken();
//  });

//
//  PlatformChannel channel = PlatformChannel();
//  var screenWidth = await channel.getScreenWidth();
//  var screenHeight = await channel.getScreenHeight();
//  UIUtills().updateScreenDimesion(width: screenWidth, height: screenHeight);


  /// Retrive Device language
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  String deviceLang = prefs.getString('CurrentDeviceLanguage') ?? 'en';
//  deviceLang = 'en';
//  await prefs.setString('CurrentDeviceLanguage', deviceLang);
//
//  Logger().v("_screenWidth : ${UIUtills().screenWidth} _screenHeight : ${UIUtills().screenHeight} ");

//  PluginGooglePlacePicker.initialize(androidApiKey: ApiConstant.googlePlacesKey, iosApiKey: ApiConstant.googlePlacesKey,);

  AppModel appModel = AppModel("en");
  runApp(new ScopeModelWrapper(appModel: appModel,isUserLogin: false,));
}


