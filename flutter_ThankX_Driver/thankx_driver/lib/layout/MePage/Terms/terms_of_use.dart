import 'package:flutter/material.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.termsTitle,
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
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.only(
                  left: UIUtills().getProportionalWidth(16),
                  right: UIUtills().getProportionalWidth(16),
                  top: UIUtills().getProportionalHeight(38)),

              width: double.infinity,
              child: Text(
                AppTranslations.globalTranslations.aboutUs,
                style: UIUtills().getTextStyle(
                    fontsize: 12,
                    fontName: AppFont.helveticaNeueLight,
                    color: AppColor.textColor),
              ))
      ),
    );
  }
}