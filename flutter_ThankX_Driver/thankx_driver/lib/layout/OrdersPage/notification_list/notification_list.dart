import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/notification_list_bloc.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Review/review_page.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_details.dart';
import 'package:thankxdriver/layout/MyJobs/HistoryTab/history_details_page.dart';
import 'package:thankxdriver/layout/OrdersPage/notification_list/notification_list_adapter.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/notification_list_model.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class NotificationList extends StatefulWidget {
  NotificationListBloc notificationListBloc;
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {



  Widget get divider => Container(
        height: 0.7,
        width: double.infinity,
        color: AppColor.shadowColor,
      );

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationListBloc _notificationListBloc;
  StreamSubscription<NotificationListResponse> _notificationListSubscription;
  StreamSubscription<BaseResponse> _deleteNotificationSubscription;
  StreamSubscription<BaseResponse> _clearAllNotificationSubscription;

  @override
  void initState() {
    super.initState();
    _notificationListBloc = NotificationListBloc.createWith(bloc: this.widget.notificationListBloc);
    this.widget.notificationListBloc = this._notificationListBloc;
    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
        if (mounted) {
          this._callNotificationListApi(offset: 0);
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        leading: InkWell(
          onTap: () {
            NavigationService().pop();
          },
          child: Center(
              child: Image.asset(
            AppImage.backArrow,
            height: UIUtills().getProportionalWidth(15),
            width: UIUtills().getProportionalWidth(20),
          )),
        ),
        centerTitle: true,
        title: Text(
          AppTranslations.globalTranslations.Notificationstitle,
          style: TextStyle(
              color: AppColor.textColor,
              fontSize: 17,
              fontFamily: AppFont.sfProTextMedium,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4),
        ),
        elevation: 0,
        actions: <Widget>[
          clearButton(),
        ],
      ),
      body: Container(
        color: AppColor.whiteColor,
        child: Column(
          children: <Widget>[
            divider,
            SizedBox(height: UIUtills().getProportionalWidth(18),),
            Expanded(
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(22)),
                child:listWithEmptyContainer(),
              )

              ,)
          ],
        ),
      ),
    );
  }

  Widget clearButton(){
    if (this._notificationListBloc.notificationList.length > 0) {
      return  InkWell(
        onTap: () {
          clearAllNotification();
        },
        child: Container(
          margin:
          EdgeInsets.only(right: UIUtills().getProportionalWidth(20)),
          child: Center(
            child: Text(
              AppTranslations.globalTranslations.strClear,
              style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 11,
                  fontFamily: AppFont.sfProDisplayBold),
            ),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget listWithEmptyContainer(){
    if(!this._notificationListBloc.isApiResponseReceived){
      return Container();
    }

    final listView = PullToRefreshListView(
      padding: EdgeInsets.all(0),
      itemCount: this._notificationListBloc.notificationList.length,
      onRefresh: () async => this._callNotificationListApi(offset: 0),
      builder: (context,index) {
        if (index == this._notificationListBloc.notificationList.length) {
          Future.delayed(Duration(milliseconds: 100), () => this._callNotificationListApi(offset: this._notificationListBloc.notificationList.length),);
          return Utils.buildLoadMoreProgressIndicator();
        }
        return Container(
          margin: EdgeInsets.only(bottom: UIUtills().getProportionalWidth(15)),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            child:  NotificationListAdapter(

                title: this._notificationListBloc.notificationList[index].data.title,
                message: this._notificationListBloc.notificationList[index].data.message,

                callback: (){

                  if(this._notificationListBloc.notificationList[index].orderId!= "" && this._notificationListBloc.notificationList[index].orderId!=null) {

                    // Setting Default Order Details With OrderId and Order status `
                    OrderDetailsData order = OrderDetailsData();
                    order.sId = this._notificationListBloc.notificationList[index].orderId;
                    order.orderId = this._notificationListBloc.notificationList[index].orderId;
                    order.orderStatus = this._notificationListBloc.notificationList[index].orderStatus;

                    if (this._notificationListBloc.notificationList[index].orderStatus <= 4 && this._notificationListBloc.notificationList[index].orderStatus >= 3) {
                      NavigationService().push(MaterialPageRoute(builder: (ctx)=>ClaimedOrderDetails(orders: order,)));
                    }
                    else if(this._notificationListBloc.notificationList[index].orderStatus == 5){
                      NavigationService().push(MaterialPageRoute(builder: (ctx)=>HistoryDetailsPage(order: order,)));
                    }

                  }

                  if(this._notificationListBloc.notificationList[index].data.title == "New Review Received"){
                    NavigationService().push(MaterialPageRoute(builder: (context)=>ReviewPage()));
                  } else  if(this._notificationListBloc.notificationList[index].data.title == "New Review Received"){
                    NavigationService().push(MaterialPageRoute(builder: (context)=>ReviewPage()));
                  }
                },
              ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: AppTranslations.globalTranslations.deleteText,
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  this.deleteNotification(
                    notificaion: this._notificationListBloc.notificationList[index],
                    notificationId: this._notificationListBloc.notificationList[index].sId);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );

   if(this._notificationListBloc.notificationList.length > 0){
      return listView;
    }
    else {
     return Stack(
       children: <Widget>[
         listView,
         Visibility(
           visible: this._notificationListBloc.isApiResponseReceived,
           child: Container(
             height: UIUtills().screenHeight,
             width: double.infinity,
             alignment: Alignment.center,
             child: Text("You don't have any new notifications"),
           ),
         )
       ],
     );
    }
  }

  void _callNotificationListApi({@required int offset}) {
    final bool isNeedLoader = this._notificationListBloc.notificationList.length == 0;

    _notificationListSubscription = this._notificationListBloc.notificationListOptionStream.listen(
          (NotificationListResponse response) {
        _notificationListSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
              () {
            this._notificationListBloc.isApiResponseReceived = true;
            if (isNeedLoader) {
              UIUtills().dismissProgressDialog(context);
            }
            if (!response.status) {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              return;
            }
            setState(() {});
          },
        );
      },
    );
    this._notificationListBloc.getNotificationListApi(offset);
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }

  void deleteNotification({MyNotification notificaion, String notificationId}) {

    _deleteNotificationSubscription = this._notificationListBloc.deleteNotificationStream.listen((BaseResponse response) {
      _deleteNotificationSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
            () {
          UIUtills().dismissProgressDialog(context);

          if (response.status) {
            Future.delayed(Duration(milliseconds: 100), () => setState(() {}));
          }
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          setState(() {});
        },
      );
    },
    );
    this._notificationListBloc.callDeleteNotifcationApi(notification: notificaion, notificationId: notificationId);
    UIUtills().showProgressDialog(context);
  }

  void clearAllNotification() {

    _clearAllNotificationSubscription = this._notificationListBloc.clearNotificationStream.listen((BaseResponse response) {
      _clearAllNotificationSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
            () {
          UIUtills().dismissProgressDialog(context);

          if (response.status) {
            Future.delayed(Duration(milliseconds: 100), () => setState(() {}));
          }
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          setState(() {});
        },
      );
    },
    );
    this._notificationListBloc.clearAllNotificationApi();
    UIUtills().showProgressDialog(context);
  }

}
