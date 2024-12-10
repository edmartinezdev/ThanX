import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/common_widget.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class NotificationView extends StatelessWidget {

  String title = "";
  String subTitle = "";
  final VoidCallback onTap;

  NotificationView({this.title, this.subTitle,this.onTap});

  @override
  Widget build(BuildContext context) {

    final textStyleTitle = UIUtills().getTextStyleRegular(fontSize: 13, fontName: AppFont.sfProTextMedium, color: AppColor.textColor);
    final textStyleSubtitle = UIUtills().getTextStyleRegular(fontSize: 11, fontName: AppFont.sfProTextRegular, color: AppColor.textColor);
    final textTitle = Text(this.title, style: textStyleTitle);
    final textSubTitle = Text(this.subTitle, style: textStyleSubtitle, maxLines: 3,);
    final columnText = Column(children: <Widget>[textTitle, Padding(padding: EdgeInsets.only(top: 3)), textSubTitle], crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,);
    final double textContainerWidth = UIUtills().screenWidth - (20.0 + 20.0 +  15.0);
    final textContainer = Container(child: columnText, width: textContainerWidth,);

    final row = Row(children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 15.0)),
      textContainer
    ],);

    final boxDecoration = CommonWidget.createRoundedBoxWithShadow(radius: 5.0);
    final containerNotifcationView = Container(decoration: boxDecoration, child: row, padding: EdgeInsets.all(10.0),);

    final containerMain = Container(child: containerNotifcationView, color: Colors.transparent, padding: EdgeInsets.all(10.0), width: UIUtills().screenWidth,);
    final containerInkWell = InkWell(child: SafeArea(child: containerMain, bottom: false,), onTap: () {
      // perform notification action
      if (this.onTap != null) {
        this.onTap();
      }
    },);
    return Material(child: containerInkWell,);
  }
}
