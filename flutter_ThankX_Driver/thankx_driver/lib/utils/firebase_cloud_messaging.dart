import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Review/review_page.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_details.dart';
import 'package:thankxdriver/layout/MyJobs/HistoryTab/history_details_page.dart';
import 'package:thankxdriver/layout/OrdersPage/notification_list/notifcation_view.dart';
import 'package:thankxdriver/layout/OrdersPage/notification_list/notification_list.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/utils.dart';


class FirebaseCloudMessagagingWapper extends Object {

  /* Notification type list */
  String orderClaimed = 'order_claimed';
  String get adminMessage => 'admin_message';
  String newOrderAlert = 'new_order_alter';
  String orderPicked = 'order_Picked';
  String orderDrop = 'order_drop';
  String review = 'new_review ';
  String newReview = 'new_review';
  String notAtHome = 'not_at_home';

/* - Driver
1: order_claimed when driver claimed the order
2: admin_message when send notification
3: new_order_alter new order alert
4: order_picked when driver picked the order from the location
5: order_drop when driver reached to destination or delivered the order
6: new_review when new review added
 */


  FirebaseMessaging _firebaseMessaging;
  Map<String, dynamic> pendingNotification;

  factory FirebaseCloudMessagagingWapper() {
    Logger().v("==================== FirebaseCloudMessagagingWapper =====================");
    return _singleton;
  }
  String _fcmToken = 'sgdsg454sdgdsg545';
  String get fcmToken => _fcmToken;

  final _notatHomeUpdate = PublishSubject<String>();
  Observable<String> get notAtHomeUpdate => _notatHomeUpdate.stream;

  static final FirebaseCloudMessagagingWapper _singleton = new FirebaseCloudMessagagingWapper._internal();
  FirebaseCloudMessagagingWapper._internal() {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseCloudMessagingListeners();
  }

  Future<String> getFCMToken() async {
    try {
      String token = await _firebaseMessaging.getToken();
      if (token != null) {
        _fcmToken = token;
        Logger().e("FCM Token $_fcmToken");
      }
      return token;
    } catch (e) {
      Logger().v("Error :: ${e.toString()}");
      return null;
    }
  }


  void _firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    Logger().v("==================== firebaseCloudMessagingListeners =====================");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        Logger().v("onMessage :: $message");
        Future.delayed(Duration(seconds: 1), () => this.displayNotificationView(payload: message));
        return null;
      },
      onResume: (Map<String, dynamic> message) {
        Logger().v("onResume :: $message");
        this.notificationOperation(payload: message);
        return null;
      },
      onLaunch: (Map<String, dynamic> message) {
        Logger().v("onLaunch :: $message");
        this.notificationOperation(payload: message);
//        this.pendingNotification = message;
        return null;
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});
  }

  performPendingNotificationOperation() {
    if (this.pendingNotification == null) { return; }
    this.notificationOperation(payload: this.pendingNotification);
    this.pendingNotification = null;
  }

  //region notificationOperation or input action
  void notificationOperation({Map<String, dynamic> payload}) {

    Logger().v(" Notification On tap Detected ");

    String notificationType = '';

    //parsing order id and Order Status
    String orderId ;
    int orderStatus ;

    if(Platform.isIOS){
      orderId = payload['orderId'] ?? "";
      orderStatus = int.parse((payload['orderStatus'] ?? 3).toString()) ?? 3;
      notificationType = payload['type'] ?? '';
    }else{
      Map<String, dynamic> notification = Utils.convertMap(payload['data'] ?? Map<String, dynamic>());
      notificationType = notification['type'] ?? '';
      orderId = notification['orderId'] ?? "";
      orderStatus = int.parse((notification['orderStatus'] ?? 3).toString()) ?? 3;
    }

    Logger().e(" Notification :: $notificationType");
    Logger().e(" OrderId :: ${orderId ?? ''}");
    if(notificationType.contains(notAtHome)){
      _notatHomeUpdate.sink.add(orderId);
    }

    if (notificationType == adminMessage) {
      var route = MaterialPageRoute(builder: (_) => NotificationList());
      NavigationService().push(route);
    }
    else if (notificationType == newReview) {
      var route = MaterialPageRoute(builder: (_) => ReviewPage());
      NavigationService().push(route);
    }
    else if((orderId != null) && (orderId != "")){
      Logger().v(" orderId :: $orderId orderStatus :: $orderStatus");
      // Setting Default Order Details With OrderId and Order status `
      OrderDetailsData order = OrderDetailsData();
      order.sId = orderId;
      order.orderId = orderId;
      order.orderStatus = orderStatus;

      if (orderStatus <= 4 &&orderStatus >= 3) {
        NavigationService().push(MaterialPageRoute(builder: (ctx)=>ClaimedOrderDetails(orders: order,)));
      }
      else if(orderStatus == 5){
        NavigationService().push(MaterialPageRoute(builder: (ctx)=>HistoryDetailsPage(order: order,)));
      }
    }
    else {
      var route = MaterialPageRoute(builder: (_) => NotificationList());
      NavigationService().push(route);
    }
  }
  //endregion

  //region notification action view
  void displayNotificationView({Map<String, dynamic> payload}) {

    String title = "ThankX";
    String body = "";

    Map<String, dynamic> notification = Map<String, dynamic>();

    if (Platform.isAndroid) {
      notification = Utils.convertMap(payload['notification'] ?? Map<String, dynamic>());
    } else {
      notification = Utils.convertMap(payload['aps'] ?? Map<String, dynamic>());
      notification = Utils.convertMap(notification['alert'] ?? Map<String, dynamic>());
    }

    String notificationType;
    String orderId ;
    if(Platform.isIOS){
      orderId = payload['orderId'] ?? "";
      notificationType = payload['type'] ?? "";
    }else{
      Map<String, dynamic> notification = Utils.convertMap(payload['data'] ?? Map<String, dynamic>());
      notificationType = notification['type'] ?? '';
      orderId = notification['orderId'] ?? "";
    }

    if(notificationType.contains(notAtHome)){
      _notatHomeUpdate.sink.add(orderId);
    }

    title = notification['title'] ?? title;
    body = notification['body'] ?? body;

    Logger().v("Display Notification view");

    showOverlayNotification((BuildContext _cont) {
      return NotificationView(title: title, subTitle: body, onTap: () {
        OverlaySupportEntry.of(_cont).dismiss();
        this.notificationOperation(payload: payload);
      },);
    }, duration: Duration(seconds: 4));
  }
  //endregion
}
