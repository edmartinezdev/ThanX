import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/custom/tab_bar_screen.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import 'login_page.dart';

class SubmitDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: UIUtills().getProportionalWidth(365),
        margin: EdgeInsets.all(UIUtills().getProportionalWidth(10)),
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
             Container(
               width: UIUtills().getProportionalWidth(225),
               margin: EdgeInsets.only(
                 top: UIUtills().getProportionalHeight(18),
                 left: UIUtills().getProportionalWidth(17),
               ),
               child: Text(
                AppTranslations.globalTranslations.detailsSubmittedText,
                 style: UIUtills().getTextStyleRegular(
                   fontName: AppFont.sfProDisplayMedium,
                   fontSize: 12,
                   color: AppColor.textColor,
                 ),
               ),
             ),
             Container(
               margin: EdgeInsets.only(
                   top: UIUtills().getProportionalHeight(18),
                   left: UIUtills().getProportionalWidth(17),
                   bottom: UIUtills().getProportionalHeight(18),
                   right: UIUtills().getProportionalWidth(17)),
               color: AppColor.dialogDividerColor,
               height: 0.5,
               width: double.infinity,
             ),
           ],),
            Container(
              margin: EdgeInsets.only(
                  top: UIUtills().getProportionalHeight(18),
                  left: UIUtills().getProportionalWidth(42),
                  bottom: UIUtills().getProportionalHeight(18),right: UIUtills().getProportionalWidth(42)),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
              AppTranslations.globalTranslations.submitDialogText,
                textAlign: TextAlign.center,
                style: UIUtills().getTextStyleRegular(
                    fontName: AppFont.sfProTextBold,
                    fontSize: 15,
                    lineSpacing: 2,
                    color: AppColor.textColor,
                    characterSpacing: 0.4),
              ),
            ),
            CommonButton(
              height: UIUtills().getProportionalWidth(38),
              margin: EdgeInsets.only(
                  top: UIUtills().getProportionalHeight(18),
                  left: UIUtills().getProportionalWidth(17),
                  bottom: UIUtills().getProportionalHeight(18),
                  right: UIUtills().getProportionalWidth(17)),
              width: double.infinity,
//              radius: 5,
              backgroundColor: AppColor.primaryColor,
              onPressed: () {
                var route = MaterialPageRoute(builder: (_) => LoginPage());
                Navigator.of(context).pushAndRemoveUntil(
                    route, (Route<dynamic> route) => false);
              },
              textColor: AppColor.textColor,
              fontName: AppFont.sfProTextSemibold,
              fontsize: 12,
              text: AppTranslations.globalTranslations.btnDone,
              characterSpacing: 0,
            ),
          ],
        ),
      ),
    );
  }
}
