import 'dart:async';
import 'dart:io' show Platform;

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/my_current_order_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/OrdersPage/list_view.dart';
import 'package:thankxdriver/layout/OrdersPage/map_view.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'notification_list/notification_list.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with AutomaticKeepAliveClientMixin<OrdersPage>, AfterLayoutMixin<OrdersPage> {
  bool isListEnabled = true;
  int index = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MyCurrentOrderListBloc _bloc;
  StreamSubscription<MyCurrentOrderListResponse> _myCurrentOrderListSubscription;

  String currentAddress;

  @override
  bool get wantKeepAlive => true;

  getCurrentLocation() async {
    Logger().v("Check for location permission");
    PermissionGroup group = Platform.isIOS ? PermissionGroup.locationWhenInUse : PermissionGroup.location;
    final bool result = await PlatformChannel().checkForPermission(group);
    if (result == false) {
      _bloc.latLng = LatLng(40.0024137, -75.2581112);
    } else {
      final LatLng location = await PlatformChannel().getLocation();
      Logger().v("Location :: latitude:${location.latitude} longitude:${location.longitude}");
      _bloc.latLng = location;
    }
    getAddressFromLatLng();
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(_bloc.latLng?.latitude ?? 0, _bloc.latLng?.longitude ?? 0);
      Placemark place = p[0];

      setState(() {
        currentAddress = "${place.locality}, ${place.country}";
        print("--------------------${currentAddress}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    _bloc = MyCurrentOrderListBloc();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await getCurrentLocation();
    this.myCurrentOrdersListApi(offset: 0);
  }

  void onClick(int i) {
    if (i == 0) {
      isListEnabled = true;
    } else {
      isListEnabled = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.whiteColor,
        body: Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(50),
          ),
          child: Column(
            children: <Widget>[
              appBarContainer(),
              Container(
                  margin: EdgeInsets.only(
                      left: UIUtills().getProportionalWidth(16),
                      right: UIUtills().getProportionalWidth(16),
                      top: UIUtills().getProportionalWidth(24),
                      bottom: UIUtills().getProportionalHeight(12)),
                  child: rowContainer()),
              Container(
                color: AppColor.textColorLight,
                width: double.infinity,
                height: 0.5,
              ),
              Expanded(
                child: (isListEnabled)
                    ? ListViewContainer(
                        arrList: this._bloc.orderList,
                        isApiCallPending: !this._bloc.isApiResponseReceived,
                        isLoadMoreList: this._bloc.isLoadMoreList,
                        pullToRefreshCallback: () => myCurrentOrdersListApi(offset: 0, isNeedLoader: false),
                        loadMoreCallback: () => myCurrentOrdersListApi(offset: this._bloc.orderList.length),
                      )
                    : MapView(
                        myCurrentOrderListBloc: this._bloc,
                      ),
              )
            ],
          ),
        ));
  }

  Widget appBarContainer() {
    return Container(
      margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(16), right: UIUtills().getProportionalWidth(6)),
      child: Column(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                NavigationService().push(MaterialPageRoute(builder: (context) {
                  return NotificationList();
                })).then((r) {
                  myCurrentOrdersListApi(offset: 0);
                });
              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: UIUtills().getProportionalWidth(8),
                    top: UIUtills().getProportionalWidth(8),
                    child: ((this._bloc?.myCurrentOrderModel?.count ?? 0) > 0)
                        ? Container(
                            height: UIUtills().getProportionalWidth(5),
                            width: UIUtills().getProportionalWidth(5),
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                      color: Colors.transparent,
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        AppImage.notificationIcon,
                        height: UIUtills().getProportionalHeight(22),
                        width: UIUtills().getProportionalWidth(22),
                        fit: BoxFit.contain,
                      )),
                ],
              )),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              AppTranslations.globalTranslations.OrdersTitle,
              style: UIUtills().getTextStyle(
                fontName: AppFont.sfProTextBold,
                fontsize: 28,
                color: AppColor.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: UIUtills().getProportionalHeight(35),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: UIUtills().getProportionalWidth(10), right: UIUtills().getProportionalWidth(10)),
          decoration: BoxDecoration(color: AppColor.roundedButtonColor, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              Image.asset(AppImage.deliver),
              SizedBox(
                width: UIUtills().getProportionalWidth(8),
              ),
              Text(
                currentAddress ?? '',
                style: UIUtills().getTextStyle(fontsize: 12, characterSpacing: 0.3, fontName: AppFont.sfProTextMedium, color: AppColor.textColor),
              )
            ],
          ),
        ),
        Container(
          height: UIUtills().getProportionalHeight(35),
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: UIUtills().getProportionalWidth(0)),
          decoration: BoxDecoration(color: AppColor.roundedButtonColor, borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  onClick(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isListEnabled ? AppColor.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                  padding: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(5),
                    right: UIUtills().getProportionalWidth(5),
                  ),
                  height: UIUtills().getProportionalHeight(35),
                  child: Image.asset(
                    AppImage.listViewIcon,
                    color: AppColor.textColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  onClick(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isListEnabled ? Colors.transparent : AppColor.primaryColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                  padding: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(5),
                    right: UIUtills().getProportionalWidth(5),
                  ),
                  height: UIUtills().getProportionalHeight(35),
                  child: Image.asset(AppImage.mapViewIcon),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void myCurrentOrdersListApi({@required int offset, bool isNeedLoader = true}) {
    _myCurrentOrderListSubscription = this._bloc.myCurrentOrderListOptionStream.listen(
      (MyCurrentOrderListResponse response) {
        _myCurrentOrderListSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            this._bloc.isApiResponseReceived = true;
            if (isNeedLoader) {
              UIUtills().dismissProgressDialog(context);
            }

            if (!response.status) {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              return;
            }
            print(response.myCurrentOrderList.count);
            setState(() {});
          },
        );
      },
    );
    this._bloc.callMyCurrentOrderListApi(offset: offset);
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }
}
