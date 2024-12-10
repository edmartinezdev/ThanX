//import 'dart:io' show Platform;
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//
//import 'package:overlay_support/overlay_support.dart';
//import 'package:thankx_user/utils/ui_utils.dart';
//
//import 'app_color.dart';
//import 'app_font.dart';
//import 'common_widget.dart';
//import 'logger.dart';
//
//
//class FirebaseCloudMessagagingWapper extends Object {
//
//  FirebaseMessaging _firebaseMessaging;
//  String _fcmToken = "12345648789";
//  String get fcmToken => _fcmToken;
//
//  factory FirebaseCloudMessagagingWapper() {
//    return _singleton;
//  }
//
//  static final FirebaseCloudMessagagingWapper _singleton = new FirebaseCloudMessagagingWapper._internal();
//  FirebaseCloudMessagagingWapper._internal() {
//    _firebaseMessaging = FirebaseMessaging();
//    firebaseCloudMessagingListeners();
//  }
//
//
//  Future<String> getFCMToken() async {
//    try {
//      _fcmToken = await _firebaseMessaging.getToken();
//      Logger().v("===== FCM Token :: $_fcmToken =====");
//      return _fcmToken;
//    } catch (e) {
//      print("Error :: ${e.toString()}");
//      return null;
//    }
//  }
//
//
//  void firebaseCloudMessagingListeners() {
//    if (Platform.isIOS) iOSPermission();
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) {
//        print("onMessage :: $message");
//        Future.delayed(Duration(seconds: 1), () => this.notificationOperation(payload: message));
//        return null;
//      },
//      onResume: (Map<String, dynamic> message) {
//        print("onResume :: $message");
//        return null;
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print("onLanuch :: $message");
//        return null;
//      },
//    );
//  }
//
//  void iOSPermission() {
//    _firebaseMessaging.requestNotificationPermissions(
//        IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {});
//  }
//
////region notificationOperation or input action
//  void notificationOperation({Map<String, dynamic> payload, isOnResume =false}) {
//
//    Logger().v(" Notification On tap Detected ");
//
//
//
//    String notificationType = payload["notification_type"];
//    if (notificationType == "TYPE") {
////      ChatMessage message = ChatMessage.fromNotificationPayload(payload);
////      final chatPage = ChatPage(chatMessage: message,);
////      final MaterialPageRoute route = MaterialPageRoute(builder: (_) => chatPage);
////      Navigator.of(this._context).push(route);
//    }
////    else if (notificationType == "resource") {
//////      final resourcePage = ResourcesDetailsPage(resourceId: payload["resourceId"],);
//////      final MaterialPageRoute route = MaterialPageRoute(builder: (_) => resourcePage);
//////      Navigator.of(this._context).push(route);
////    }
//  }
////endregion
//
////region notification action view
//  void displayNotificationView({Map<String, dynamic> payload}) {
//
//
//    String title = "Glide Golf";
//    String body = "";
//
////    if (message != null) {
////      title = message.senderName;
////      body = message.message;
////    } else {
////
//      String notificationType = payload["notification_type"];
////      if (notificationType == "send_message") {
////        return;
////      }
//
//      if (notificationType == "TYPE") {
//        title = payload["title"];
//        body = payload["body"];
//    }
//
//  Logger().v(" display notification view------- ");
//    showOverlayNotification((BuildContext _cont) {
//      return NotificationView(title: title, subTitle: body, onTap: () {
//        OverlaySupportEntry.of(_cont).dismiss();
////        if (message != null) {
//////          final ChatPage chatPage = ChatPage(chatMessage: message,);
//////          final MaterialPageRoute route = MaterialPageRoute(builder: (_) => chatPage);
//////          Navigator.of(this._context).push(route);
////        }
////        else {
//          this.notificationOperation(payload: payload);
////        }
//      },);
//    }, duration: Duration(milliseconds: 3000));
//  }
//  //endregion
//
//}
//
//class NotificationView extends StatelessWidget {
//
//  String title = "";
//  String subTitle = "";
//  final VoidCallback onTap;
//
//  NotificationView({this.title, this.subTitle,this.onTap});
//
//  @override
//  Widget build(BuildContext context) {
//
//    final textStyleTitle = UIUtills().getTextStyleRegular(fontSize: 13, fontName: AppFont.robotoMedium, color: AppColor.textColor);
//    final textStyleSubtitle = UIUtills().getTextStyleRegular(fontSize: 11, fontName: AppFont.robotoRegular, color: AppColor.textColor);
//    final textTitle = Text(this.title, style: textStyleTitle);
//    final textSubTitle = Text(this.subTitle, style: textStyleSubtitle, maxLines: 3,);
//    final columnText = Column(children: <Widget>[textTitle, Padding(padding: EdgeInsets.only(top: 3)), textSubTitle], crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,);
//    final double textContainerWidth = UIUtills().screenWidth - (20.0 + 20.0 +  15.0);
//    final textContainer = Container(child: columnText, width: textContainerWidth,);
//
//    final row = Row(children: <Widget>[
////      userIconClip,
//      Padding(padding: EdgeInsets.only(left: 15.0)),
//      textContainer
//    ],);
//
//    final boxDecoration = CommonWidget.createRoundedBoxWithShadow(radius: 5.0);
//    final containerNotifcationView = Container(decoration: boxDecoration, child: row, padding: EdgeInsets.all(10.0),);
//
//    final containerMain = Container(child: containerNotifcationView, color: Colors.transparent, padding: EdgeInsets.all(10.0), width: UIUtills().screenWidth,);
//    final containerInkWell = InkWell(child: SafeArea(child: containerMain, bottom: false,), onTap: () {
//      // perform notification action
//      if (this.onTap != null) {
//        this.onTap();
//      }
//    },);
//    return Material(child: containerInkWell,);
//  }
//}
