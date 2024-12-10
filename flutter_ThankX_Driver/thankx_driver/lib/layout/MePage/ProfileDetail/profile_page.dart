import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/profile_detail_bloc.dart';
import 'package:thankxdriver/control/custom_tabs.dart' as mycustomtab;
import 'package:thankxdriver/layout/MePage/ProfileDetail/DriverTab/update_driver_details.dart';
import 'package:thankxdriver/layout/MePage/ProfileDetail/PersonalTab/update_personal_details.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'DriverTab/driver_tab.dart';
import 'PersonalTab/personal_tab.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfileDetailBloc profileDetailBloc;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileDetailBloc _profileDetailBloc = ProfileDetailBloc();
  StreamSubscription<UserProfileResponse> _getUserProfileSubscription;
  StreamSubscription<GetDriverResponse> _getDriverSubscription;

  var selectedTextStyle = UIUtills().getTextStyleRegular(fontSize: 13, fontName: AppFont.sfProTextBold, color: AppColor.textColor);

  var unSelectedTextStyle = UIUtills().getTextStyleRegular(fontSize: 13, fontName: AppFont.sfProTextRegular, color: AppColor.textColor);

  TabController _controller;
  int tabIndex = 0;

  bool isSelected = false;

  void _handleEditAction() {
    FocusScope.of(context).unfocus();
    isSelected = !isSelected;
    if (tabIndex == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return UpdatePersonalDetails(
          profileDetailBloc: this._profileDetailBloc,
        );
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return UpdateDriverDetails(
          profileDetailBloc: this._profileDetailBloc,
        );
      }));
    }
    setState(() {
      isSelected = !isSelected;
    });
  }

  void _handleCancelEditAction() {
    FocusScope.of(context).unfocus();
    isSelected = !isSelected;
  }

  @override
  initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(_handleTabChanges);
    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
      () => this.callGetUserProfileApi(),
    );
    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
      () => this.callGetDriverApi(),
    );
  }

  _handleTabChanges() {
    tabIndex = _controller.index;
    print("notified");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabChildren = [
      PersonalTab(
        profileDetailBloc: this._profileDetailBloc,
      ),
      DriverTab(
        profileDetailBloc: this._profileDetailBloc,
      )
    ];
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
              SizedBox(
                height: UIUtills().getProportionalHeight(18),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    getTabWidget(),
                    Container(
                      margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(9)),
                      height: 1,
                      width: double.infinity,
                      color: AppColor.dialogDividerColor,
                    ),
                    Expanded(
                        child: Container(
                      width: double.infinity,
                      child: TabBarView(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: tabChildren,
                      ),
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget appBarContainer() {
    return Container(
      margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(6), right: UIUtills().getProportionalWidth(16)),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.only(
                      left: UIUtills().getProportionalWidth(10),
                      right: UIUtills().getProportionalWidth(10),
                      top: UIUtills().getProportionalWidth(10),
                      bottom: UIUtills().getProportionalWidth(10)),
                  child: Image.asset(AppImage.backArrow)),
            ),
            Container(
              padding: EdgeInsets.only(top: UIUtills().getProportionalWidth(10), bottom: UIUtills().getProportionalWidth(10)),
              child: Text(
                AppTranslations.globalTranslations.profileTitle,
                style: UIUtills().getTextStyle(
                  characterSpacing: 0.4,
                  color: AppColor.appBartextColor,
                  fontsize: 17,
                  fontName: AppFont.sfProTextSemibold,
                ),
              ),
            ),
            InkWell(
              onTap: isSelected ? this._handleCancelEditAction : _handleEditAction,
              child: Container(
                padding: EdgeInsets.only(
                    left: UIUtills().getProportionalWidth(10),
                    right: UIUtills().getProportionalWidth(10),
                    top: UIUtills().getProportionalWidth(10),
                    bottom: UIUtills().getProportionalWidth(10)),
                child: Text(
                  isSelected ? AppTranslations.globalTranslations.txtSave : AppTranslations.globalTranslations.txtEdit,
                  style: UIUtills().getTextStyle(
                    characterSpacing: 0.25,
                    color: AppColor.appBartextColor,
                    fontsize: 11,
                    fontName: AppFont.sfProTextSemibold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTabWidget() {
    return Container(
        decoration: BoxDecoration(color: AppColor.tabBarBackGroundColor, borderRadius: BorderRadius.all(Radius.circular(8))),
        alignment: Alignment.center,
        height: UIUtills().getProportionalWidth(39),
        margin: EdgeInsets.only(
            bottom: UIUtills().getProportionalWidth(0),
            left: UIUtills().getProportionalWidth(16),
            right: UIUtills().getProportionalWidth(16)),
        padding: EdgeInsets.only(left: UIUtills().getProportionalWidth(4), right: UIUtills().getProportionalWidth(4)),
        child: Container(
          child: mycustomtab.TabBar(
            indicatorPadding: EdgeInsets.all(UIUtills().getProportionalWidth(4)),
            controller: _controller,
            unselectedLabelColor: Colors.transparent,
            inactiveBackgroundColor: AppColor.tabBarBackGroundColor,
            indicatorWeight: 0.1,
            tabs: [getTabBarLabel(AppTranslations.globalTranslations.personalTab, 0), getTabBarLabel(AppTranslations.globalTranslations.driverTab, 1)],
          ),
        ));
  }

  Widget getTabBarLabel(String label, int index) {
    bool isSelected = (index == tabIndex);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          boxShadow: (isSelected)
              ? [
                  BoxShadow(offset: Offset(1.0, 1.0), blurRadius: 0.7, spreadRadius: -1.0, color: AppColor.textColorLight),
                ]
              : kElevationToShadow[0]),
      height: UIUtills().getProportionalWidth(30),
      width: UIUtills().getProportionalWidth(250),
      child: Center(
          child: Text(
        label,
        style: (isSelected) ? selectedTextStyle : unSelectedTextStyle,
      )),
    );
  }

  void callGetUserProfileApi() {
    _getUserProfileSubscription = this._profileDetailBloc.getProfileStream.listen((UserProfileResponse response) {
      _getUserProfileSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
        () {
          UIUtills().dismissProgressDialog(context);
          if (!response.status) {
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            return;
          }
          setState(() {});
        },
      );
    });
    UIUtills().showProgressDialog(context);
    this._profileDetailBloc.callGetUserProfileApi();
  }

  void callGetDriverApi() {
    _getDriverSubscription = this._profileDetailBloc.getDriverStream.listen((GetDriverResponse response) {
      _getDriverSubscription.cancel();

      Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
        () {
          UIUtills().dismissProgressDialog(context);
          if (!response.status) {
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            return;
          }
          setState(() {});
        },
      );
    });
    UIUtills().showProgressDialog(context);
    this._profileDetailBloc.callGetDriverApi();
  }
}
