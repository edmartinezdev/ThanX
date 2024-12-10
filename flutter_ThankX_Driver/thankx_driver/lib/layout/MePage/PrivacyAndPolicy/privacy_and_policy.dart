import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';


class PrivacyAndPolicy extends StatefulWidget {
  @override
  _PrivacyAndPolicyState createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
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
          AppTranslations.globalTranslations.privacyAndpolicyTitle,
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
          ),),
      ),
    );
  }
}
