import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankx_user/control/progress_dialog.dart';
import 'package:thankx_user/utils/app_color.dart';
import 'package:thankx_user/utils/app_font.dart';
import 'package:thankx_user/utils/app_image.dart';
import 'package:thankx_user/utils/logger.dart';
import 'package:thankx_user/utils/ui_utils.dart';
export 'package:flutter/material.dart';

typedef VoidCallBack = void Function();
typedef ShowDialogCallback = void Function(int);

typedef ListBuilderCallBack = Widget Function(BuildContext context, int index);

// ignore: must_be_immutable
abstract class BaseStatefulWidget extends StatefulWidget {

  int get apiCallHaltDurationInMilliSecond => 100;

  GlobalKey<ScaffoldState> pageScaffoldKey;

  Widget createScaffoldWidget({BuildContext context, Widget appBar, Widget child, Color backgroundColor = const Color(0xFFFFFFFF),
    Widget floatingActionButton,
    GlobalKey<ScaffoldState> scaffoldKey ,
    bool resizeToAvoidBottomInset = true,
    bool isNeedAppBarIfNull = true,
    Widget drawerWidget
  }) {

    if(scaffoldKey == null){
      scaffoldKey = GlobalKey<ScaffoldState>();
    }
    pageScaffoldKey = scaffoldKey;

//    FirebaseCloudMessagagingWapper().assignCurrentPageContext(this.pageScaffoldKey.currentContext);
//    ApiProvider().logoutCallBack = () {
//      this.forceLogoutOperaion();
//    };

    Widget appBarUpdated = appBar;
    if (appBarUpdated == null && isNeedAppBarIfNull) {
      appBarUpdated = PreferredSize(
        child: AppBar(
          elevation: 0.0,
          backgroundColor: backgroundColor,
        ),
        preferredSize: Size.fromHeight(0.0),
      );
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBarUpdated,
      body: child,
      key: scaffoldKey,
      drawer: drawerWidget,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
    );
  }

//  Future<void> forceLogoutOperaion() async {
//    final message = AppTranslations.globalTranslations.msgForceLogout;
//    List<String> arrButton = [AppTranslations.globalTranslations.buttonOk];
//    Utils.showAlert(this._pageContext, title: '', message: message, arrButton: arrButton, callback: (_) async {
//
//      await User.currentUser.resetUserDetails();
//      ScoketProvider().disconnectFromconnectToServer();
//      final route = MaterialPageRoute(builder: (BuildContext context) => LoginOptionPage());
//      Navigator.of(this._pageContext).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
//    });
//  }

  InputBorder get focusBorder => UnderlineInputBorder(
      borderSide: new BorderSide(color: AppColor.darkSkyBlueColor, width: 2));

  InputBorder get enableBorder => new UnderlineInputBorder(
      borderSide: new BorderSide(color: AppColor.gumLeafColor, width: 0.5));

  Widget createButton(
      {String title,
        String imageName = "",
        Color bgColor,
        double width,
        double height,
        TextStyle style,
        bool isshadowRequire = true,
        GestureTapCallback onTap}) {
    Widget textRow;

    final textStyle = style ??
        UIUtills().getTextStyle(
            color: AppColor.whiteColor,
            fontsize: 16,
            fontName: AppFont.robotoMedium);

    if (imageName.length == 0) {
      textRow = Text(
        title,
        style: textStyle,
      );
    } else {
      textRow = Row(
        children: <Widget>[
          Image.asset(
            imageName,
            height: 16.0,
            width: 16.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          Text(
            title,
            style: textStyle,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }

    return Container(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: Container(
              child: textRow,
              height: height ?? UIUtills().getProportionalWidth(54.0),
              width: width ?? double.infinity,
              alignment: Alignment.center,
            ),
            onTap: onTap,
          ),
        ),
        decoration: isshadowRequire
            ? BoxDecoration(
            boxShadow: kElevationToShadow[2],
            color: bgColor,
            borderRadius: BorderRadius.all(Radius.circular(6.0)))
            : null);
  }

  // ignore: missing_return
  Future<void> showProgressDialog() {
    Logger().v("DisPlay Loader");
    showDialog(
        barrierDismissible: false,
        context: this.pageScaffoldKey.currentContext,
        builder: (_) => ProgressDiloag());
  }

  // ignore: missing_return
  Future<void> dismissProgressDialog() {
    if (Navigator.of(this.pageScaffoldKey.currentContext).canPop()) {
      Navigator.of(this.pageScaffoldKey.currentContext).pop();
    }
  }

  Widget buildForValidaionMessage(
      {String message, Color textcolor = Colors.redAccent}) {
    return Visibility(
      visible: message.length > 0,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          message,
          style: UIUtills().getTextStyle(
              fontName: AppFont.robotoRegular,
              fontsize: 14,
              color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildForValidaionMessage1(
      {String message, Color textcolor = Colors.redAccent, double height = 0}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: Container(
        padding: EdgeInsets.only(left: 3.0, top: 3.0),
        child: Visibility(
          visible: message.length > 0,
          child: Text(
            message,
            style: UIUtills().getTextStyle(
                fontName: AppFont.robotoRegular,
                fontsize: 12,
                color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  /* Pull To Refresh inf list */
  Widget createPullToRefreshListView(
      {@required int itemCount,
        VoidCallBack onRefresh,
        ScrollPhysics physics,
        @required ListBuilderCallBack builder,
        EdgeInsets padding = const EdgeInsets.only(bottom: 5.0),
        ScrollController controller}) {
    if (Platform.isIOS) {
      final silverlistChildDelegate  = SliverChildBuilderDelegate(builder,childCount: itemCount,);

      final scollView = CustomScrollView(
        controller:controller ,
        physics: physics,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(onRefresh: onRefresh, refreshIndicatorExtent: 50.0, refreshTriggerPullDistance: 100.0,),
          SliverPadding(padding: padding, sliver: SliverSafeArea(sliver: SliverList(delegate: silverlistChildDelegate,)),),
        ],
      );
      return scollView;
    } else {

      final listView = ListView.builder(
        physics: physics,
        padding: padding,
        scrollDirection: Axis.vertical,
        itemCount: itemCount,
        itemBuilder: builder,
        controller: controller,
      );

      final refreshIndicator = RefreshIndicator(child: listView, onRefresh: onRefresh);
      final listViewPullToRefresh = Container(child: refreshIndicator, alignment: Alignment.center,);

      return listViewPullToRefresh;
    }
  }
// end pullToRefresh

  //region LoadMore Indictor
  Widget buildLoadMoreProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: SizedBox(
            child: new CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColor.primaryColor1),
              strokeWidth: 2.0,
            ),
            width: 20.0,
            height: 20.0,
          ),
        ),
      ),
    );
  }
  //endregion


  Widget createAppBar({String title, VoidCallback onBackCallback}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColor.whiteColor,
      title: Text(
        title,
        style: UIUtills().getTextStyleRegular(
          color: AppColor.empressColor,
          fontName: AppFont.robotoBold,
          fontSize: 16,
          characterSpacing: 0.5,
        ),
      ),
      leading: Container(
        width: 30.0,
        child: IconButton(
          icon: Image.asset(AppImage.back),
          onPressed: onBackCallback,
        ),
      ),
      centerTitle: true,
    );
  }


}
