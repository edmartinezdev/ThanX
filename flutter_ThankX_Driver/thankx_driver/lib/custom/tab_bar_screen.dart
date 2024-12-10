import 'package:flutter/material.dart';
import 'package:thankxdriver/layout/MePage/me_page.dart';
import 'package:thankxdriver/layout/MyJobs/my_jobs_page.dart';
import 'package:thankxdriver/layout/OrdersPage/orders_page.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AppLifecycleState _notification;
  TabController controllerTab;
  int tabIndex = 0;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    controllerTab = TabController(
      length: 3,
      vsync: this,
    );
    controllerTab.addListener(_handletabChanges);
  }

  _handletabChanges() {
    tabIndex = controllerTab.index;
    print("notified");
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    UIUtills().updateScreenDimesion(height: deviceSize.height, width: deviceSize.width);

    return Scaffold(
      body: body(),
      backgroundColor: AppColor.whiteColor,
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }

  Widget body() {
    return TabBarView(
      controller: controllerTab,
      physics: NeverScrollableScrollPhysics(),
      children: [
        OrdersPage(),
        MyJobsPage(),
        MePage(),
      ],
    );
  }

  Widget customBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.only(bottom: (MediaQuery.of(context).viewPadding.bottom > 0) ? 20 : 0),
      height: UIUtills().getProportionalHeight(55),
      child: TabBar(
        controller: controllerTab,
        labelColor: AppColor.textColor,
        indicatorColor: Colors.transparent,
        onTap: (i) {
          print(i);
        },
        unselectedLabelColor: AppColor.textColorLight,
        indicatorWeight: 1.0,
        tabs: [
          getTabBarLabel("Orders", 0, AppImage.ordersHover),
          getTabBarLabel("My Jobs", 1, AppImage.myJobsHover),
          getTabBarLabel("Me", 2, AppImage.me),
        ],
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        border: Border(
          top: BorderSide(color: AppColor.textColorLight, width: 0.2),
        ),
      ),
    );
  }

  Widget getTabBarLabel(String label, int index, String icon) {
    bool isSelected = (index == tabIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ImageIcon(
          AssetImage(icon),
          size: 24.0,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: (isSelected)
              ? UIUtills().getTextStyle(
                  color: AppColor.textColor,
                  fontName: AppFont.sfProTextMedium,
                  fontsize: 10,
                )
              : UIUtills().getTextStyle(
                  color: AppColor.tabTextColor,
                  fontName: AppFont.sfProTextMedium,
                  fontsize: 10,
                ),
        )
      ],
    );
  }
}
