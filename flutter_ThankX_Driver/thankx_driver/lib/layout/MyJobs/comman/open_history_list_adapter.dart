import 'dart:math';

import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/route_widget.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class CardWidget extends StatefulWidget {
  String text;
  String pickPointImage;
  String dropPointImage;
  String order;
  EdgeInsets padding;
  String pickUpAddress;
  String dropDownAddress;
  Color color;

  CardWidget({
    this.order,
    this.text,
    this.pickPointImage,
    this.dropPointImage,
    this.padding,
    this.dropDownAddress,
    this.pickUpAddress,
    this.color,
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return mainCardView();
  }

  Widget mainCardView() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(
          left: UIUtills().getProportionalWidth(16),
          right: UIUtills().getProportionalWidth(16),
          bottom: UIUtills().getProportionalWidth(20)),
      color: AppColor.whiteColor,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(8),
                right: UIUtills().getProportionalWidth(8),
                top: UIUtills().getProportionalWidth(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  this.widget.order,
                  style: UIUtills().getTextStyle(
                      color: AppColor.textColor,
                      fontsize: 12,
                      fontName: AppFont.sfProTextBold),
                ),

                Container(
                  height: UIUtills().getProportionalWidth(33),
                  decoration: BoxDecoration(
                    color: this.widget.color,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(17), right: Radius.circular(17)),
//                      shape: BoxShape.rectangle
                  ),
                  alignment: Alignment.center,
                  padding: this.widget.padding,
                  child: Text(
                    this.widget.text,
                    style: UIUtills().getTextStyle(
                        fontName: AppFont.sfProTextBold,
                        fontsize: 12,
                        characterSpacing: 0.3,
                        color: AppColor.textColor),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(8),
                right: UIUtills().getProportionalWidth(8),
                top: UIUtills().getProportionalWidth(7),
                bottom: UIUtills().getProportionalWidth(8)),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.boarderInCardColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: UIUtills().getProportionalWidth(20),
                  bottom: UIUtills().getProportionalHeight(0),
                  left: UIUtills().getProportionalWidth(8),
                  right: UIUtills().getProportionalWidth(8)),
              child: RouteWidgets(
                pickUpImage: this.widget.pickPointImage,
                dropImage: this.widget.dropPointImage,
                addresses: [
                  this.widget.pickUpAddress,
                  this.widget.dropDownAddress
//                  "123 Main Street, PhileDelphia, PA 12345",
//                  "456 Main Street, Philadelphia, PA 12345"
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
