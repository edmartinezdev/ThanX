import 'dart:io';

import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/device_utils.dart';
import 'package:thankxdriver/utils/firebase_cloud_messaging.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:tuple/tuple.dart';


enum ApiType {
  login,
  signUp,
  checkEmailAndPhoneNumber,
  forgotPassword,
  addVehicleInfo,
  addW9Form,
  myJodsOrderList,
  currentOrderList,
  profileDetail,
  userProfileUpdate,
  driverDetail,
  driverUpdate,
  changeUserPassword,
  getCMSDetail,
  orderDetails,
  confirmOrderPickUp,
  dropOffOrder,
  claimOrder,
  getNotificationSetting,
  updateNotificationSetting,
  reviewList,
  logout,
  getNotificationList,
  deleteNotification,
  addBankDetails,
  paymentHistory,
  withdrawAmount,
  clearAllNtification,
  checkStripeAccount,
  getAllBankList,
  deleteBank,
  flagUser,
  flagAddress,
}


class PreferenceKey {
  static String storeUser = "KUser";
  static String storeVehicleInfo = "VUser";
  static String currentFilter = "KFilter";

}

class ApiConstant {

  static String get appleAppId => "";
  static String get andoridAppId => "com.app.thankxuser";
  static String get googlePlacesKey => "AIzaSyAY4kxXmqOibojTWCVszT5dhUZZoKl1QrE";
  static String get keyGoogleDistanceMatrix => 'AIzaSyB2jW_xplAVYcrctmUL1CK3Wexlw_8wep0';

  //static String get baseDomainin => 'http://35.225.98.185/';

  ///Live Base URL
  static String get baseDomain => 'https://thankx.admindd.com/';

  ///Local Base URL
  // static String get baseDomain => 'http://202.131.117.92:7046/';

  static String get apiVersion => 'v5';

  static String get thankxContactUs => "thankx@thankx.com" ;

  static String getValue(ApiType type) {

    switch(type){
      case ApiType.login:
        return '/auth/login';
      case ApiType.signUp:
        return '/auth/signup';
      case ApiType.checkEmailAndPhoneNumber:
        return '/auth/checkEmailAndPhoneNumber';
      case ApiType.forgotPassword:
        return '/auth/forgotPassword';
      case ApiType.addVehicleInfo:
        return '/api/addVehicleInfo';
      case ApiType.addW9Form:
        return '/api/addW9Form';
      case ApiType.myJodsOrderList:
        return '/api/myJobList';
      case ApiType.currentOrderList:
        return '/api/currentOrderList';
      case ApiType.profileDetail:
        return '/api/getUserProfile';
      case ApiType.userProfileUpdate:
        return '/api/updateProfile';
      case ApiType.driverDetail:
        return '/api/getVehicleDetails';
      case ApiType.driverUpdate:
        return '/api/editVehicleDetails';
      case ApiType.changeUserPassword:
        return '/api/changePassword';
      case ApiType.getCMSDetail:
        return '/auth/getAppInfo';
      case ApiType.orderDetails:
        return '/api/orderDetails';
      case ApiType.claimOrder:
        return '/api/claimOrder';
      case ApiType.confirmOrderPickUp:
        return '/api/pickupOrder';
      case ApiType.dropOffOrder:
        return '/api/dropoffOrder';
      case ApiType.getNotificationSetting:
        return '/api/getNotificationSetting';
      case ApiType.updateNotificationSetting:
        return '/api/createAndUpdateNotifySetting';
      case ApiType.reviewList:
        return '/api/getDriverReview';
      case ApiType.logout:
        return '/api/logout';
      case ApiType.getNotificationList:
        return '/api/notificationList';
      case ApiType.deleteNotification:
        return '/api/deleteNotification';
      case ApiType.addBankDetails:
        return '/api/addBankAccount';
      case ApiType.paymentHistory:
        return '/api/paymentHistory';
      case ApiType.withdrawAmount:
        return '/api/withdrawAmount';
      case ApiType.clearAllNtification:
        return '/api/clearNotifications';
      case ApiType.checkStripeAccount:
        return '/api/checkStripeAccount';
      case ApiType.getAllBankList:
        return '/api/getAllBankList';
      case ApiType.deleteBank:
        return '/api/delete_bank_account';
      case ApiType.flagUser:
        return '/api/flagUser';
      case ApiType.flagAddress:
        return '/api/flagAddress';
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

      paramsFinal['deviceType'] = DeviceUtil().deviceType;
      paramsFinal['deviceId'] = DeviceUtil().deviceId;
      paramsFinal['fcm_token'] = FirebaseCloudMessagagingWapper().fcmToken;
      paramsFinal['userType'] = "2";
    }
    if (type == ApiType.logout) {
      paramsFinal['deviceId'] = DeviceUtil().deviceId;
    }
    if(type == ApiType.forgotPassword){
      paramsFinal['userType'] = "2";
    }

    Map<String, String> headers = Map<String, String>();
    if (User.currentUser.accessToken != null) {
      headers['Authorization'] = User.currentUser.accessToken;
    }


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