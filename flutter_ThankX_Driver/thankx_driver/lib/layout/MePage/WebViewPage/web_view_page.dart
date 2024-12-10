//import 'dart:convert';
//import 'dart:io' show Platform;
//import 'package:flutter/material.dart';
//import 'package:thankxdriver/utils/app_color.dart';
//import 'package:thankxdriver/utils/app_font.dart';
//import 'package:thankxdriver/utils/app_image.dart';
//import 'package:thankxdriver/utils/ui_utils.dart';
//import 'package:webview_flutter/webview_flutter.dart';
//
//class WebViewPage extends StatefulWidget {
//
//  String titleText,htmlText;
//  WebViewPage({this.titleText,this.htmlText});
//
//  @override
//  _WebViewPageState createState() => _WebViewPageState();
//}
//
//class _WebViewPageState extends State<WebViewPage> {
//  @override
//  Widget build(BuildContext context) {
//
//    String htmlContent = widget.htmlText;
//    if (Platform.isIOS && !htmlContent.contains("<html>")) {
//      htmlContent = """<!DOCTYPE html>
//                        <html>
//                          <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
//                          <body style='"margin: 0; padding: 0;'>
//                            <div>
//                              $htmlContent
//                            </div>
//                          </body>
//                        </html>
//                     """;
//    }
//
//
//    final tmpUrl = new Uri.dataFromString(htmlContent, mimeType: 'text/html',encoding: Encoding.getByName('utf-8'));
//    var webView = WebView(initialUrl: tmpUrl.toString(), javascriptMode: JavascriptMode.unrestricted,);
//
//
//    return Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading: false,
//          leading: InkWell(
//            onTap: () {
//              Navigator.of(context).pop();
//            },
//            child: Image.asset(AppImage.backArrow),
//          ),
//          title: Text(
//            widget.titleText,
//            style: UIUtills().getTextStyle(
//              characterSpacing: 0.4,
//              color: AppColor.appBartextColor,
//              fontsize: 17,
//              fontName: AppFont.sfProTextSemibold,
//            ),
//          ),
//          centerTitle: true,
//          backgroundColor: AppColor.whiteColor,
//          elevation: 0.5,
//        ),
//        body: webView
//    );
//  }
//
//}