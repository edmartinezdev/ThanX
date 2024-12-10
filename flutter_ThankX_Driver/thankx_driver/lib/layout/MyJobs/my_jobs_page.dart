import 'package:flutter/material.dart';
import 'package:thankxdriver/control/custom_tabs.dart' as mycustomtab;
import 'package:thankxdriver/layout/MyJobs/HistoryTab/history_page.dart';

import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'ClaimedOrders/claimed_order_list.dart';

class MyJobsPage extends StatefulWidget {
  @override
  _MyJobsPageState createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> with SingleTickerProviderStateMixin {

  var selectedTextStyle = UIUtills().getTextStyleRegular(
      fontSize: 13, fontName: AppFont.sfProTextBold, color: AppColor.textColor);

  var unSelectedTextStyle = UIUtills().getTextStyleRegular(
      fontSize: 13,
      fontName: AppFont.sfProTextRegular,
      color: AppColor.textColor);

  TabController _controller;
  int tabIndex = 0;

  final List<Widget> tabChildren = [ClaimedOrdersList(), HistoryPage()];

  @override
  initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(_handletabChanges);
  }

  _handletabChanges() {
    tabIndex = _controller.index;
    print("notified");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(70),
          ),
          child: Column(
            children: <Widget>[
              appBarContainer(),
              Expanded(
                child: getMainWidget(),
              )
            ],
          ),
        ));
  }

  Widget appBarContainer() {
    return Container(
      margin: EdgeInsets.only(
          left: UIUtills().getProportionalWidth(16),
          right: UIUtills().getProportionalWidth(16)),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              "My Jobs",
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

  Widget getTabWidget() {
    return Container(
        decoration: BoxDecoration(
            color: AppColor.tabBarBackGroundColor,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        alignment: Alignment.center,
        height: UIUtills().getProportionalWidth(39),
        margin: EdgeInsets.only(
            top: UIUtills().getProportionalWidth(16),
            bottom: UIUtills().getProportionalWidth(0),
            left: UIUtills().getProportionalWidth(16),
            right: UIUtills().getProportionalWidth(16)),
        padding: EdgeInsets.only(
            left: UIUtills().getProportionalWidth(4),
            right: UIUtills().getProportionalWidth(4)),
        child: Container(
          child: mycustomtab.TabBar(
            indicatorPadding: EdgeInsets.all(UIUtills().getProportionalWidth(4)),
            controller: _controller,
            unselectedLabelColor: Colors.transparent,
            inactiveBackgroundColor: AppColor.tabBarBackGroundColor,
            indicatorWeight: 0.1,
            tabs: [getTabBarLabel("Claimed", 0), getTabBarLabel("History", 1)],
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
                  BoxShadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 0.7,
                      spreadRadius: -1.0,
                      color: AppColor.textColorLight),
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

  Widget getMainWidget() {
    return Column(
      children: <Widget>[
        getTabWidget(),
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(20)),
          height: 0.5,
          width: double.infinity,
          color: AppColor.textColorLight,
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
    );
  }
}
