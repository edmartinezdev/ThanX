import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class NotificationListAdapter extends StatelessWidget {
VoidCallback callback;
  String title,message ;
  NotificationListAdapter({this.title,this.message, this.callback});

  Widget get divider=>Container(
    height: 0.7,
    width: double.infinity,
    color: AppColor.shadowColor,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      this.callback();
    },child: Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),bottom: UIUtills().getProportionalWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,style: UIUtills().getTextStyleRegular(fontSize: 12,fontName: AppFont.sfProDisplayMedium,color: AppColor.textColor, characterSpacing: 1.5),),
                SizedBox(height: UIUtills().getProportionalWidth(10),),
                Text(message,maxLines:2,style: UIUtills().getTextStyleRegular(fontSize: 10,fontName: AppFont.sfProDisplayLight,color: AppColor.textColor,lineSpacing: 1.5),),
              ],
            ),
          ),
          divider
        ],
      ),
    ),);
  }
}
