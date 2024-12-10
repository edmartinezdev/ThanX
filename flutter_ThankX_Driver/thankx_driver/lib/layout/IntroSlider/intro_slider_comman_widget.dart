import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class IntroSliderWidgets extends StatelessWidget {
  String text;
  String image;
  String text1;
  String text2;
  String text3;

  IntroSliderWidgets({
    this.text,
    this.image,
    this.text1,
    this.text2,
    this.text3,
  });

  var textStyle = UIUtills().getTextStyleRegular(
      fontName: AppFont.sfProDisplayLight,
      fontSize: 20,
      color: AppColor.introsliderText,
      characterSpacing: 0.1);

  var textStyle1 = UIUtills().getTextStyleRegular(
      fontName: AppFont.sfProDisplayBold,
      fontSize: 40,
      color: AppColor.introsliderText,
      characterSpacing: 0.2);

  var textStyle2 = UIUtills().getTextStyleRegular(
      fontName: AppFont.sfProTextLight,
      fontSize: 12,
      color: AppColor.textColor,
      lineSpacing: 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: (MediaQuery.of(context).size.height * 1.18) / 4.7,
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(50),
            ),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: UIUtills().getProportionalHeight(170),
              width: UIUtills().getProportionalWidth(226),
            )),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(63),
              left: UIUtills().getProportionalWidth(35),
              right: UIUtills().getProportionalWidth(35)),
          child: Text(
            text1,
            style: textStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(8),
              left: UIUtills().getProportionalWidth(35),
              right: UIUtills().getProportionalWidth(35)),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                bottom: UIUtills().getProportionalHeight(7),
                child: Container(
                  color: AppColor.primaryColor,
                  height: UIUtills().getProportionalHeight(24.0),
                ),
              ),
              Text(
                " " + text2,
                style: textStyle1,
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(10),
              left: UIUtills().getProportionalWidth(35),
              right: UIUtills().getProportionalWidth(35)),
          child: Text(
            text3,
            maxLines: 5,
            style: textStyle2,
          ),
        ),
      ],
    );
  }
}
