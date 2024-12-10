import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:thankx_user/control/navigation_serviece.dart';
import 'package:thankx_user/layout/login.dart';
import 'package:thankx_user/utils/app_color.dart';

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
  final Map<String, WidgetBuilder> routes = {
    // Login page
    '/Login': (BuildContext context) => LoginPage(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      final materailApp = MaterialApp(
          //onGenerateTitle: (BuildContext _context) => AppTranslations.of(_context).screenTitleLogin,
          localizationsDelegates: localizationsDelegates,
          locale: model.appLocal,
          debugShowCheckedModeBanner: false,
          supportedLocales: model.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          initialRoute: '/Login',
          routes: routes,
          theme: new ThemeData(
            primaryColor: AppColor.primaryColor1,
          ),
          navigatorKey: NavigationService().navigatorKey);

      final overlaySupport = OverlaySupport(child: materailApp);
      return overlaySupport;
    });
  }

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
}
