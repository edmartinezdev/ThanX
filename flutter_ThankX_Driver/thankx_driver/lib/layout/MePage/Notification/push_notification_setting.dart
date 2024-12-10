import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/notification_bloc.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

enum NotificaionType { newReviewReceived, confirmOrder, newOrder, orderStatus }

class PushNotificaionSettingPage extends StatefulWidget {
  @override
  _PushNotificaionSettingPageState createState() =>
      _PushNotificaionSettingPageState();
}

class _PushNotificaionSettingPageState extends State<PushNotificaionSettingPage> {
  final NotificationBloc _notificationBloc = NotificationBloc();
  StreamSubscription<NotificationSettingResponse>
      _getNotificationSettingSubscription;
  StreamSubscription<UpdateNotificationSettingResponse>
      _updateNotificaionSettingSubscription;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
        () => getNotificationSettingApi());
    super.initState();
  }

  @override
  void dispose() {
    if (this._getNotificationSettingSubscription != null) {
      this._getNotificationSettingSubscription.cancel();
    }
    if (this._updateNotificaionSettingSubscription != null) {
      this._updateNotificaionSettingSubscription.cancel();
    }
    this._notificationBloc.dispose();
    super.dispose();
  }

  Widget get appBar {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Image.asset(AppImage.backArrow),
      ),
      title: Text(
        AppTranslations.globalTranslations.notificationSettingTitle,
        style: UIUtills().getTextStyle(
          characterSpacing: 0.4,
          color: AppColor.appBartextColor,
          fontsize: 17,
          fontName: AppFont.sfProTextSemibold,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColor.whiteColor,
      elevation: 0.5,
    );
  }

  Widget createOptionFor({NotificaionType type}) {
    final model = this._notificationBloc.notificationSettingModel;
    bool isOn;
    String title;
    String title1;


    if (type == NotificaionType.newReviewReceived) {
      title = AppTranslations.globalTranslations.newReviewReceived;
      title1 = AppTranslations.globalTranslations.newReviewReceivedMessage;
      isOn = model.newReviewReceived;
    }
  else if (type == NotificaionType.newOrder) {
      title = AppTranslations.globalTranslations.newOrder;
      title1 = AppTranslations.globalTranslations.newOrderMessage;
      isOn = model.newOrder;
    } else if (type == NotificaionType.orderStatus) {
      title = AppTranslations.globalTranslations.orderStatus;
      title1 = AppTranslations.globalTranslations.orderStatuMessage;
      isOn = model.orderStatus;
    }
//  else if (type == NotificaionType.confirmOrder) {
//      title = AppTranslations.globalTranslations.confirmOrder;
//      title1 = AppTranslations.globalTranslations.confirmOrderMessage;
//      isOn = model.confirmOrder;
//    }

    return Container(
      margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: UIUtills().getTextStyle(
                fontName: AppFont.sfProTextRegular,
                fontsize: 14,
                color: AppColor.notificationSettingsTextColor),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      top: UIUtills().getProportionalHeight(10)),
                  child: Text(
                    title1,
                    maxLines: 2,
                    style: UIUtills().getTextStyle(
                        fontName: AppFont.sfProDisplayLight,
                        fontsize: 12,
                        color: AppColor.notificationSettingsTextColor),
                  ),
                ),
              ),
              CupertinoSwitch(
                value: isOn,
                activeColor: AppColor.switchOnColor,
                onChanged: (on) {
//                  if (type == NotificaionType.confirmOrder) {
//                    model.confirmOrder = on;
//                  } else
                    if (type == NotificaionType.newOrder) {
                    model.newOrder = on;
                  }
                  else  if (type == NotificaionType.orderStatus) {
                    model.orderStatus = on;
                  }
                  else  if (type == NotificaionType.newReviewReceived) {
                    model.newReviewReceived = on;
                  }
                  setState(() {});
                  this.updateNotificationSetting();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (this._notificationBloc.notificationSettingModel == null) {
      body = Container();
    } else {
      body = Container(
        padding: EdgeInsets.only(
            left: UIUtills().getProportionalWidth(20.0),
            right: UIUtills().getProportionalWidth(20.0),
            top: UIUtills().getProportionalWidth(20.0)),
        child: Column(
          children: <Widget>[
//            this.createOptionFor(type: NotificaionType.confirmOrder),
            this.createOptionFor(type: NotificaionType.newOrder),
            this.createOptionFor(type: NotificaionType.orderStatus),
            this.createOptionFor(type: NotificaionType.newReviewReceived),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: body,
      backgroundColor: AppColor.whiteColor,
    );
  }

  void getNotificationSettingApi() {
    _getNotificationSettingSubscription = this._notificationBloc.getNotificaionSettingStream.listen((NotificationSettingResponse response) {
      _getNotificationSettingSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
        () {
          UIUtills().dismissProgressDialog(context);
          if (!response.status) {
            Utils.showSnakBarwithKey(_scaffoldKey, "");
            return;
          }
          setState(() {});
        },
      );
    });
    this._notificationBloc.getNotificationSettingApi();
    UIUtills().showProgressDialog(context);
  }

  void updateNotificationSetting() {
    _updateNotificaionSettingSubscription = this
        ._notificationBloc
        .updateNoticationSettingStream
        .listen((UpdateNotificationSettingResponse response) {
      _updateNotificaionSettingSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
        () {
          UIUtills().dismissProgressDialog(context);

          if (!response.status) {
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            this.getNotificationSettingApi();
          }
          setState(() {});
        },
      );
    });
    final model = this._notificationBloc.notificationSettingModel;
    this._notificationBloc.updateNotificationSettingApi(
//        isAllowConfirmOrder: model.confirmOrder,
        isAllowNewOrder: model.newOrder,
        isAllowNewReviewReceived: model.newReviewReceived,
        isAllowOrderStatus: model.orderStatus,
    );
    UIUtills().showProgressDialog(context);
  }
}
