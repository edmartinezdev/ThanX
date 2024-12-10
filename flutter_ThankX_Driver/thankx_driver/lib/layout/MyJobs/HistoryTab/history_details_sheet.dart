import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thankxdriver/common_widgets/star_widget.dart';
import 'package:thankxdriver/common_widgets/title_price_button.dart';
import 'package:thankxdriver/common_widgets/route_widget.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/map_utils.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class HistoryDetailsSheet extends StatefulWidget {

  OrderDetailsData order;
  int orderStatus;
  HistoryDetailsSheet({this.order,this.orderStatus = 5});

  @override
  _HistoryDetailsSheetState createState() => _HistoryDetailsSheetState();

}

class _HistoryDetailsSheetState extends State<HistoryDetailsSheet> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};

  // for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  GoogleMapController mapController ;
  Completer<GoogleMapController> _controller = Completer();
  LatLng SOURCE_LOCATION;
  LatLng DEST_LOCATION;

  CameraPosition _cameraPosition ;

  @override
  initState(){

    SOURCE_LOCATION = LatLng(this.widget.order?.pickupLocation?.latitude ?? 0.0,this.widget.order?.pickupLocation?.longitude?? 0.0);
    DEST_LOCATION = LatLng(this.widget.order?.dropoffLocation?.latitude ?? 0.0,this.widget.order?.dropoffLocation?.longitude ?? 0.0);

    _cameraPosition = CameraPosition(
      target: LatLng(this.widget.order?.pickupLocation?.latitude ?? 0.0 ,this.widget.order?.pickupLocation?.longitude ?? 0.0),
      zoom: 11.4746,
    );
    setSourceAndDestinationIcons();
    super.initState();
  }

  //Setting Polylines Between two points
  void setSourceAndDestinationIcons() async {
    sourceIcon = await MapUtils().getBitmapIcon(AppImage.mapActive);
    destinationIcon = await MapUtils().getBitmapIcon(AppImage.flagActive);
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId("PickUp"),
          position: SOURCE_LOCATION,
          icon: sourceIcon
      ));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId("DropOff"),
          position: DEST_LOCATION,
          icon: destinationIcon
      ));
    });
  }

  setPolylines() async {

    Polyline polyline = await MapUtils().getPolylineFormEncodedString(this.widget.order.overviewPolyline);
    _polylines.add(polyline);

    setState(() {});
  }


  Widget get divider => Container(
    height: 1,
    width: double.infinity,
    color: AppColor.dividerColor,
    margin: EdgeInsets.symmetric(
        horizontal: UIUtills().getProportionalWidth(8)),
  );

  Widget get dot => Container(
    margin: EdgeInsets.only(
        right: UIUtills().getProportionalWidth(7),
        top: UIUtills().getProportionalHeight(2)),
    width: UIUtills().getProportionalWidth(5),
    height: UIUtills().getProportionalWidth(5),
    decoration:
    BoxDecoration(color: AppColor.textColor, shape: BoxShape.circle),
  );

  getTitleDescriptionWidget(String title, String desc) {

    return Container(
      width: UIUtills().getProportionalWidth(145),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: UIUtills().getTextStyleRegular(
                fontSize: 10,
                fontName: AppFont.sfProDisplayMedium,
                color: AppColor.textColorLight,
                characterSpacing: 0.2),
          ),
          SizedBox(
            height: UIUtills().getProportionalHeight(15),
          ),
          Text(
            desc,
            style: UIUtills().getTextStyleRegular(
                fontSize: 12,
                fontName: AppFont.sfProDisplayMedium,
                color: AppColor.textColor,
                characterSpacing: 0.3),
          ),
        ],
      ),
    );

  }

  getTitleDescRow(String title1, String desc1,String title2 ,String desc2){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getTitleDescriptionWidget(title1, desc1),
        getTitleDescriptionWidget(title2, desc2),
      ],
    );
  }

  setUpSourceAndDestination(){
    if(SOURCE_LOCATION.latitude == 0.0 && SOURCE_LOCATION.longitude == 0.0 && mapController!=null) {
      SOURCE_LOCATION = LatLng(
          this.widget.order?.pickupLocation?.latitude ?? 0.0,
          this.widget.order?.pickupLocation?.longitude ?? 0.0);
      DEST_LOCATION = LatLng(
          this.widget.order?.dropoffLocation?.latitude ?? 0.0,
          this.widget.order?.dropoffLocation?.longitude ?? 0.0);


      MapUtils().cameraLocationUpdate(SOURCE_LOCATION,DEST_LOCATION,this.mapController,20);
    }
  }


  @override
  Widget build(BuildContext context) {
    //Setting Polyline
    if ((this.widget.order?.overviewPolyline ?? '').isNotEmpty && this._polylines.toList().isEmpty) {
      this.setPolylines();
    }
    setUpSourceAndDestination();
    setMapPins();
    setSourceAndDestinationIcons();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: UIUtills().getProportionalWidth(30),
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(35)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: UIUtills().getProportionalHeight(33),
                      width: UIUtills().getProportionalWidth(175),
                      alignment: Alignment.center,
                      child: Text(
                        getOrderStatus(this.widget.orderStatus),
                        style: UIUtills().getTextStyle(
                            fontsize: 14,
                            fontName: AppFont.sfProTextMedium,
                            characterSpacing: 0.3),
                      ),
                      decoration: BoxDecoration(
                          color: AppColor.roundedButtonColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(17))),
                    ),
                    Container(
                      child: Text(
                        getOrderDeliveredStatus(this.widget.orderStatus),
                        textAlign: TextAlign.center,
                        style: UIUtills().getTextStyle(
                            fontsize: 15,
                            fontName: AppFont.sfProTextBold,
                            characterSpacing: 0.36),
                      ),
                    ),
                  ],
                ),
              ),
//              driverProfileContainer(),
              Container(
                margin: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(4),
                    right: UIUtills().getProportionalWidth(4),
                    bottom: UIUtills().getProportionalHeight(30),
                    top: UIUtills().getProportionalHeight(30)),
                child: Text(
                  "Route",
                  style: UIUtills().getTextStyleRegular(
                      fontSize: 14,
                      fontName: AppFont.sfProTextSemibold,
                      color: AppColor.textColor,
                      characterSpacing: 0.3),
                ),
              ),

              RouteWidgets(
                dropImage: AppImage.dropHover,
                pickUpImage: AppImage.dropHover,
                addresses: [this.widget.order?.pickupLocation?.address ?? " " ,this.widget.order?.dropoffLocation?.address ?? " " ],
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
                      "Distance",
                      style: UIUtills().getTextStyleRegular(
                          fontName: AppFont.sfProDisplayMedium,
                          fontSize: 10,
                          color: AppColor.textColorLight),
                    ),
                    SizedBox(
                      height: UIUtills().getProportionalHeight(15),
                    ),
                    Text(
                      this.widget.order.distance.toString() + " mi",
                      style: UIUtills().getTextStyleRegular(
                          fontName: AppFont.sfCompactSemiBold,
                          fontSize: 12,
                          color: AppColor.textColor),
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
                    myLocationButtonEnabled:false,
                    mapType: MapType.normal,
                    gestureRecognizers: Set()..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())),
                    initialCameraPosition: _cameraPosition,
                    markers: _markers,
                    compassEnabled: false,
                    zoomControlsEnabled: false,
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      mapController=controller;

                      //setting pins
                      setMapPins();

                      //Sets Camera between Two Locations
                      MapUtils().cameraLocationUpdate(SOURCE_LOCATION,DEST_LOCATION,this.mapController,20);

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
                  style: UIUtills().getTextStyleRegular(
                      fontSize: 14,
                      fontName: AppFont.sfProTextSemibold,
                      color: AppColor.textColor,
                      characterSpacing: 0.3),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: UIUtills().getProportionalWidth(10)),
                child: getTitleDescRow(AppTranslations.globalTranslations.ItemTitle,this.widget.order.itemTitle,AppTranslations.globalTranslations.ItemType,this.widget.order.itemType),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: UIUtills().getProportionalWidth(10),
                    vertical: UIUtills().getProportionalHeight(30)),
                child: getTitleDescRow(
                    AppTranslations.globalTranslations.Fragile,
                    this.widget.order.fragile?AppTranslations.globalTranslations.Yes : AppTranslations.globalTranslations.No,
                    AppTranslations.globalTranslations.Quantity,
                    this.widget.order.itemQuantity),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30), ),
              //   child:
              //   getTitleDescRow(
              //       AppTranslations.globalTranslations.Weight,
              //       (this.widget.order.weight.round() ?? 0) >0 ?(this.widget.order.weight.round() ?? " ").toString() : " ",
              //       AppTranslations.globalTranslations.ItemSize,
              //       getItemSize(this.widget.order.itemSize)),
              // ),
              Visibility(
                visible: this.widget.order.notes != "",
                child: Container(
                  margin: EdgeInsets.only(
                      left: UIUtills().getProportionalWidth(10),
                      right: UIUtills().getProportionalWidth(10),
                      bottom: UIUtills().getProportionalHeight(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                   AppTranslations.globalTranslations.Notes,
                        style: UIUtills().getTextStyleRegular(
                            fontSize: 10,
                            fontName: AppFont.sfProDisplayMedium,
                            color: AppColor.textColorLight,
                            characterSpacing: 0.2),
                      ),
                      SizedBox(
                        height: UIUtills().getProportionalHeight(15),
                      ),
                      Text(
                        this.widget.order.notes,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppFont.sfProTextMedium,
                            color: AppColor.textColor,
                            letterSpacing: 0.4,
                            height: 2.3),
                      ),
                    ],
                  ),
                ),
              ),

//              divider,
//
//              Container(
//                margin: EdgeInsets.only(
//                    left: UIUtills().getProportionalWidth(4),
//                    right: UIUtills().getProportionalWidth(4),
//                    bottom: UIUtills().getProportionalHeight(30),
//                    top: UIUtills().getProportionalHeight(30)),
//                child: Text(
//                    AppTranslations.globalTranslations.DeliveryMethod,
//                  style: UIUtills().getTextStyleRegular(
//                      fontSize: 14,
//                      fontName: AppFont.sfProTextSemibold,
//                      color: AppColor.textColor,
//                      characterSpacing: 0.3),
//                ),
//              ),
//              Container(
//                  margin: EdgeInsets.only(
//                      left: UIUtills().getProportionalWidth(10),
//                      right: UIUtills().getProportionalWidth(10),
//                      bottom: UIUtills().getProportionalHeight(30)),
//                  child: TitlePriceButton(
//                    title: this.widget.order?.deliveryType?.name ?? " ",price:this.widget.order?.deliveryType?.amount ?? " ",
//                    onClick: () {},
//                    backgroundColor: AppColor.textFieldBackgroundColor,
//                  )),
//              divider,
//              Container(
//                margin: EdgeInsets.only(
//                    left: UIUtills().getProportionalWidth(4),
//                    right: UIUtills().getProportionalWidth(4),
//                    bottom: UIUtills().getProportionalHeight(30),
//                    top: UIUtills().getProportionalHeight(30)),
//                child: Text(
//                    AppTranslations.globalTranslations.PaymentMethod,
//                  style: UIUtills().getTextStyleRegular(
//                      fontSize: 14,
//                      fontName: AppFont.sfProTextSemibold,
//                      color: AppColor.textColor,
//                      characterSpacing: 0.3),
//                ),
//              ),
//              Container(
//                  margin: EdgeInsets.only(
//                      left: UIUtills().getProportionalWidth(10),
//                      right: UIUtills().getProportionalWidth(10),
//                      bottom: UIUtills().getProportionalHeight(30)),
//                  child: Container(
//                    decoration: BoxDecoration(
//                        color: AppColor.textFieldBackgroundColor,
//                        borderRadius:
//                        BorderRadius.all(Radius.circular(10))),
//                    padding: EdgeInsets.symmetric(
//                        horizontal: UIUtills().getProportionalWidth(16)),
//                    width: double.infinity,
//                    height: UIUtills().getProportionalHeight(50),
//                    child: Center(
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        mainAxisSize: MainAxisSize.max,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text(
//                            AppTranslations.globalTranslations.Visa,
//                            style: UIUtills().getTextStyleRegular(
//                                fontSize: 17,
//                                fontName: AppFont.sfProTextMedium,
//                                color: AppColor.textColor,
//                                characterSpacing: 0.4),
//                          ),
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              dot,
//                              dot,
//                              dot,
//                              dot,
//                              Text(
//                                this.widget.order?.cardDetails?.last4 ?? " ",
//                                style: UIUtills().getTextStyleRegular(
//                                    fontSize: 12,
//                                    fontName: AppFont.sfProTextMedium,
//                                    color: AppColor.textColor,
//                                    characterSpacing: 0.4),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  )),


              divider,

              Container(
                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
                child: Text(
                  AppTranslations.globalTranslations.paymentInfo,
                  style: UIUtills().getTextStyleRegular(
                      fontSize: 14,
                      fontName: AppFont.sfProTextSemibold,
                      color: AppColor.textColor,
                      characterSpacing: 0.3),
                ),),

              Container(
                  margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30) ),
                  child: TitlePriceButton(title: AppTranslations.globalTranslations.youReceived, price:this.widget.order?.driverAmount.toStringAsFixed(2) ?? " ",onClick: (){},backgroundColor: AppColor.textFieldBackgroundColor,style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),)
              ),

            ],
          ),
        ),
      ),
//          Column(
//            children: <Widget>[
//              Container(height: 1, width: double.infinity, color: AppColor.dividerColor,),
//              Container(
//                margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(32),vertical: UIUtills().getProportionalHeight(14)),
//                child: TitlePriceButton(title:"Place Order",price:"9.99",onClick: (){},),
//              )
//            ],
//          )
    );
  }

  Widget driverProfileContainer() {
    return Container(
      margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(25)),
      height: UIUtills().getProportionalWidth(118),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.boarderInCardColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: UIUtills().getProportionalWidth(70),
            width: UIUtills().getProportionalWidth(70),
            margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(19)),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.boarderInCardColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Image.asset(
              AppImage.imagePlaceholder,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(16)),
            height: UIUtills().getProportionalWidth(70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  this.widget.order?.driverDetails?.firstname ?? " "+ " " + this.widget.order?.driverDetails?.lastname ?? " " ,
                  style: UIUtills().getTextStyle(
                      fontsize: 17,
                      fontName: AppFont.sfProTextSemibold,
                      characterSpacing: 0.4,
                      color: AppColor.textColor),
                ),
                Expanded(
                  child: Container(
                    child: StarDisplayWidget(
                      value: 2,
                      filledStar: Icon(Icons.star, color: Colors.amberAccent, size: UIUtills().getProportionalWidth(15)),
                      unfilledStar: Icon(Icons.star_border,color: Colors.black45, size: UIUtills().getProportionalWidth(15),),
                    ),
                  ),
                ),
                Text(
                  this.widget.order?.vehicleDetails?.year ?? " " + " " + this.widget.order?.vehicleDetails?.model ?? " ",
                  style: UIUtills().getTextStyle(
                      fontsize: 14,
                      fontName: AppFont.sfProTextMedium,
                      characterSpacing: 0.3,
                      color: AppColor.textColorLight),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  String getItemSize(int itemSize) {
    switch(itemSize){
      case 1:
        return "Small";
      case 2:
        return "Medium";
      case 3:
        return "Large";
      default:
        return "Small";
    }
  }

  String getDeliveryText(int orderStatus) {

    switch(orderStatus){
      case 1:
        return "Awaiting Confirmation";
      case 2:
        return "Awaiting Claim";
      case 3:
        return "Claimed";
      case 4:
        return "PickedUp";
      case 5:
        return "Delivered";
      default:
        return "Delivered";
    }

  }


  String getOrderStatus(int status) {

    if(status == 5){
      return AppTranslations.globalTranslations.deliveredStatus;
    }
    else if(status == 6){
      return AppTranslations.globalTranslations.canceledStatus;
    }
    else if(status == 7){
      return AppTranslations.globalTranslations.canceledStatus;
    }
    else if(status == 8){
      return AppTranslations.globalTranslations.canceledStatus;
    }
  }

  String getOrderDeliveredStatus(int status) {

    if(status == 5){
      return AppTranslations.globalTranslations.arrivedStatus;
    }
    else if(status == 6 || status == 7 ||status == 8){
      return AppTranslations.globalTranslations.rejectedStatus;
    }
  }


}
