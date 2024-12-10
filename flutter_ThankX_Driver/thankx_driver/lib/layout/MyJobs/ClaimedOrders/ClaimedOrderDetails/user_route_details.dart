import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/flag_user_address_bloc.dart';
import 'package:thankxdriver/bloc/order_tracking_bloc.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/common_widgets/network_image.dart';
import 'package:thankxdriver/common_widgets/top_bottom_radius_button.dart';
import 'package:thankxdriver/layout/MyJobs/ClaimedOrders/ClaimedOrderDetails/input_confirmation_code.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/utils.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/app_font.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/ui_utils.dart';

// ignore: must_be_immutable
class UserRouteDetailsView extends StatefulWidget {
  List<String> addresses;

  List<String> name;
  VoidCallbackInt onStatusChange;
  OrderDetailsData orderDetailsData;
  OrderTrackingBloc bloc;
  BuildContext ctx;

  UserRouteDetailsView({this.addresses, this.name, this.onStatusChange, this.bloc, this.ctx, this.orderDetailsData});

  @override
  _UserRouteDetailsState createState() => _UserRouteDetailsState();
}

class _UserRouteDetailsState extends State<UserRouteDetailsView> {
  OrderTrackingBloc bloc;
  FlagUserAddressBloc flagBloc;

  bool get isConfirmPickup => bloc.orderTrackingStatus >= 4;

  bool get isConfirmDropOff => bloc.orderTrackingStatus >= 5;

  StreamSubscription orderStatusSubscription;
  StreamSubscription flagAddressSubscription;
  StreamSubscription flagUserSubscription;

  initState() {
    super.initState();
    bloc = this.widget.bloc;
    flagBloc = FlagUserAddressBloc();
  }

  dispose() {
    if (this.orderStatusSubscription != null) this.orderStatusSubscription.cancel();
    if (this.flagAddressSubscription != null) this.flagAddressSubscription.cancel();
    if (flagUserSubscription != null) flagUserSubscription.cancel();

    super.dispose();
  }

  String pinText;

  Widget getIconsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          (isConfirmPickup) ? AppImage.dropHover : AppImage.circle,
          height: UIUtills().getProportionalWidth(16),
          width: UIUtills().getProportionalWidth(16),
          fit: BoxFit.fill,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: UIUtills().getProportionalHeight(4)),
          width: 1,
          height: UIUtills().getProportionalWidth(180),
          color: AppColor.textColorLight,
        ),
        Image.asset(
          (isConfirmDropOff) ? AppImage.dropHover : AppImage.circle,
          height: UIUtills().getProportionalWidth(16),
          width: UIUtills().getProportionalWidth(16),
          fit: BoxFit.fill,
        ),
      ],
    );
  }

  getTickWidget(int i) {
    return Row(
      children: <Widget>[
        Image.asset(
          AppImage.tickMarkIcon,
          height: UIUtills().getProportionalWidth(32),
          width: UIUtills().getProportionalWidth(32),
        ),
        SizedBox(
          width: UIUtills().getProportionalWidth(10),
        ),
        Text(
          (i == 0) ? "Picked Up" : "Drop Off",
          style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfProTextMedium, color: AppColor.textColor, characterSpacing: 0.3),
        )
      ],
    );
  }

  void inputCode() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              InputConfirmationCode(
                onPinEntered: (pin) {
                  this.bloc.pinText = pin;
                  confirmOrderDropOff();
                },
                contx: this.context,
                order: this.widget.orderDetailsData,
                onNoAtHomeDropOff: (image, pin, message) {
                  this.bloc.pinText = pin;
                  this.bloc.dropOffMessage = message;
                  this.bloc.dropOffImage = image;

                  confirmOrderDropOff();
                },
                bloc: this.bloc,
              )
            ],
          );
        });
  }

  getUserDetailsWidget(int i) {
    return Container(
        margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(5)),
        decoration: BoxDecoration(border: Border.all(color: AppColor.dividerBackgroundColor, width: 0.7), borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: <Widget>[
            Container(
                height: UIUtills().getProportionalWidth(120),
                width: UIUtills().getProportionalWidth(284),
                child: Container(
                  margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(13), left: UIUtills().getProportionalWidth(15)),
                        child: CustomNetworkImage(
                          width: UIUtills().getProportionalWidth(70),
                          height: UIUtills().getProportionalWidth(70),
                          radius: 10,
                          url: (i == 0) ? this.widget.orderDetailsData.pickUpUser.profilePicture : this.widget.orderDetailsData.dropOffuser.profilePicture,
                          placeHolder: Container(
                            width: UIUtills().getProportionalWidth(40),
                            height: UIUtills().getProportionalWidth(40),
                            decoration: BoxDecoration(color: AppColor.textFieldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Image.asset(
                                AppImage.user,
                                fit: BoxFit.cover,
                                width: UIUtills().getProportionalWidth(40),
                                height: UIUtills().getProportionalWidth(40),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: UIUtills().screenWidth / 2.27,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: UIUtills().screenWidth / 2.8,
                                    margin: EdgeInsets.only(
                                      top: UIUtills().getProportionalWidth(25),
                                      bottom: UIUtills().getProportionalWidth(0),
                                    ),
                                    child: Text(
                                      (i == 0)
                                          ? this.widget.orderDetailsData.pickUpUser.firstname + " " + this.widget.orderDetailsData.pickUpUser.lastname
                                          : this.widget.orderDetailsData.dropOffuser.firstname + " " + this.widget.orderDetailsData.dropOffuser.lastname,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: UIUtills().getTextStyleRegular(
                                          fontSize: 16, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.4),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    flagOperation(i);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(22), bottom: UIUtills().getProportionalWidth(15)),
                                    child: Image.asset(
                                      AppImage.orderIcon3,
                                      color: AppColor.textColorLight,
                                      height: UIUtills().getProportionalWidth(25),
                                      width: UIUtills().getProportionalWidth(25),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ((i == 0) ? !isConfirmPickup : !isConfirmDropOff)
                              ? CommonButton(
                                  height: UIUtills().getProportionalWidth(33),
                                  width: UIUtills().getProportionalWidth(165),
                                  backgroundColor: AppColor.primaryColor,
                                  onPressed: () {
                                    if (i == 0) {
                                      confirmOrderPickUp();
                                    } else {
                                      inputCode();
                                      this.widget.onStatusChange(2);
                                    }
                                    setState(() {});
                                  },
                                  textColor: AppColor.textColor,
                                  characterSpacing: 0,
                                  fontName: AppFont.sfProTextMedium,
                                  radius: 15,
                                  padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(0)),
                                  fontsize: 14,
                                  text: (i == 0) ? AppTranslations.globalTranslations.ConfirmPickUp : AppTranslations.globalTranslations.ConfirmDropOff,
                                  margin: EdgeInsets.only(
                                    left: UIUtills().getProportionalWidth(0),
                                    right: UIUtills().getProportionalWidth(0),
                                  ),
                                )
                              : getTickWidget(i)
                        ],
                      ),
                    ],
                  ),
                )),
            Visibility(
              visible: (i == 1 && !this.widget.orderDetailsData.atHome),
              child: Container(
                  height: UIUtills().getProportionalWidth(30),
                  width: UIUtills().getProportionalWidth(284),
                  decoration: BoxDecoration(
                      color: AppColor.dividerBackgroundColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                  child: Center(
                      child: Text(
                    "Not At Home",
                    style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfProTextRegular, color: AppColor.textColor, characterSpacing: 0.4),
                  ))),
            ),
          ],
        ));
  }

  Widget getAddressNameColumn(int i) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: UIUtills().screenWidth * 0.75,
          height: UIUtills().getProportionalWidth(35.0),
          child: Text(
            this.widget.addresses[i],
            maxLines: 2,
            style: UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfProTextMedium, color: AppColor.textColor, characterSpacing: 0.36),
          ),
        ),
        SizedBox(
          height: UIUtills().getProportionalWidth(20),
        ),
        (i == 0)
            ? getUserDetailsWidget(i)
            : (!isConfirmPickup)
                ? Text(
                    (i == 1) ? this.widget.orderDetailsData.pickUpUser.firstname + " " + this.widget.orderDetailsData.pickUpUser.lastname : "",
                    style:
                        UIUtills().getTextStyleRegular(fontSize: 14, fontName: AppFont.sfProTextMedium, color: AppColor.textColorLight, characterSpacing: 0.36),
                  )
                : getUserDetailsWidget(i)
      ],
    );
  }

  Widget getMainAddressColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getAddressNameColumn(0),
        SizedBox(
          height: UIUtills().getProportionalHeight(27),
        ),
        getAddressNameColumn(1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getIconsColumn(),
        SizedBox(
          width: UIUtills().getProportionalHeight(14),
        ),
        getMainAddressColumn()
      ],
    );
  }

  void confirmOrderPickUp() {
    orderStatusSubscription = this.bloc.confirmOrderPickUpStream.listen((BaseResponse response) async {
      orderStatusSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        this.bloc.orderTrackingStatus = 4;
        this.widget.onStatusChange(this.bloc.orderTrackingStatus);
        setState(() {});
      } else {
        UIUtills.showSnakBar(context, response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.bloc.confirmOrderPickUp(this.widget.orderDetailsData.orderId);
  }

  void confirmOrderDropOff() {
    var validationResult = this.bloc.isValidFormDropOffimage();
    if (!validationResult.item1) {
      Utils.showAlert(this.widget.ctx, message: validationResult.item2, arrButton: ["Ok"], callback: (i) {
//        NavigationService().pop();
      });
      return;
    }

    orderStatusSubscription = this.bloc.confirmOrderDropOffStream.listen((BaseResponse response) async {
      orderStatusSubscription.cancel();

      UIUtills().dismissProgressDialog(this.widget.ctx);
      if (response.status) {
        this.bloc.orderTrackingStatus = 5;
        Navigator.of(context).pop();

        this.widget.onStatusChange(5);
        Future.delayed(Duration(seconds: 7), () {
          PlatformChannel().stopLocationService();
        });

        setState(() {});
      } else {
        Utils.showAlert(this.widget.ctx, message: response.message, arrButton: ["Ok"], callback: (i) {
          Navigator.of(context).pop();
        });
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(this.widget.ctx);
    this.bloc.confirmOrderDropOff(this.widget.orderDetailsData.orderId);
  }

  void flagOperation(int i) {
    final arrButton = [
      AppTranslations.globalTranslations.user,
      AppTranslations.globalTranslations.address,
      AppTranslations.globalTranslations.both,
    ];
    final message = AppTranslations.globalTranslations.flagTitle;
    if (Platform.isAndroid) {
      Utils.showAlert(context, message: message, arrButton: arrButton, callback: (int index) {
        switch (index) {
          case 0:
            flagUser(this.widget.orderDetailsData.userId);
            break;
          case 1:
            flagAddress(i == 0 ? this.widget.orderDetailsData.pickupLocation : this.widget.orderDetailsData.dropoffLocation);
            break;
          case 2:
            flagUser(this.widget.orderDetailsData.userId, callback: (str) {
              flagAddress(i == 0 ? this.widget.orderDetailsData.pickupLocation : this.widget.orderDetailsData.dropoffLocation, message: str + "\n");
            });
            break;
          default:
            return;
        }
      });
    } else if (Platform.isIOS) {
      Utils.showBottomSheet(context,
          title: message,
          titleStyle: UIUtills().getTextStyle(fontName: AppFont.sfProTextRegular, fontsize: 14, color: AppColor.textColorLight),
          arrButton: arrButton, callback: (int index) async {
        if (index == -1) {
          return;
        }
        switch (index) {
          case 0:
            flagUser(this.widget.orderDetailsData.userId);
            break;
          case 1:
            flagAddress(i == 0 ? this.widget.orderDetailsData.pickupLocation : this.widget.orderDetailsData.dropoffLocation);
            break;
          case 2:
            flagUser(this.widget.orderDetailsData.userId, callback: (str) {
              flagAddress(i == 0 ? this.widget.orderDetailsData.pickupLocation : this.widget.orderDetailsData.dropoffLocation, message: str + "\n");
            });
            break;
          default:
            return;
        }
      });
    }
  }

  Future<void> flagUser(String userId, {VoidCallbackString callback}) {
    flagUserSubscription = this.flagBloc.flagUserStream.listen((BaseResponse response) async {
      flagUserSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        if (callback == null) UIUtills.showSnakBar(context, response.message);
      } else {
        if (callback == null) UIUtills.showSnakBar(context, response.message);
      }
      callback(response.message);
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.flagBloc.flagUserApi(userId);
  }

  void flagAddress(PickupLocation location, {String message = ""}) {
    flagAddressSubscription = this.flagBloc.flagAddressStream.listen((BaseResponse response) async {
      flagAddressSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
      if (response.status) {
        UIUtills.showSnakBar(context, message + response.message);
      } else {
        UIUtills.showSnakBar(context, message + response.message);
      }
    });

    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.flagBloc.flagAddressApi(location);
  }
}
