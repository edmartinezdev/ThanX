
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
class CommonButton extends StatelessWidget {
  Color backgroundColor;
  String text;
  Color textColor;
  String fontName;
  int fontsize;
  double height;
  double width;
  VoidCallback onPressed;
  double characterSpacing;
  double elevation;
  EdgeInsets margin;
  EdgeInsets padding;
  double radius;
  TextStyle style;

  CommonButton({
    this.backgroundColor,
    this.text,
    this.textColor,
    this.fontName,
    this.fontsize,
    this.height,
    this.width,
    this.onPressed,
    this.characterSpacing,
    this.radius,
    this.elevation = 0,
    this.padding,
    this.margin = const EdgeInsets.all(0),
    this.style
  });
  @override
  Widget build(BuildContext context) {

    if(style==null){
      style= UIUtills().getTextStyleRegular(
          color: textColor ?? AppColor.whiteColor,
          fontName: fontName ?? AppFont.sfProTextMedium,
          fontSize: fontsize ?? 17,
          characterSpacing: characterSpacing ?? 0
      );
    }

    return Container(
      margin: margin,
      width: width ?? double.infinity,
      height: height ?? UIUtills().getProportionalHeight(58),
      child: RaisedButton(
        elevation: elevation,
        color: backgroundColor ?? AppColor.primaryColor,
        onPressed: onPressed,
        padding: padding ?? EdgeInsets.all(0) ,
        child: Text(
          text,
          style:style,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 10)),
      ),
    );
  }
}



