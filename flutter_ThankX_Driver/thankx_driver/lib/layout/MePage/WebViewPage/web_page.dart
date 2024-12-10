import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import 'package:webview_flutter/webview_flutter.dart';


enum WebViewType {
  aboutUs,
  termsCondition,
  privacyPolicy,
}
class WebViewPage extends StatefulWidget {
  WebViewType webViewType;

  WebViewPage({@required this.webViewType});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final CMSBLOC _cmsBloc = CMSBLOC();
  StreamSubscription<CMSResponse> _cmsSubscription;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
            () => this._callApiForCMSDetail());
  }

  @override
  void dispose() {
    if (this._cmsSubscription != null) {
      this._cmsSubscription.cancel();
    }
    this._cmsBloc.dispose();
    super.dispose();
  }

  String get strScreenTitle {
    String tiile = "";
    if (this.widget.webViewType == WebViewType.termsCondition) {
      tiile = AppTranslations.globalTranslations.termsTitle;
    } else if (this.widget.webViewType == WebViewType.privacyPolicy) {
      tiile = AppTranslations.globalTranslations.privacyAndpolicyTitle;
    } else if (this.widget.webViewType == WebViewType.aboutUs) {
      tiile = AppTranslations.globalTranslations.aboutUsTitle;
    }
    return tiile;
  }

  String get strHtmlText {
    String htmlText = "";
    if (this._cmsBloc.cmsModel != null) {
      if (this.widget.webViewType == WebViewType.termsCondition) {
        htmlText = this._cmsBloc.cmsModel.termsConditionDriver;
      } else if (this.widget.webViewType == WebViewType.privacyPolicy) {
        htmlText = this._cmsBloc.cmsModel.privacyPolicyDriver;
      } else if (this.widget.webViewType == WebViewType.aboutUs) {
        htmlText = this._cmsBloc.cmsModel.aboutUs;
      }
    }
    return htmlText;
  }

//  Widget get appBar {
//    return AppBar(
//      elevation: 1.5,
//      backgroundColor: AppColor.whiteColor,
//      title: Text(
//        this.strScreenTitle,
//        style: UIUtils().getTextStyleRegular(
//          color: AppColor.empressColor,
//          fontName: AppFont.robotoBold,
//          fontsize: 16,
//          characterSpacing: 0.5,
//        ),
//      ),
//      leading: IconButton(
//          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
//          icon: Image.asset(AppImage.back),
//          onPressed: this._handleBackButtonEvent),
//      centerTitle: true,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if (this.strHtmlText.length > 0) {
      String htmText = this.strHtmlText;

        if (Platform.isIOS && !htmText.contains("<html>")) {
          htmText = """<!DOCTYPE html>
                        <html>
                          <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                          <body style='"margin: 0; padding: 0;'>
                            <div>
                              $htmText
                            </div>
                          </body>
                        </html>
                     """;
        }

      final uri = Uri.dataFromString(htmText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString();

      body = Padding(
        padding: EdgeInsets.all(5.0),
        child: WebView(
          initialUrl: uri,
          javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: false,
          gestureRecognizers: Set(),
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      );
    }

    return Scaffold(
        key: _key,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              NavigationService().pop();
            },
            child: Image.asset(AppImage.backArrow),
          ),
          title: Text(
            this.strScreenTitle,
            style: UIUtills().getTextStyle(
              characterSpacing: 0.4,
              color: AppColor.appBartextColor,
              fontsize: 17,
              fontName: AppFont.sfProTextSemibold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.whiteColor,
          elevation: 0.5,
        ),
        body: body);
  }

  void _callApiForCMSDetail() {
    this._cmsSubscription = this._cmsBloc.cmsResponseStream.listen(
          (CMSResponse response) {
        this._cmsSubscription.cancel();
        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
              () {
            UIUtills().dismissProgressDialog(context);
            if (response.status) {
              setState(() {});
            } else {
              Utils.showSnakBarwithKey(_key, response.message);
            }
          },
        );
      },
    );
    UIUtills().showProgressDialog(context);
    this._cmsBloc.getCMSDetails();
  }
//  void _callApiForCMSDetail() {
//    this._cmsSubscription = this._cmsBloc.cmsResponseStream.listen(
//          (CMSResponse response) {
//        this._cmsSubscription.cancel();
//        Future.delayed(
//          Duration(milliseconds: this.widget.apiCallHaltDurationInMilliSecond),
//              () {
//            this.widget.dismissProgressDialog();
//            if (response.status) {
//              setState(() {});
//            } else {
//              Utils.showSnakBar(this.widget.pageContext, response.message);
//            }
//          },
//        );
//      },
//    );
//    this.widget.showProgressDialog();
//    this._cmsBloc.getCMSDetails();
//  }
}
