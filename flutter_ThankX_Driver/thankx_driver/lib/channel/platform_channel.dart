import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart' as Loc;
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/ui_utils.dart';



typedef Future<dynamic> MessageHandler(Map<String, dynamic> message);

class PlatformChannel {

  factory PlatformChannel() {
    return _instance;
  }
//  PlatformChannel._internal();
  static PlatformChannel _instance = new PlatformChannel._internal();
  String _trackingRunningForCurrentOrder = "";

  static const _channelName = "com.app.ThankXDriver";
  MethodChannel _platform = const MethodChannel(PlatformChannel._channelName);

  PlatformChannel._internal(){
    this._platform.setMethodCallHandler((MethodCall call) {
      Logger().e("call.method ${call.method}  call.arguments :: ${call.arguments}" );
      return;
    });
  }

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

//  //region open App Setting
//  Future<bool> openAppSetting() async {
//
//    if (Platform.isAndroid) { return true; }
//    try {
//      final bool result = await _platform.invokeMethod('openSetting');
//      if ((result != null) && (result is bool)) {
//        return result;
//      } else {
//        return false;
//      }
//    } on PlatformException catch (e) {
//      Logger().e("Exception :: ${e.message}");
//      return false;
//    }
//  }
//  //endregion


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

  Future<bool> checkForMailSend() async {
    try {
      if (Platform.isIOS) {
        final bool result = await this._platform.invokeMethod('checkForMailSend');
        Logger().v("checkForMailSend Result :: $result");
        return result ?? false;
      } else {
        return true;
      }
    } on PlatformException catch (e) {
      print("Exception :: ${e.message}");
      return false;
    }
  }
  //endregion

  //region Start Location Service
  Future startLocationService({String orderId, String customerId}) async {
    if (this._trackingRunningForCurrentOrder == orderId) { return; }
    try {
      Map<String, dynamic> argument = Map<String, dynamic>();
      argument['orderId'] = orderId;
      argument['customerId'] = customerId;
      argument['driverId'] = User.currentUser.sId;
      Logger().v("Start Location Service For Order :: ${orderId})");
      final String result = await this._platform.invokeMethod("startLocationService", argument);
      this._trackingRunningForCurrentOrder = orderId;
      Logger().v("Start Location Service Result :: ${result}");
    } catch (e) {
      Logger().e("PlatForm Exception :: $e");
    }
  }
  //endregion


  //region Stop Location Service
  Future stopLocationService() async {
    try {
      final dynamic result = await this._platform.invokeMethod("stopLocationService");
      Logger().v("Stop Location service Result :: ${result}");
      this._trackingRunningForCurrentOrder = "";
    } catch (e) {
      Logger().e("PlatForm Exception :: $e");
    }
  }
  //endregion



//region Check for permission group
  Future<bool> checkForPermission(PermissionGroup group) async {
    if (Platform.isIOS) {
      bool result = await this._checkContactPermissionForIOS(group);
      return result;
    } else if (Platform.isAndroid) {
      bool result = await this._checkContactPermissionForAndroid(group);
      return result;
    } else {
      return false;
    }
  }

  Future<bool> _checkContactPermissionForIOS(PermissionGroup group) async {
      Logger().v("PermissionGroup :: $group");
      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(group);
      Logger().v(" PermissionStatus :: $permission");
      if (permission == PermissionStatus.granted) {
        return true;
      }
      else if (permission == PermissionStatus.unknown) {
        Logger().v("PermissionGroup :: $group");
        Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([group]);
        return permissions[group] == PermissionStatus.granted;
      }
      else {
        return false;
      }
//    }
  }

  Future<bool> _checkContactPermissionForNeverAsk(PermissionGroup group) async {
    Logger().v("_checkLocationPermissionForNeverAsk");
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([group]);
    var askPermission = permissions[group];
    Logger().v(" PermissionStatus :: $askPermission");
    if (askPermission == PermissionStatus.granted) {
      return true;
    } else if (askPermission == PermissionStatus.neverAskAgain) {
      return false;
    } else {
      bool status = await this._checkContactPermissionForNeverAsk(group);
      return status;
    }
  }


  Future<bool> _checkContactPermissionForAndroid(PermissionGroup group) async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(group);
    Logger().v(" PermissionStatus :: $permission");
    if (permission == PermissionStatus.granted) {
      return true;
    }
    else if  (permission == PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([group]);
      var askPermission = permissions[group];
      Logger().v(" PermissionStatus :: $askPermission");
      if (askPermission == PermissionStatus.granted) {
        return true;
      } else if (askPermission == PermissionStatus.neverAskAgain) {
        return false;
      } else {
        bool status = await this._checkContactPermissionForNeverAsk(group);
        return status;
      }
    }
    else if (permission == PermissionStatus.neverAskAgain) {
      return false;
    }
    return false;
  }

  Future<bool> openAppSetting() async {
    bool isOpened = await PermissionHandler().openAppSettings();
    return isOpened;
  }

  Future<LatLng> getLocation() async {
    final BuildContext context = NavigationService().navigatorKey.currentState.overlay.context;
    if (Platform.isIOS) {
      Loc.Location location = Loc.Location();
      final locationData = await location.getLocation();
      return LatLng(locationData.latitude, locationData.longitude);
    } else {
      UIUtills().showProgressDialog(context);
      try {
        final Geo.Geolocator geolocator = Geo.Geolocator();
        geolocator.forceAndroidLocationManager = true;

        final _currentPosition = await geolocator.getCurrentPosition(desiredAccuracy: Geo.LocationAccuracy.medium);

        UIUtills().dismissProgressDialog(context);
        Logger().v("Location :: latitude:${_currentPosition.latitude} longitude:${_currentPosition.longitude}");
        return LatLng(_currentPosition.latitude, _currentPosition.longitude);
      } catch(exception){
        UIUtills().dismissProgressDialog(context);
        Logger().v("Location not available");
        return LatLng(40.0024137, -75.2581112);
      }
    }
  }
}



