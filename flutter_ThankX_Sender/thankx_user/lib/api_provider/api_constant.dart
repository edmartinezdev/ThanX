import 'dart:io';

import 'package:thankx_user/utils/device_utils.dart';
import 'package:thankx_user/utils/firebase_cloud_messaging.dart';
import 'package:thankx_user/utils/logger.dart';
import 'package:tuple/tuple.dart';

enum ApiType {
  login,
  signUp,
  logout,
}


class PreferenceKey {
  static String storeUser = "KUser";
  static String currentFilter = "KFilter";
}

class ApiConstant {

  static String get appleAppId => "";
  static String get andoridAppId => "com.app.thankxuser";
  static String get googlePlacesKey => "AIzaSyCjPmt5qYq0oNIKC2bI7kg61By18_q7cBk";


  static String get baseDomain => 'http://202.131.117.92:7023';
  static String get apiVersion => '/v1';
  static String get socketBaseUrl => 'http://202.131.117.92:7028/socket';
  static String get socketNameSpace => '/v1/xcode';


  static String getValue(ApiType type) {
    switch(type){
      case ApiType.login:
        return '/login';
      case ApiType.signUp:
        return '/register';
      case ApiType.logout:
        return '/logout';
        default:
        return "";
    }
  }
 /*
  * Tuple Sequence
  * - Url
  * - Header
  * - params
  * - files
  * */
  static Tuple4<String, Map<String, String>, Map<String, dynamic>, List<AppMultiPartFile>> requestParamsForSync(ApiType type, {Map<String, dynamic> params, List<AppMultiPartFile> arrFile = const [],String urlParams}) {
    String apiUrl = ApiConstant.baseDomain + ApiConstant.apiVersion + ApiConstant.getValue(type);

    if(urlParams!=null)
      apiUrl= apiUrl+urlParams;

    Map<String, dynamic> paramsFinal = params ?? Map<String,dynamic>();

    if ((type == ApiType.login) || (type == ApiType.signUp) ) {
      paramsFinal['device_type'] = DeviceUtil().deviceType;
      paramsFinal['device_id'] = DeviceUtil().deviceId;
//      paramsFinal['device_token'] = FirebaseCloudMessagagingWapper().fcmToken;
      paramsFinal['build_version'] = "v1";
    }
    if (type == ApiType.logout) {
      paramsFinal['device_id'] = DeviceUtil().deviceId;
    }


    Map<String, String> headers = Map<String, String>();
//    if (LoginData.currentUser.token != null) {
//      headers['Authorization'] = LoginData.currentUser.tokenType+" "+LoginData.currentUser.token;
//    }


    Logger().d("Request Url :: $apiUrl");
    Logger().d("Request Params :: $paramsFinal");
    Logger().d("Request headers :: $headers");

    return Tuple4(apiUrl, headers, paramsFinal, arrFile);
  }
}

class ResonseKeys {
  static String kMessage = 'message';
  static String kStatus = 'status';
  static String kToken = 'id_token';
  static String kId = 'id';
  static String kData = 'data';
}


class HttpResponse {
  bool status;
  String errMessage;
  dynamic json;

  HttpResponse({this.status, this.errMessage, this.json});
}

class AppMultiPartFile {
  List<File> localFile;
  String key;

  AppMultiPartFile({this.localFile, this.key});
}