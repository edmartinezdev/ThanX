import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
class TaxInformationPage extends StatefulWidget {
  CMSBLOC bloc;

  TaxInformationPage({this.bloc});

  @override
  _TaxInformationPageState createState() => _TaxInformationPageState();
}

class _TaxInformationPageState extends State<TaxInformationPage> {

  Future<void> _launchInBrowser() async {
    if (this.widget.bloc.cmsModel.taxInformation != null) {
      String url = this.widget.bloc.cmsModel.taxInformation;
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Could not launch $url';
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.taxInformationTitle,
          style: UIUtills().getTextStyle(
              color: AppColor.appBartextColor,
              fontsize: 17,
              fontName: AppFont.sfCompactSemiBold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body:Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(40),
              left: UIUtills().getProportionalWidth(28),
              right: UIUtills().getProportionalWidth(28)
          ),
          child: GestureDetector(
            onTap: () async {
              _launchInBrowser();
//              final directory = await getApplicationDocumentsDirectory();
//              await FlutterDownloader.enqueue(
//                url: this.widget.bloc.cmsModel.taxInformation,
//                savedDir: directory.path,
//                showNotification: true, // show download progress in status bar (for Android)
//                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
//              );

            },
            child: TextFieldWithLabel(
              controller: this.widget.bloc.taxInfoController,
              enabled: false,
              suffixIcon: ImageIcon(
                AssetImage(AppImage.downloadIcon),
                color: AppColor.textColor,
              ),
              keyboardType: TextInputType.text,
              textType: TextFieldType.none,
              action: TextInputAction.next,
              style: UIUtills().getTextStyleRegular(
                color: AppColor.textColor,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              labelText: AppTranslations.globalTranslations.selectfileText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
            ),
          ),
        ),
      ],),
    );
  }
}


