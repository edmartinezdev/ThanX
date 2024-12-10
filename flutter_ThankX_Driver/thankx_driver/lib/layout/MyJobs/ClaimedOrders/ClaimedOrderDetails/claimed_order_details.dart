import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/order_bloc.dart';
import 'package:thankxdriver/bloc/order_tracking_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/common_widgets/ordes_status_tile.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_map.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/claimed_order_details_slideup.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/firebase_cloud_messaging.dart';
import 'package:thankxdriver/utils/utils.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_font.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/ui_utils.dart';

class ClaimedOrderDetails extends StatefulWidget {

  OrderDetailsBloc bloc;
  OrderDetailsData orders;
  ClaimedOrderDetails({this.bloc,this.orders});

  @override
  _ClaimedOrderDetailsState createState() => _ClaimedOrderDetailsState();

}

class _ClaimedOrderDetailsState extends State<ClaimedOrderDetails> with AfterLayoutMixin<ClaimedOrderDetails>{

  final _scaffoldKey =GlobalKey<ScaffoldState>();

  PanelController _panelController = PanelController();

  OrderTrackingBloc bloc;
  OrderDetailsBloc orderDetailsBloc;
  StreamSubscription notAtHomeSubscription;
  StreamSubscription orderDetailsSubscription;
  bool isNotHomeCalled = false;

  initState(){

    bloc = OrderTrackingBloc();

    this.bloc.orderTrackingStatus = this.widget.orders.orderStatus;

    if(this.widget.bloc!=null) {
      bloc.orderDetailsData = this.widget.bloc.orderDetailsData;
      orderDetailsBloc = this.widget.bloc;
    }
    else {
      orderDetailsBloc = OrderDetailsBloc();
      orderDetailsBloc.orderDetailsData = this.widget.orders;
     this.widget.orders.orderId = this.widget.orders.sId;
    }

    //Updating Not at home Flag on User API CALL
    notAtHomeSubscription = FirebaseCloudMessagagingWapper().notAtHomeUpdate.listen((orderId){
      notAtHomeSubscription.cancel();
      if(orderId == this.bloc.orderDetailsData.orderId && !isNotHomeCalled){
        isNotHomeCalled = true;
        getOrderDetails(this.bloc.orderDetailsData.orderId );
      }
    });

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if(this.widget.bloc == null)
      getOrderDetails(this.widget.orders.sId);
    else{
      PlatformChannel().startLocationService(orderId: this.widget.bloc.orderDetailsData.orderId,customerId: this.widget.bloc.orderDetailsData.userId);
    }
  }

  @override
 void dispose(){
    super.dispose();
    if (this.widget.bloc != null) this.widget.bloc.dispose();
    if(this.orderDetailsSubscription != null) this.orderDetailsSubscription.cancel();
    if(this.notAtHomeSubscription != null) this.notAtHomeSubscription.cancel();
  }

  List<String> buttonImages = [
    AppImage.orderIcon2,
    AppImage.orderIcon3
  ];

  getMinHeight(){
    //With driver Details
//    return UIUtills().getProportionalWidth(15)+UIUtills().getProportionalWidth(3)+UIUtills().getProportionalWidth(32)+UIUtills().getProportionalWidth(30)+UIUtills().getProportionalWidth(15)+UIUtills().getProportionalWidth(110)+UIUtills().getProportionalWidth(20);

    //Without Driver Details
        return UIUtills().getProportionalWidth(15)+UIUtills().getProportionalWidth(3)+UIUtills().getProportionalWidth(33)+UIUtills().getProportionalWidth(30)+UIUtills().getProportionalWidth(15);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        key:_scaffoldKey,
          backgroundColor: AppColor.whiteColor,
          appBar:   AppBar(
            backgroundColor: AppColor.whiteColor,
            leading: InkWell(
                onTap: (){
                  _onBack();
                },
                child: Center(
                    child:Image.asset(AppImage.backArrow))),
            centerTitle: true,
            title: Text("Order #${this.widget.orders.orderNumber ?? " "}",style: TextStyle(color: AppColor.textColor,fontSize:17 ,fontFamily: AppFont.sfProTextMedium,fontWeight: FontWeight.w700,),),
            actions: <Widget>[
              InkWell(onTap: () {
                _panelController.open();
              },
              child: Image.asset(AppImage.infoSelected),),
            ],
            elevation: 0,
          ),
          body: mainContainer()
          ),
    );
  }

  Widget mainContainer() {
   double _panelHeightOpen = MediaQuery.of(context).size.height -80 - UIUtills().getProportionalWidth(34)-UIUtills().getProportionalWidth(12)-UIUtills().getProportionalWidth(22);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            OrderStatusTile(
              noOfButtons: 2,
              currentState: this.bloc.orderTrackingStatus - 3,
              images: buttonImages,
              isButtonClickable: false,
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
                child: SlidingUpPanel(
                  controller: _panelController,
                  maxHeight: _panelHeightOpen,
                  minHeight:getMinHeight(),
                  parallaxEnabled: false,
                  parallaxOffset: .5,
                  body:Container(
                      margin: EdgeInsets.only(bottom: getMinHeight()+120),
                      child:  ClaimedOrderMap(order: this.bloc.orderDetailsData ,orderStatus: bloc.orderTrackingStatus,)),
                  panelBuilder: (sc) => _panel(sc),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState((){
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
      padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(27),),
      child: SingleChildScrollView(
        controller: sc,
        child: ClaimedOrderSlideUp(order:(this.bloc.orderDetailsData != null) ? this.bloc.orderDetailsData : this.widget.orders,orderStatus: this.bloc.orderTrackingStatus,onStatusChange: (i){
          bloc.orderTrackingStatus = i;
          setState(() {});
        },),
      ),
    );

  }


  void getOrderDetails(String orderId) {

    orderDetailsSubscription = this.orderDetailsBloc.orderDetailsStream.listen((OrderDetailsResponse response) async {
      orderDetailsSubscription.cancel();

      UIUtills().dismissProgressDialog(NavigationService().navigatorKey.currentState.overlay.context);
      if (response.status) {
        this.orderDetailsBloc.orderDetailsData = response.data;
        this.bloc.orderDetailsData = response.data;
        bloc.orderDetailsData.orderId = response.data.orderId;
        bloc.orderTrackingStatus = response.data.orderStatus;
        setState(() {});

        PlatformChannel().startLocationService(orderId: response.data.orderId,customerId: response.data.userId);

        setState(() {});
      } else {
        Utils.showSnakBarwithKey(_scaffoldKey, response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(NavigationService().navigatorKey.currentState.overlay.context);
    this.orderDetailsBloc.getOrderDetails(orderId);
  }

  Future<bool> _onBack() {
    NavigationService().pop();
  }
}
