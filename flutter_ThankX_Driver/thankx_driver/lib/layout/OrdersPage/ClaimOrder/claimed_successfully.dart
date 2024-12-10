import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';




class ClaimedSuccessfully extends StatelessWidget {
  VoidCallback callback;
  ClaimedSuccessfully({this.callback});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(UIUtills().getProportionalWidth(10)),
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(65),bottom: UIUtills().getProportionalHeight(36)),
                child: Image.asset(AppImage.tickMarkIcon,height: UIUtills().getProportionalWidth(62),width: UIUtills().getProportionalWidth(62),)),
            Container(
              width: UIUtills().getProportionalWidth(225),
              margin: EdgeInsets.only(bottom: UIUtills().getProportionalWidth(50)),
              child: Text(AppTranslations.globalTranslations.claimSuccessMsg,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: AppFont.sfProTextBold,fontSize: 15,color: AppColor.textColor,letterSpacing: 0.4,height : 1.8),),
            ),

            CommonButton(
              height: UIUtills().getProportionalWidth(38),
              margin: EdgeInsets.all(UIUtills().getProportionalWidth(15),),
              width: double.infinity,
              radius: 5,
              backgroundColor: AppColor.primaryColor,
              onPressed: (){
                NavigationService().pop();
                this.callback();
              },
              textColor: AppColor.textColor,
              fontName:AppFont.sfProTextSemibold,
              fontsize: 12,
              text: AppTranslations.globalTranslations.headToOrder,
              characterSpacing: 0,
            ),
          ],
        ) ,
      ),
    );
  }
}
