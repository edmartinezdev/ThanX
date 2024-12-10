import 'package:flutter/cupertino.dart';

import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

typedef NotificaionSettingCallback = void Function(bool isActive);

class NotificationTile extends StatefulWidget {
  String title;
  String explanation;
  bool isActive;
  NotificaionSettingCallback callback;

  NotificationTile({this.title, this.explanation, this.isActive = true, this.callback});

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(32)),
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.widget.title,
                  style: UIUtills().getTextStyle(
                      fontName: AppFont.sfProTextRegular,
                      fontsize: 14,
                      color: AppColor.notificationSettingsTextColor),
                ),
                Row(children: <Widget>[
                  Expanded(child: Container(
                    margin:
                    EdgeInsets.only(top: UIUtills().getProportionalHeight(10)),
                    child: Text(
                      this.widget.explanation,
                      maxLines: 2,
                      style: UIUtills().getTextStyle(
                          fontName: AppFont.sfProDisplayLight,
                          fontsize: 12,
                          color: AppColor.notificationSettingsTextColor),
                    ),
                  ),),
                  GestureDetector(
                    onTap: () {
                      this.widget.isActive = !this.widget.isActive;
                      if (this.widget.callback != null) {
                        this.widget.callback(this.widget.isActive);
                      }
                      setState(() {});
                    },
                    child: Container(
                      child: Image.asset((this.widget.isActive)
                          ? AppImage.switchOn
                          : AppImage.switchOff),
                    ),
                  )
                ],)
              ],
            ),
          );
  }
}
