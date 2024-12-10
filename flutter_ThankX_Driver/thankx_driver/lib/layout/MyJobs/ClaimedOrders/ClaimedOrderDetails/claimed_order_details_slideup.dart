import 'dart:async';
import 'dart:io' show Platform;
import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/flag_user_address_bloc.dart';
import 'package:thankxdriver/bloc/order_tracking_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/top_bottom_radius_button.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/user_route_details.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/date_utils.dart';
import 'package:thankxdriver/utils/map_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/title_price_button.dart';
import '../../../../localization/localization.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_font.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/ui_utils.dart';


class ClaimedOrderSlideUp extends StatefulWidget {

  VoidCallbackInt onStatusChange;
  OrderDetailsData order;
  int orderStatus;

  ClaimedOrderSlideUp({this.onStatusChange,this.order,this.orderStatus});

  @override
  _ClaimedOrderSlideUpState createState() => _ClaimedOrderSlideUpState();
}

class _ClaimedOrderSlideUpState extends State<ClaimedOrderSlideUp> with AfterLayoutMixin<ClaimedOrderSlideUp>{


  OrderTrackingBloc bloc;

  BuildContext generalContext;

  StreamSubscription orderStatusSubscription;


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

  CameraPosition _cameraPosition = CameraPosition(
    target:LatLng(39.952583, -75.165222),
    zoom: 11.4746,
  );

  LatLng driverLocation;

  updateCameraLocation() async {
    PermissionGroup group = Platform.isIOS ? PermissionGroup.locationWhenInUse : PermissionGroup.location;
    bool isPermission = await PlatformChannel().checkForPermission(group);
    // Permission Denied by user
    if (!isPermission) { return; }

    UIUtills().showProgressDialog(context);
    final LatLng location = await PlatformChannel().getLocation();
    UIUtills().dismissProgressDialog(context);
    driverLocation = location;

    if(mounted)
      setState(() {});

  }

  @override
  void initState(){

    bloc = OrderTrackingBloc();
    bloc.orderDetailsData = this.widget.order;

    this.bloc.orderTrackingStatus = this.widget.orderStatus;

    SOURCE_LOCATION = LatLng(this.widget?.order?.pickupLocation?.latitude?? 0.0,this.widget?.order?.pickupLocation?.longitude ?? 0.0);
    DEST_LOCATION= LatLng(this.widget?.order?.dropoffLocation?.latitude ?? 0.0,this.widget?.order?.dropoffLocation?.longitude ?? 0.0);

    _cameraPosition =  CameraPosition(
      target:LatLng(this.widget?.order?.pickupLocation?.latitude?? 0.0,this.widget?.order?.pickupLocation?.longitude ?? 0.0),
      zoom: 11.4746,
    );

    super.initState();
    setSourceAndDestinationIcons();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await updateCameraLocation();
  }

  dispose(){
    super.dispose();
    if(orderStatusSubscription != null) orderStatusSubscription.cancel();
  }


  Widget get divider=>Container(
    height: 1,
    width: double.infinity,
    color: AppColor.dividerColor,
    margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(8)),
  );

  Widget get dot =>Container(
    margin:EdgeInsets.only(right: UIUtills().getProportionalWidth(7),top: UIUtills().getProportionalHeight(2)),
    width: UIUtills().getProportionalWidth(5),height: UIUtills().getProportionalWidth(5),
    decoration: BoxDecoration(
        color: AppColor.textColor,
        shape: BoxShape.circle
    ),
  );

  getTitleDescriptionWidget(String title , String desc){
    return Container(
      width: UIUtills().getProportionalWidth(145),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,style: UIUtills().getTextStyleRegular(fontSize: 10 , fontName: AppFont.sfProDisplayMedium,color: AppColor.textColorLight,characterSpacing: 0.2),),
          SizedBox(height: UIUtills().getProportionalHeight(15),),
          Text(desc,style: UIUtills().getTextStyleRegular(fontSize: 12 , fontName: AppFont.sfProDisplayMedium,color: AppColor.textColor,characterSpacing: 0.3),),
        ],
      ),
    );
  }

  getTitleDescRow(String title1,String desc1 , String title2,String desc2){
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getTitleDescriptionWidget(title1, desc1),
        getTitleDescriptionWidget(title2, desc2),
      ],
    );
  }

  // title "In-Route to Pick Up" time - "11:30 am arrival"
  getInRouteToWidget(String title, String time){
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColor.textFieldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(17))
            ),
          padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(18),vertical: UIUtills().getProportionalWidth(8.5)),
            child: Text(title,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextMedium,fontSize: 14,characterSpacing: 0.36,color: AppColor.textColor),),
          ),
          Text(time,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextBold,fontSize: 15,characterSpacing: 0.36,color: AppColor.textColor),)
        ],
      ),
    );
  }

  getConfirmationCodeWidget(){
    String code =this.widget.order.confirmationCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(18)),
            child: Text(AppTranslations.globalTranslations.ConfirmationCode,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfProTextSemibold,color: AppColor.textColor,characterSpacing: 0.3),)),
        Container(
          margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(22),right: UIUtills().getProportionalWidth(22),top: UIUtills().getProportionalWidth(30),bottom:  UIUtills().getProportionalWidth(15)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getCodeContainer(code[0]),
              getCodeContainer(code[1]),
              getCodeContainer(code[2]),
              getCodeContainer(code[3]),
            ],
          ),
        )
      ],
    );
  }


  getCodeContainer(String s){

    return Container(
      height: UIUtills().getProportionalWidth(53),
      width: UIUtills().getProportionalWidth(53),
      decoration: BoxDecoration(
        color: AppColor.textFieldBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
        child:Center(
        child: Text(s,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextBold,fontSize: 23,color: AppColor.textColor),),
      ),
    );

  }


  void setSourceAndDestinationIcons() async {
    sourceIcon = await MapUtils().getBitmapIcon(this.bloc.orderTrackingStatus>=4?AppImage.mapActive:AppImage.map);
    destinationIcon = await MapUtils().getBitmapIcon(this.bloc.orderTrackingStatus>=5?AppImage.flagActive:AppImage.flag);
  }

  void setMapPins() {
    _markers.clear();

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

    if (this.widget.order.overviewPolyline.isNotEmpty && this._polylines.isEmpty) {
      _polylines.clear();
      Polyline polyline = await MapUtils().getPolylineFormEncodedString(this.widget.order.overviewPolyline);
      _polylines.add(polyline);
      setState(() {});
    }
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

    setMapPins();
    setPolylines();
    setUpSourceAndDestination();
    setSourceAndDestinationIcons();

    return Builder(builder: (ctx){

      generalContext = ctx ;
      if ((this.widget.order?.overviewPolyline?.isNotEmpty ?? false) && this._polylines.toList().isEmpty) {
        this.setPolylines();
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
                    margin: EdgeInsets.only(top:  UIUtills().getProportionalWidth(15)),
                    width: UIUtills().getProportionalWidth(50),
                    height: UIUtills().getProportionalWidth(3),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top:  UIUtills().getProportionalWidth(15),bottom: UIUtills().getProportionalWidth(25)),
                child: getInRouteToWidget(getOrderStatus(), getOrderTime()),
              ),

              Visibility(
                visible: true,
                child: GestureDetector(
                  onTap: (){
                  _openMap(SOURCE_LOCATION, DEST_LOCATION);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: UIUtills().getProportionalWidth(30)),
                    height: UIUtills().getProportionalWidth(55),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.dividerColor,width: 0.3,),
                        borderRadius: BorderRadius.all(Radius.circular(27))
                    ),
                    child: Center(
                      child: Text(AppTranslations.globalTranslations.getDirections,style: UIUtills().getTextStyleRegular(fontSize: 17,fontName: AppFont.sfProTextSemibold,characterSpacing: 0.2,color: AppColor.textColor),),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(0),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30)),
                child: Text(AppTranslations.globalTranslations.Route,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
              ),

              UserRouteDetailsView(addresses: [this.widget.order?.pickupLocation?.address ?? " " ,this.widget.order?.dropoffLocation?.address],name: [this.widget.order.pickupCMType==1? "me":this.widget.order.pickupUserName ??" ",this.widget.order.dropoffCMType==1? "me":this.widget.order.dropoffUserName ??" "],
                onStatusChange: (i){
                  this.widget.onStatusChange(i);
                  setMapPins();
                  setState(() {});
                },
                bloc: this.bloc,
                orderDetailsData: this.widget.order,
                ctx: generalContext,
              ),

              Container(
                margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(30)),
                child: Visibility(
                  visible: (this.bloc.orderTrackingStatus == 4 && !this.widget.order.atHome) ,
                  child: getConfirmationCodeWidget(),
                ),
              ),


              Container(
                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(20),top:UIUtills().getProportionalHeight(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppTranslations.globalTranslations.Distance,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProDisplayMedium,fontSize: 10,color: AppColor.textColorLight),),
                    SizedBox(height: UIUtills().getProportionalHeight(15),),
                    Text(this.widget.order.distance.toString() +" mi".toString(),style: UIUtills().getTextStyleRegular(fontName: AppFont.sfCompactSemiBold,fontSize: 12,color: AppColor.textColor),),
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
                      Future.delayed(Duration(milliseconds: 200),(){
                        MapUtils().cameraLocationUpdate(SOURCE_LOCATION,DEST_LOCATION,this.mapController,20);
                      });

                    },
                  ),
                ),
              ),


              divider,

              Container(
                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
                child: Text(AppTranslations.globalTranslations.ItemInformation,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(10)),
                child: getTitleDescRow(AppTranslations.globalTranslations.ItemTitle,this.widget.order.itemTitle,AppTranslations.globalTranslations.ItemType,this.widget.order.itemType),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(10),vertical: UIUtills().getProportionalHeight(30)),
                child: getTitleDescRow(
                    AppTranslations.globalTranslations.Fragile,
                    this.widget.order.fragile?AppTranslations.globalTranslations.Yes:AppTranslations.globalTranslations.No,
                    AppTranslations.globalTranslations.Quantity,
                    this.widget.order.itemQuantity),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30),right: UIUtills().getProportionalWidth(10)),
              //   child: getTitleDescRow(
              //       AppTranslations.globalTranslations.Weight,
              //       (this.widget.order.weight.round() ?? 0) >0 ?(this.widget.order.weight.round() ?? " ").toString() : " ",
              //       AppTranslations.globalTranslations.ItemSize,
              //       getItemSize(this.widget.order.itemSize)),
              // ),

              Visibility(
                visible: this.widget.order.notes != "",
                child: Container(
                  margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(AppTranslations.globalTranslations.Notes,style: UIUtills().getTextStyleRegular(fontSize: 10 , fontName: AppFont.sfProDisplayMedium,color: AppColor.textColorLight,characterSpacing: 0.2),),
                      SizedBox(height: UIUtills().getProportionalHeight(15),),
                      Text(this.widget.order.notes,style: TextStyle(fontSize: 12 , fontFamily: AppFont.sfProTextMedium,color: AppColor.textColor,letterSpacing:  0.4,height: 2.3),),
                    ],
                  ),
                ),
              ),

//              divider,
//
//              Container(
//                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
//                child: Text(AppTranslations.globalTranslations.DeliveryMethod,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
//              ),
//
//              Container(
//                  margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30) ),
//                  child: TitlePriceButton(title: this.widget.order?.deliveryType?.name ?? " ",price:this.widget.order?.deliveryType?.amount ?? " ",onClick: (){},backgroundColor: AppColor.textFieldBackgroundColor,style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),)
//              ),
//
//              divider,
//
//              Container(
//                margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),bottom: UIUtills().getProportionalHeight(30),top:UIUtills().getProportionalHeight(30) ),
//                child:Text(AppTranslations.globalTranslations.PaymentMethod,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
//              ),
//
//              Container(
//                  margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalHeight(30) ),
//                  child: Container(
//                    decoration: BoxDecoration(
//                        color: AppColor.textFieldBackgroundColor,
//                        borderRadius: BorderRadius.all(Radius.circular(10))
//                    ),
//                    padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(16)),
//                    width: double.infinity,
//                    height: UIUtills().getProportionalHeight(50),
//                    child: Center(
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        mainAxisSize: MainAxisSize.max,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Text(this.widget.order?.cardDetails?.brand?? " ",style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),),
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              dot,dot,dot,dot,
//                              Text(this.widget.order?.cardDetails?.last4 ?? " ",style: UIUtills().getTextStyleRegular(fontSize: 12,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  )
//              ),


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
                  child: TitlePriceButton(title: AppTranslations.globalTranslations.youWillReceive, price:this.widget.order?.driverAmount.toStringAsFixed(2) ?? " ",onClick: (){},backgroundColor: AppColor.textFieldBackgroundColor,style: UIUtills().getTextStyleRegular(fontSize: 15,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4),)
              ),



            ],
          ),
        ),
      );
    },);
  }

  _openMap(LatLng source , LatLng dest) async {
    String url;
    if(this.widget.order.orderStatus == 3) {

      url = 'https://www.google.com/maps/dir/?api=1&origin=${driverLocation.latitude},${driverLocation.longitude}&destination=${dest.latitude},${dest.longitude}&waypoints=${source.latitude},${source.longitude}&travelmode=driving&dir_action=navigate';

    }else {

      url = 'https://www.google.com/maps/dir/?api=1&origin=${driverLocation.latitude},${driverLocation.longitude}&destination=${dest.latitude},${dest.longitude}&travelmode=driving&dir_action=navigate';

    }
    print(url);
    if (await canLaunch(url)) {
      print("url launched");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getItemSize(int itemSize) {
    switch(itemSize){
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


  void confirmOrderPickUp() {

    orderStatusSubscription = this.bloc.confirmOrderPickUpStream.listen((BaseResponse response) async {
      orderStatusSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        this.bloc.orderTrackingStatus =1;
        setState(() {});
      } else {
        UIUtills.showSnakBar(context, response.message);
      }

    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.bloc.confirmOrderPickUp(this.widget.order.sId);
  }

  String getOrderStatus() {
    if(this.bloc.orderTrackingStatus <=3){
      return AppTranslations.globalTranslations.InRoutetoPickUp;
    }
    if(bloc.orderTrackingStatus <=4){
      return AppTranslations.globalTranslations.InRoutetoDropOff;
    }
    if(bloc.orderTrackingStatus <=5){
      return AppTranslations.globalTranslations.Delivered;
    }

  }

  String getOrderTime() {
    if(bloc.orderTrackingStatus<5){
      return  getDateTime()+" arrival";
    }
    else
      return AppTranslations.globalTranslations.Arrived;

  }

  getDateTime(){
    DateTime dateTime = DateUtilss.stringToDate(this.widget.order?.createdAt ?? "",isUTCtime: true).add(Duration(minutes: (double.parse(this.widget.order?.deliveryType?.time ?? "1")*60).round()));
    return DateUtilss.dateToString(dateTime,format: "hh:mma");
  }





}
