//import 'package:flutter/material.dart';
//import 'package:glide_golf/utils/firebase_cloud_messaging.dart';
//import 'package:glide_golf/utils/logger.dart';
//
//typedef NotificaitonChatMessageCallback = bool Function();
//
//class NotificationManager {
//
//  factory NotificationManager() {
//    return _singleton;
//  }
//
//  static final NotificationManager _singleton = NotificationManager._internal();
//
//  NotificationManager._internal() {
//    print("Instance created NotificationManager");
//  }
//
//  BuildContext _context;
//  BuildContext get context => this._context;
//
//  String _fcmToken = 'sgdsg454sdgdsg545';
//  String get fcmToken => _fcmToken;
//
//  Future<String> updateFCMToken() async {
//    String token = await FirebaseCloudMessagagingWapper().getFCMToken();
//    Logger().v("Firebase FCM Token :: $token}");
//    _fcmToken = token;
//    return token;
//  }
//
//  void assignCurrentPageContext(BuildContext conxt) {
//    this._context = conxt;
//  }
//
//
////  void registerForMessageUpdate() {
////    PlatformChannel().configure(
////      onMessage: (Map<String, dynamic> message) async {
////        Logger().v('on message $message');
////        ApiProvider().lastRequestToken.cancel("Request Cancelled"); // Cancel Last Request Call
////        Future.delayed(Duration(seconds: 1), () => this.notificationOperation(payload: message));
////        //Future.delayed(Duration(seconds: 1), () => this.displayNotificationView(payload: message));
////      },
////      onResume: (Map<String, dynamic> message) async {
////        Logger().v('on resume $message');
////        this.notificationOperation(payload: message,isOnResume: true);
////      },
////      onLaunch: (Map<String, dynamic> message) async {
////        Logger().v('on launch $message');
////        if(ApiProvider().lastRequestToken != null) {
////          ApiProvider().lastRequestToken.cancel("Request Cancelled"); // Cancel Last Request Call
////        }
////        Future.delayed(Duration(seconds: 2), () => this.notificationOperation(payload: message));
////      },
////    );
////  }
//
//
//  //region notification action view
////  void displayNotificationView({Map<String, dynamic> payload, ChatMessage message}) {
////
////
////    String title = "Subleasey";
////    String subTitle = "";
////
////    if (message != null) {
////      title = message.senderName;
////      subTitle = message.message;
////    } else {
////      String notificationType = payload["type"];
////      if (notificationType == "send_message") {
////        return;
////      }
////
////      if (notificationType == "resource") {
////        title = payload["title"];
////        subTitle = payload["message"];
////      }
////    }
////
////
////    Logger().v(" display notification view------- ");
////    showOverlayNotification((BuildContext _cont) {
////      return NotificationView(title: title, subTitle: subTitle, onTap: () {
////        OverlaySupportEntry.of(_cont).dismiss();
////        if (message != null) {
////          final ChatPage chatPage = ChatPage(chatMessage: message,);
////          final MaterialPageRoute route = MaterialPageRoute(builder: (_) => chatPage);
////          Navigator.of(this._context).push(route);
////        }
////        else {
////          this.notificationOperation(payload: payload);

////        }
////      },);
////    }, duration: Duration(milliseconds: 3000));
////  }
//  //endregion
//
//  //region notificationOperation or input action
////  void notificationOperation({Map<String, dynamic> payload, isOnResume =false}) {
////
////    Logger().v(" Notification On tap Detected ");
////
////    if (this._context == null) {
////      Logger().e("Navigation Object page context null");
////      return;
////    }
//
////    String notificationType = payload["type"];
////    if (notificationType == "send_message") {
////      ChatMessage message = ChatMessage.fromNotificationPayload(payload);
////      final chatPage = ChatPage(chatMessage: message,);
////      final MaterialPageRoute route = MaterialPageRoute(builder: (_) => chatPage);
////      Navigator.of(this._context).push(route);
////    }
////    else if (notificationType == "resource") {
////      final resourcePage = ResourcesDetailsPage(resourceId: payload["resourceId"],);
////      final MaterialPageRoute route = MaterialPageRoute(builder: (_) => resourcePage);
////      Navigator.of(this._context).push(route);
////    }
//  }
////endregion
////}
//
////class NotificationView extends StatelessWidget {
////
//////  final ChatMessage chatMessage;
////  String title = "";
////  String subTitle = "";
////  final VoidCallback onTap;
////
////  NotificationView({this.title, this.subTitle,this.onTap});
////
////  @override
////  Widget build(BuildContext context) {
////
////    final textStyleTitle = UIUtils().getTextStyleRegular(fontsize: 13, fontName: AppFont.robotoMedium, color: AppColor.blackColor);
////    final textStyleSubtitle = UIUtils().getTextStyleRegular(fontsize: 11, fontName: AppFont.robotoRegular, color: AppColor.blackColor);
////    final textTitle = Text(this.title, style: textStyleTitle);
////    final textSubTitle = Text(this.subTitle, style: textStyleSubtitle, maxLines: 3,);
////    final columnText = Column(children: <Widget>[textTitle, Padding(padding: EdgeInsets.only(top: 3)), textSubTitle], crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,);
////    final double textContainerWidth = UIUtils().screenWidth - (20.0 + 20.0 +  15.0);
////    final textContainer = Container(child: columnText, width: textContainerWidth,);
////
////    final row = Row(children: <Widget>[
//////      userIconClip,
////      Padding(padding: EdgeInsets.only(left: 15.0)),
////      textContainer
////    ],);
////
////    final boxDecoration = CommonWidget.createRoundedBoxWithShadow(radius: 5.0);
////    final containerNotifcationView = Container(decoration: boxDecoration, child: row, padding: EdgeInsets.all(10.0),);
////
////    final containerMain = Container(child: containerNotifcationView, color: Colors.transparent, padding: EdgeInsets.all(10.0), width: UIUtils().screenWidth,);
////    final containerInkWell = InkWell(child: SafeArea(child: containerMain, bottom: false,), onTap: () {
////      // perform notification action
////      if (this.onTap != null) {
////        this.onTap();
////      }
////    },);
////    return Material(child: containerInkWell,);
////  }
////}
