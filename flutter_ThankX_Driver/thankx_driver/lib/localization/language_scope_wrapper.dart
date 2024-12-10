import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thankxdriver/api_provider/api_provider.dart';
import 'package:thankxdriver/channel/platform_channel.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/custom/tab_bar_screen.dart';
import 'package:thankxdriver/layout/IntroSlider/into_slider.dart';
import 'package:thankxdriver/layout/LoginAndSignup/login_page.dart';
import 'package:thankxdriver/layout/LoginAndSignup/vehicle_page.dart';
import 'package:thankxdriver/layout/LoginAndSignup/w9_form_page.dart';
import 'package:thankxdriver/main.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/utils.dart';


import 'app_model.dart';
import 'localization.dart';

class ScopeModelWrapper extends StatefulWidget {
  final AppModel appModel;
  bool isUserLogin ;

  ScopeModelWrapper({this.appModel,this.isUserLogin});

  @override
  _ScopeModelWrapperState createState() => _ScopeModelWrapperState();
}

class _ScopeModelWrapperState extends State<ScopeModelWrapper> with WidgetsBindingObserver {

  //Routes for Application
//  final Map<String, WidgetBuilder> routes = {
//    // Login page
//    '/Login': (BuildContext context) =>  IntroSliderPage(),
//  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ApiProvider().logoutCallBack = () => this.forceLogoutOperation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget createChild() {
    // Localization Delegate
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
      AppTranslations.delegate,
    ];

    Widget initialWidget = IntroSliderPage();
    if (this.widget.isUserLogin) {
      if (User.currentUser.vechicleInfoDone == false){
        initialWidget = LoginPage();
      }
      else if (User.currentUser.vechicleInfoDone == true && User.currentUser.isw9FormDone == false){
        initialWidget = LoginPage();
      }
      else if (User.currentUser.vechicleInfoDone == true && User.currentUser.isw9FormDone == true && User.currentUser.isDriverActive == false){
        initialWidget = LoginPage();
      }
      else if(User.currentUser.vechicleInfoDone == true && User.currentUser.isw9FormDone == true && User.currentUser.isDriverActive == true ) {
        initialWidget = TabBarScreen();
      }
    }


    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      final materailApp = MaterialApp(
          //onGenerateTitle: (BuildContext _context) => AppTranslations.of(_context).screenTitleLogin,
          localizationsDelegates: localizationsDelegates,
          locale: model.appLocal,
          debugShowCheckedModeBanner: false,
          showSemanticsDebugger: false,
          supportedLocales: model.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          home: initialWidget,
          theme: new ThemeData(
            primaryColor: AppColor.primaryColor,
          ),
          navigatorKey: NavigationService().navigatorKey);

      final overlaySupport = OverlaySupport(child: materailApp);
      return overlaySupport;
    });
  }

//  Future<bool> _willPopCallback() async {
//    Logger().v("Open Alert for Option");
//    Utils.showAlert(
//      NavigationService().navigatorKey.currentState.overlay.context,
//      message: "Are you sure you want to exit from app?",
//      arrButton: ["Cancel",AppTranslations.globalTranslations.btnOK],
//      callback: (int index) {
//        if(index == 1) {
//          SystemNavigator.pop();
//        }
//      },
//    );
//    return false;
//  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
        model: this.widget.appModel, child: this.createChild());
  }

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    print("======================== Application State : $state ========================");
//    if (state == AppLifecycleState.paused) { // Need To disconnect socket
//      SocketProvider().disconnectFromconnectToServer();
//    } else if (state == AppLifecycleState.resumed) { // Need To connect socket
//      SocketProvider().connectToServer();
//    }
//  }

  //region Force Logout To Handle 401 code
  Future<void> forceLogoutOperation() async {

    final message = AppTranslations.globalTranslations.msgLoginFromOtherDevice;
    List<String> arrButton = [AppTranslations.globalTranslations.buttonOk];
    Utils.showAlert(
        NavigationService().navigatorKey.currentState.overlay.context,
        title: '',
        message: message,
        arrButton: arrButton,
        barrierDismissible: false,
        callback: (_) async {
          //Remove User data
          User.removeUser();
          //Stop Location service
          PlatformChannel().stopLocationService();
          NavigationService().pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>LoginPage()),(Route<dynamic> route) => false);

        });

  }
//endregion
}
