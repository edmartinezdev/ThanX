import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thankxdriver/bloc/order_bloc.dart';
import 'package:thankxdriver/common_widgets/route_details_view.dart';
import 'package:thankxdriver/common_widgets/title_price_button.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/date_utils.dart';
import 'package:thankxdriver/utils/map_utils.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class ClaimOrderDetails extends StatefulWidget {
  MyOrders order;
  OrderDetailsBloc bloc;

  ClaimOrderDetails({this.order, this.bloc});

  @override
  _ClaimOrderDetailsState createState() => _ClaimOrderDetailsState();
}

class _ClaimOrderDetailsState extends State<ClaimOrderDetails> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};

  OrderDetailsBloc bloc;

// for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  GoogleMapController mapController;

  Completer<GoogleMapController> _controller = Completer();
  LatLng SOURCE_LOCATION;
  LatLng DEST_LOCATION;

  static CameraPosition _cameraPosition;

  @override
  void initState() {
    bloc = this.widget.bloc;

    SOURCE_LOCATION = LatLng(this.widget.order.pickupLocation.latitude, this.widget.order.pickupLocation.longitude);
    DEST_LOCATION = LatLng(this.widget.order.dropoffLocation.latitude, this.widget.order.dropoffLocation.longitude);

    _cameraPosition = CameraPosition(
      target: LatLng(this.widget.order.pickupLocation.latitude, this.widget.order.pickupLocation.longitude),
      zoom: 11.4746,
    );

    super.initState();
    setSourceAndDestinationIcons();
  }

  Widget get divider => Container(
        height: 1,
        width: double.infinity,
        color: AppColor.dividerColor,
        margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(8)),
      );

  Widget get dot => Container(
        margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(7), top: UIUtills().getProportionalHeight(2)),
        width: UIUtills().getProportionalWidth(5),
        height: UIUtills().getProportionalWidth(5),
        decoration: BoxDecoration(color: AppColor.textColor, shape: BoxShape.circle),
      );

  getTitleDescriptionWidget(String title, String desc) {
    return Container(
      width: UIUtills().getProportionalWidth(145),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: UIUtills().getTextStyleRegular(fontSize: 10, fontName: AppFont.sfProDisplayMedium, color: AppColor.textColorLight, characterSpacing: 0.2),
          ),
          SizedBox(
            height: UIUtills().getProportionalHeight(15),
          ),
          Text(
            desc,
            style: UIUtills().getTextStyleRegular(fontSize: 12, fontName: AppFont.sfProDisplayMedium, color: AppColor.textColor, characterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  getTitleDescRow(String title1, String desc1, String title2, String desc2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getTitleDescriptionWidget(title1, desc1),
        getTitleDescriptionWidget(title2, desc2),
      ],
    );
  }

  // title "In-Route to Pick Up" time - "11:30 am arrival"
  getDeliveryInfoWidget(String totalTime, String byTime) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: AppColor.textFieldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(17))),
            padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(10), vertical: UIUtills().getProportionalWidth(8.5)),
            child: Text(
              totalTime,
              style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextMedium, fontSize: 14, characterSpacing: 0.36, color: AppColor.textColor),
            ),
          ),
          Text(
            byTime,
            style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextBold, fontSize: 14, characterSpacing: 0.36, color: AppColor.textColor),
          )
        ],
      ),
    );
  }

  getCodeContainer(String s) {
    return Container(
      height: UIUtills().getProportionalWidth(53),
      width: UIUtills().getProportionalWidth(53),
      decoration: BoxDecoration(color: AppColor.textFieldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Center(
        child: Text(
          s,
          style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextBold, fontSize: 23, color: AppColor.textColor),
        ),
      ),
    );
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await MapUtils().getBitmapIcon(AppImage.map);
    destinationIcon = await MapUtils().getBitmapIcon(AppImage.flag);
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(markerId: MarkerId("PickUp"), position: SOURCE_LOCATION, icon: sourceIcon));
      // destination pin
      _markers.add(Marker(markerId: MarkerId("DropOff"), position: DEST_LOCATION, icon: destinationIcon));
    });
  }

  setPolylines() async {
    Polyline polyline = await MapUtils().getPolylineFormEncodedString(this.widget.bloc.orderDetailsData.overviewPolyline);
    _polylines.add(polyline);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Setting Polyline
    if ((this.widget.bloc.orderDetailsData?.overviewPolyline ?? '').isNotEmpty && this._polylines.toList().isEmpty) {
      setPolylines();
    }

    return Container(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(15)),
                  width: UIUtills().getProportionalWidth(50),
                  height: UIUtills().getProportionalWidth(3),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(15), bottom: UIUtills().getProportionalWidth(25)),
//              child: getAwaitingStatusContainer(),
              child: getDeliveryInfoWidget("${bloc.time} (${bloc.orderDetailsData?.distance ?? " "} mi)", getOrderTime()),
            ),

//            getConfirmationCodeWidget(),

            Container(
              margin: EdgeInsets.only(
                  left: UIUtills().getProportionalWidth(4), right: UIUtills().getProportionalWidth(4), bottom: UIUtills().getProportionalHeight(30)),
              child: Text(
                AppTranslations.globalTranslations.Route,
                style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfCompactSemiBold, color: AppColor.textColor, characterSpacing: 0.3),
              ),
            ),
            RouteDetailsView(
              addresses: [this.bloc.orderDetailsData?.pickupLocation?.address ?? " ", this.bloc.orderDetailsData?.dropoffLocation?.address ?? ""],
              name: [
                (this.bloc.orderDetailsData.pickupCMType == 1) ? "me" : this.bloc.orderDetailsData.pickupUserName,
                (this.bloc.orderDetailsData.dropoffCMType == 1) ? "me" : this.bloc.orderDetailsData.dropoffUserName
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  left: UIUtills().getProportionalWidth(4),
                  right: UIUtills().getProportionalWidth(4),
                  bottom: UIUtills().getProportionalHeight(20),
                  top: UIUtills().getProportionalHeight(30)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppTranslations.globalTranslations.Distance,
                    style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProDisplayMedium, fontSize: 10, color: AppColor.textColorLight),
                  ),
                  SizedBox(
                    height: UIUtills().getProportionalHeight(15),
                  ),
                  Text(
                    "${this.bloc.orderDetailsData.distance} mi",
                    style: UIUtills().getTextStyleRegular(fontName: AppFont.sfCompactSemiBold, fontSize: 12, color: AppColor.textColor),
                  ),
                ],
              ),
            ),

            Container(
              height: UIUtills().getProportionalWidth(110),
              margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(30)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  gestureRecognizers: Set()..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
                  initialCameraPosition: _cameraPosition,
                  markers: _markers,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  polylines: _polylines,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;

                    //setting pins
                    setMapPins();

                    //Sets Camera between Two Locations
                    Future.delayed(Duration(milliseconds: 200), () {
                      MapUtils().cameraLocationUpdate(SOURCE_LOCATION, DEST_LOCATION, this.mapController, 20);
                    });
                  },
                ),
              ),
            ),

            divider,

            Container(
              margin: EdgeInsets.only(
                  left: UIUtills().getProportionalWidth(4),
                  right: UIUtills().getProportionalWidth(4),
                  bottom: UIUtills().getProportionalHeight(30),
                  top: UIUtills().getProportionalHeight(30)),
              child: Text(
                AppTranslations.globalTranslations.ItemInformation,
                style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfCompactSemiBold, color: AppColor.textColor, characterSpacing: 0.3),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(10)),
              child: getTitleDescRow(AppTranslations.globalTranslations.ItemTitle, this.bloc.orderDetailsData.itemTitle,
                  AppTranslations.globalTranslations.ItemType, this.bloc.orderDetailsData.itemType),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(10), vertical: UIUtills().getProportionalHeight(30)),
              child: getTitleDescRow(
                  AppTranslations.globalTranslations.Fragile,
                  this.bloc.orderDetailsData.fragile ? AppTranslations.globalTranslations.Yes : AppTranslations.globalTranslations.No,
                  AppTranslations.globalTranslations.Quantity,
                  this.bloc.orderDetailsData.itemQuantity),
            ),
            // Container(
            //   margin: EdgeInsets.only(
            //       left: UIUtills().getProportionalWidth(10), bottom: UIUtills().getProportionalHeight(30), right: UIUtills().getProportionalWidth(10)),
            //   child: getTitleDescRow(
            //       AppTranslations.globalTranslations.Weight,
            //       (this.bloc.orderDetailsData.weight.round() ?? 0) > 0 ? (this.bloc.orderDetailsData.weight.round() ?? " ").toString() : " ",
            //       AppTranslations.globalTranslations.ItemSize,
            //       getItemSize(this.bloc.orderDetailsData.itemSize)),
            // ),
            Visibility(
              visible: this.widget.order.notes != "",
              child: Container(
                margin: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(10), right: UIUtills().getProportionalWidth(10), bottom: UIUtills().getProportionalHeight(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppTranslations.globalTranslations.Notes,
                      style: UIUtills()
                          .getTextStyleRegular(fontSize: 10, fontName: AppFont.sfProDisplayMedium, color: AppColor.textColorLight, characterSpacing: 0.2),
                    ),
                    SizedBox(
                      height: UIUtills().getProportionalHeight(11),
                    ),
                    Text(
                      this.bloc.orderDetailsData.notes,
                      style: TextStyle(fontSize: 12, fontFamily: AppFont.sfProTextMedium, color: AppColor.textColor, letterSpacing: 0.4, height: 2.3),
                    ),
                  ],
                ),
              ),
            ),

//            divider,
//
//            Container(
//              margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
//              child: Text(AppTranslations.globalTranslations.DeliveryMethod,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
//            ),
//
//            Container(
//                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30) ),
//                child: TitlePriceButton(title: this.bloc.orderDetailsData?.deliveryType?.name ?? " ",price:this.bloc.orderDetailsData ?.deliveryType?.amount ?? " ",onClick: (){},backgroundColor: AppColor.textFieldBackgroundColor,style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),)
//            ),
//
//            divider,
//
//            Container(
//              margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
//              child:Text(AppTranslations.globalTranslations.PaymentMethod,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
//            ),
//
//            Container(
//                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30) ),
//                child: Container(
//                  decoration: BoxDecoration(
//                      color: AppColor.textFieldBackgroundColor,
//                      borderRadius: BorderRadius.all(Radius.circular(10))
//                  ),
//                  padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(16)),
//                  width: double.infinity,
//                  height: UIUtills().getProportionalHeight(50),
//                  child: Center(
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      mainAxisSize: MainAxisSize.max,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        Text(this.bloc.orderDetailsData?.cardDetails?.brand ?? " ",style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),),
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            dot,dot,dot,dot,
//                            Text(this.bloc.orderDetailsData?.cardDetails?.last4 ?? " ",style: UIUtills().getTextStyleRegular(fontSize: 12,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                )
//            ),

            divider,

            Container(
              margin: EdgeInsets.only(
                  left: UIUtills().getProportionalWidth(4),
                  right: UIUtills().getProportionalWidth(4),
                  bottom: UIUtills().getProportionalHeight(30),
                  top: UIUtills().getProportionalHeight(30)),
              child: Text(
                AppTranslations.globalTranslations.paymentInfo,
                style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.3),
              ),
            ),

            Container(
                margin: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(10), right: UIUtills().getProportionalWidth(10), bottom: UIUtills().getProportionalHeight(30)),
                child: TitlePriceButton(
                  title: AppTranslations.globalTranslations.youWillReceive,
                  price: this.bloc.orderDetailsData.driverAmount.toStringAsFixed(2) ?? " ",
                  onClick: () {},
                  backgroundColor: AppColor.textFieldBackgroundColor,
                  style: UIUtills().getTextStyleRegular(fontSize: 15, fontName: AppFont.sfProTextMedium, color: AppColor.textColor, characterSpacing: 0.4),
                )),
          ],
        ),
      ),
    );
  }

  String getItemSize(int itemSize) {
    switch (itemSize) {
      case 1:
        return AppTranslations.globalTranslations.Small;
      case 2:
        return AppTranslations.globalTranslations.Medium;
      case 3:
        return AppTranslations.globalTranslations.Large;
      default:
        return AppTranslations.globalTranslations.Small;
    }
  }

  String getOrderTime() {
    return AppTranslations.globalTranslations.Arrivalby + getDateTime();
  }

  getDateTime() {
    DateTime dateTime = DateUtilss.stringToDate(this.widget.order.createdAt, isUTCtime: true)
        .add(Duration(minutes: (double.parse(this.widget.order.deliveryType.time) * 60).round()));

    print("DateTime After " + dateTime.toString());
    return DateUtilss.dateToString(
      dateTime,
      format: "hh:mma",
    );
  }
}
