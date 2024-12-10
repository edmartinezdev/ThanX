import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/order_bloc.dart';
import 'package:thankxdriver/common_widgets/order_status_buttons_tile.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import 'history_details_sheet.dart';


class HistoryDetailsPage extends StatefulWidget {
  OrderDetailsData order;
  HistoryDetailsPage({this.order});
  @override
  _PlacedOrdersState createState() => _PlacedOrdersState();
}

class _PlacedOrdersState extends State<HistoryDetailsPage> with AfterLayoutMixin<HistoryDetailsPage>{

  OrderDetailsBloc orderDetailsBloc;

  StreamSubscription orderDetailsSubscription;

  int orderStatus = 4;

  List<String> buttonImages = [
    AppImage.notificationIcon,
    AppImage.orderIcon2,
    AppImage.orderIcon2,
    AppImage.orderIcon3
  ];


  initState(){

    orderDetailsBloc = OrderDetailsBloc();
    orderDetailsBloc.orderDetailsData = this.widget.order;
    orderDetailsBloc.orderStatus = this.widget.order.orderStatus ;

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
      getOrderDetails();
  }

  dispose(){
    super.dispose();
    if(this.orderDetailsSubscription != null) this.orderDetailsSubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(AppImage.backArrow)),
          title: Text(
            "Order #${this.widget?.order?.orderNumber ?? " "}",
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 17,
              fontFamily: AppFont.sfProTextMedium,
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 0,
        ),
        body: mainContainer()
    );
  }

  Widget mainContainer() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            OrderStatusButtonsTile(
              noOfButtons: 4,
              currentState: this.orderStatus,
              images: buttonImages,
              statusChangeCallback: (i) {
                this.orderStatus = 4  ;
                setState(() {});
              },
            ),
            Expanded(
              child: Container(
                height: 100,
                width: double.infinity,
                margin:
                EdgeInsets.only(top: UIUtills().getProportionalWidth(22)),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0, 2.0),
                          blurRadius: 12.0,
                          spreadRadius: 2.5,
                          color: AppColor.shadowColor)
                    ],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child:HistoryDetailsSheet(order: this.orderDetailsBloc.orderDetailsData,orderStatus: orderDetailsBloc.orderStatus,),
              ),
            )
          ],
        ),
      ),
    );
  }


  void getOrderDetails() {

    orderDetailsSubscription = this.orderDetailsBloc.orderDetailsStream.listen((OrderDetailsResponse response) async {
      orderDetailsSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        this.orderDetailsBloc.orderDetailsData = response.data;
        orderDetailsBloc.orderStatus = response.data.orderStatus;
        setState(() {});
      } else {
        UIUtills.showSnakBar(context, response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.orderDetailsBloc.getOrderDetails(this.widget.order.sId);
  }





}
