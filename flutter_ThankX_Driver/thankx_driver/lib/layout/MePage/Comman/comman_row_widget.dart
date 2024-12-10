import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';


class CommanRowWidget extends StatelessWidget {

  String image;
  String lable;
  VoidCallback onPress;

  CommanRowWidget({this.image, this.lable, this.onPress});

  @override
  Widget build(BuildContext context) {
    return mainRow();
  }
  Widget mainRow() {
    return GestureDetector(
      onTap: this.onPress,
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(22),
            left: UIUtills().getProportionalWidth(26),
            right: UIUtills().getProportionalWidth(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
//                height: UIUtills().getProportionalHeight(30),
//                width: UIUtills().getProportionalWidth(30),
                  child: Image.asset(
                    this.image,
                    height: UIUtills().getProportionalHeight(40),
                    width: UIUtills().getProportionalWidth(40),
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: UIUtills().getProportionalWidth(19)),
//                     height: UIUtills().getProportionalHeight(30),
                    child: Text(
                      this.lable,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppFont.helveticaNeueLight,
                          color: AppColor.mePageTextColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6
                      ),
                    )),
              ],
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(AppImage.rightArrow),
            )
          ],
        ),
      ),
    );
  }

}
