import 'dart:async';
import 'dart:io' show Platform;

import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/api_provider/api_constant.dart';
import 'package:thankxdriver/bloc/order_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_details.dart';
import 'package:thankxdriver/layout/OrdersPage/ClaimOrder/claim_order_details.dart';
import 'package:thankxdriver/layout/OrdersPage/ClaimOrder/claim_order_map.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/google_distance_model.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'claimed_successfully.dart';

class ClaimOrder extends StatefulWidget {
  MyOrders order;

  ClaimOrder({this.order});

  @override
  _ClaimOrderState createState() => _ClaimOrderState();
}

class _ClaimOrderState extends State<ClaimOrder> with AfterLayoutMixin<ClaimOrder> {
  int orderStatus = 1;

  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  PanelController _panelController = PanelController();

  OrderDetailsBloc bloc;
  StreamSubscription<OrderDetailsResponse> orderDetailsSubscription;
  StreamSubscription<BaseResponse> claimOrderSubscription;

  @override
  void initState() {
    bloc = OrderDetailsBloc();

    super.initState();
  }

  @override
  void dispose() {
//    bloc.dispose();
    if (orderDetailsSubscription != null) orderDetailsSubscription.cancel();
    if (claimOrderSubscription != null) claimOrderSubscription.cancel();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getOrderDetails();
  }

  getMinHeight() {
    //With driver Details
//    return UIUtills().getProportionalWidth(15)+UIUtills().getProportionalWidth(3)+UIUtills().getProportionalWidth(32)+UIUtills().getProportionalWidth(30)+UIUtills().getProportionalWidth(15)+UIUtills().getProportionalWidth(110)+UIUtills().getProportionalWidth(20);

    //Without Driver Details
    return UIUtills().getProportionalWidth(15) + UIUtills().getProportionalWidth(3) + UIUtills().getProportionalWidth(33) + UIUtills().getProportionalWidth(30) + UIUtills().getProportionalWidth(15);
  }

  void _claimedSuccessfully(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ClaimedSuccessfully(
                callback: () {
                  NavigationService().pushReplacement(MaterialPageRoute(
                      builder: (context) => ClaimedOrderDetails(
                            bloc: this.bloc,
                            orders: this.bloc.orderDetailsData,
                          )));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColor.whiteColor,
          leading: InkWell(
              onTap: () {
                NavigationService().pop();
                bloc.dispose();
              },
              child: Center(child: Image.asset(AppImage.backArrow))),
          centerTitle: true,
          title: Text(
            "Order #" + this.widget.order.orderNumber,
            style: TextStyle(color: AppColor.textColor, fontSize: 17, fontFamily: AppFont.sfProTextMedium, fontWeight: FontWeight.w700, letterSpacing: 0.4),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                _panelController.open();
              },
              child: Image.asset(AppImage.infoSelected),
            ),
          ],
          elevation: 0,
        ),
        body: mainContainer());
  }

  Widget mainContainer() {
    double _panelHeightOpen = MediaQuery.of(context).size.height - 80 - UIUtills().getProportionalWidth(34) - UIUtills().getProportionalWidth(10) - UIUtills().getProportionalWidth(20);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  top: UIUtills().getProportionalWidth(10),
                  left: UIUtills().getProportionalWidth(28),
                  right: UIUtills().getProportionalWidth(28),
                ),
                child: (!this.bloc.isOrderClaimed)
                    ? CommonButton(
                        height: UIUtills().getProportionalWidth(38),
                        width: double.infinity,
                        backgroundColor: AppColor.primaryColor,
                        onPressed: _claimOrder,
                        textColor: AppColor.textColor,
                        fontName: AppFont.sfProTextMedium,
                        fontsize: 17,
                        characterSpacing: 0,
                        text: AppTranslations.globalTranslations.claimOrder,
                      )
                    : Container(
                        height: UIUtills().getProportionalWidth(38),
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColor.dividerBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Text(
                            AppTranslations.globalTranslations.OrderClaimed,
                            style: UIUtills().getTextStyleRegular(
                              color: AppColor.textColor,
                              fontName: AppFont.sfProTextMedium,
                              fontSize: 17,
                              characterSpacing: 0,
                            ),
                          ),
                        ),
                      )),
            Expanded(
              child: Container(
                height: 100,
                width: double.infinity,
                margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(20)),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    boxShadow: [BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 12.0, spreadRadius: 2.5, color: AppColor.shadowColor)],
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                child: SlidingUpPanel(
                  controller: _panelController,
                  maxHeight: _panelHeightOpen,
                  minHeight: getMinHeight(),
                  parallaxEnabled: false,
                  parallaxOffset: .5,
                  body: Container(
                      margin: EdgeInsets.only(bottom: getMinHeight() + 120),
                      child: ClaimOrderMap(
                        pickUp: this.widget.order.pickupLocation,
                        dropOff: this.widget.order.dropoffLocation,
                        overlayPolyLine: this.bloc.orderDetailsData?.overviewPolyline ?? '',
                      )),
                  panelBuilder: (sc) => _panel(sc),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState(() {
//                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _panel(ScrollController sc) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIUtills().getProportionalWidth(25),
      ),
      child: SingleChildScrollView(
        controller: sc,
        child: ClaimOrderDetails(
          order: this.widget.order,
          bloc: this.bloc,
        ),
      ),
    );
  }

  getDistanceBettwoLatLng(double lat1, double long1, double lat2, double long2) async {
    var dio = Dio();
    String url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$long1&&destinations=$lat2,$long2&key=${ApiConstant.keyGoogleDistanceMatrix}";
    Response response = await dio.get(url);
    print("distance response" + response.data.toString());
    DistanceModel model = DistanceModel.fromJson(response.data);
    String dis = model.rows[0].elements[0].distance.text;
    this.bloc.time = model.rows[0].elements[0].duration.text.replaceAll("hours", "hr").replaceAll("mins", "min");

//     double temp = await Geolocator().distanceBetween(lat1,long1, lat2,long2);
//     temp = temp*0.001;
  }

  void getOrderDetails() {
    orderDetailsSubscription = this.bloc.orderDetailsStream.listen((OrderDetailsResponse response) async {
      orderDetailsSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        bloc.orderDetailsData = response.data;
        bloc.orderDetailsData.orderId = this.widget.order.sId;
        await getDistanceBettwoLatLng(
            this.widget.order.pickupLocation.latitude, this.widget.order.pickupLocation.longitude, this.widget.order.dropoffLocation.latitude, this.widget.order.dropoffLocation.longitude);

        setState(() {});
      } else {
        UIUtills.showSnakBar(context, response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.bloc.getOrderDetails(this.widget.order.sId);
  }

  void _claimOrder() async {
    PermissionGroup group = Platform.isIOS ? PermissionGroup.locationWhenInUse : PermissionGroup.location;
    bool isPermissionGranted = await PlatformChannel().checkForPermission(group);
    if (!isPermissionGranted) {
      Utils.showAlert(
        NavigationService().navigatorKey.currentState.overlay.context,
        message: AppTranslations.globalTranslations.locationPermissionAlert,
        arrButton: [AppTranslations.globalTranslations.buttonCancel, AppTranslations.globalTranslations.buttonOk],
        callback: (int index) async {
          if (index == 1) {
            PlatformChannel().openAppSetting();
          }
        },
      );
      return;
    }

    claimOrderSubscription = this.bloc.claimOrderStream.listen((BaseResponse response) async {
      claimOrderSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        _claimedSuccessfully(context);
        this.bloc.isOrderClaimed = true;
        PlatformChannel().startLocationService(orderId: this.bloc.orderDetailsData.orderId, customerId: this.bloc.orderDetailsData.userId);
        setState(() {});
      } else {
        UIUtills.showSnackBarWithKey(_key, response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.bloc.claimOrder(this.widget.order.sId);
  }
}
