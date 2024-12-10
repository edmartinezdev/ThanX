import 'package:flutter/material.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';

import 'app_color.dart';
import 'app_font.dart';
import 'ui_utils.dart';

enum ButtonType {
  back,
  close,
  menu,
  notification,
  notificationUnread,
  clear,
  save
}

typedef ButtonTapCallback = void Function(ButtonType type);

class CommonWidget {
  static String _getImageName({ButtonType type}) {
    var iconName;
    if (type == ButtonType.back) {
      iconName = Icons.arrow_back_ios;
//    }
//    else if (type == ButtontType.menu) {
//      iconName = AppImage.leftMenu;
//    } else if (type == ButtontType.notification) {
//      iconName = AppImage.notification;
//    } else if (type == ButtontType.notificationUnread) {
//      iconName = AppImage.unread;
    } else if (type == ButtonType.close) {
      iconName = "";
//    } else if (type == ButtontType.clear) {
//      iconName = AppImage.close;
//    }
//    else if (type == ButtontType.save) {
//      iconName = AppImage.tickmark;
//    }

      return iconName;
    }
  }

  static Widget divider({double height = 1.0, EdgeInsets margin = const EdgeInsets.only(),Color color = const Color(0xFFDDDDDD)}) => Container(
        color: color,
        width: double.infinity,
        height: height,
        margin: margin,
      );


//  var gettextstyle = true ? savetextstyle : edittextstyle;

  static Widget createTextField(
      {TextFieldType textType = TextFieldType.none,
      Key key,
      TextInputType keyboardType,
      TextInputAction action = TextInputAction.next,
      VoidCallback onEditCompletie,
      ValueChanged<String> onChanged,
      FocusNode focusNode,
      TextEditingController controller,
      Color cursorColor,
      TextStyle style,
      InputDecoration decoration,
      String hintText,
      Widget prefixIcon,
      EdgeInsets prefixPadding = const EdgeInsets.only(right: 10),
      Color prefixIconColor = const Color(0xFFD8D8D8),
      Widget suffixIcon,
      EdgeInsetsGeometry contentPadding,
      bool enabled,
      GestureTapCallback gestureTapCallback,
      TextCapitalization textCapitalization = TextCapitalization.none,
      bool obscureText = false,
      int maxLength,
      int maxLines = 1,
      TextAlign align = TextAlign.left,
      TextStyle hintTextStyle}) {
    var textStyle = style;
    if (textStyle == null) {
      print("hint textStyle changes");
      textStyle = UIUtills().getTextStyle(
          color: AppColor.textColor,
//          fontName: AppFontName.appFontRegular,
          fontsize: 14);
    }

    if (hintTextStyle == null) {}

    var inputDecoration = decoration;
    if (inputDecoration == null) {
      inputDecoration = InputDecoration(
        hintText: hintText,
        contentPadding:
            contentPadding ?? EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintStyle: hintTextStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      );
    }

    return AITextFormField(
      key: key,
      maxLength: maxLength,
      textType: textType,
      keyboardType: keyboardType,
      autofocus: false,
      action: action,
      onEditingComplete: onEditCompletie,
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      cursorColor: (cursorColor != null) ? cursorColor : AppColor.textColor,
      style: textStyle,
      decoration: inputDecoration,
      enabled: enabled,
      gestureTapCallback: gestureTapCallback,
      textCapitalization: textCapitalization,
      obscureText: textType == TextFieldType.password ? true : obscureText,
      maxLines: maxLines,
      textAlign: align,
    );
  }



  //Custom Button
  static Widget buttonWidget({
    Color backgroundColor,
    String text,
    Color textColor,
    String fontName,
    int fontsize,
    double height,
    double width,
    VoidCallback onPressed,
    double characterSpacing,
    double elevation = 0
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? UIUtills().getProportionalHeight(58),
      child: RaisedButton(
        elevation: elevation,
        color: backgroundColor ?? AppColor.whiteColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: UIUtills().getTextStyleRegular(
            color: textColor ?? AppColor.whiteColor,
            fontName: fontName ?? AppFont.sfCompactRegular,
            fontSize: fontsize ?? 16,
            characterSpacing: characterSpacing ?? 1.6
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

//endregion

//Custom Gradient With Circuler Radius Button
  static Widget gradientWithCirculerRadiusButtonWidget({
    String text,
    Color textColor,
    String fontName,
    int fontsize,
    double height,
    double width,
    VoidCallback onPressed,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? UIUtills().getProportionalHeight(58),
      child: RaisedButton(
        onPressed: onPressed,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1, 1),
              end: Alignment(2, -4),
              colors: <Color>[
                Color(0xFF43b87f),
                Color(0xFF1fb8cc),
              ],
            ),
//            LinearGradient(
//              begin: Alignment(-4.0, 1.0),
//              end: Alignment(1.0, 012.0),
//              colors: <Color>[
//                Color(0xFF8BC43F),
//                Color(0xFF6BC43F),
//                Color(0xFF42A5F5),
//              ],
//            ),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: UIUtills().getTextStyleRegular(
                color: textColor ?? AppColor.whiteColor,
                fontName: fontName ?? AppFont.sfCompactRegular,
                fontSize: fontsize ?? 16,
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(0.0),
      ),
    );
  }

  //endregion

  //Custom Flat Gradient Button
  static Widget gradientButtonWidget({
    double radius = 0,
    String text,
    Color textColor,
    String fontName,
    int fontsize,
    double height,
    double width,
    VoidCallback onPressed,
    LinearGradient gradient ,
  }) {

    if(gradient==null){
      gradient = LinearGradient(
        begin: Alignment(-1, 1),
        end: Alignment(2, -4),
        colors: <Color>[
          Color(0xFF43b87f),
          Color(0xFF1fb8cc),
        ],
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? UIUtills().getProportionalHeight(58),
        child: RaisedButton(
          onPressed: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                style: UIUtills().getTextStyleRegular(
                  color: textColor ?? AppColor.whiteColor,
                  fontName: fontName ?? AppFont.sfCompactRegular,
                  fontSize: fontsize ?? 16,
                ),
              ),
            ),
          ),
          padding: EdgeInsets.all(0.0),
        ),
      ),
    );
  }

  //endregion

//  static Widget createTextField(
//      {TextFieldType textType = TextFieldType.none,
//        Key key,
//        TextInputType keyboardType,
//        TextInputAction action = TextInputAction.next,
//        VoidCallback onEditCompletie,
//        ValueChanged<String> onChanged,
//        FocusNode focusNode,
//        TextEditingController controller,
//        Color textColor,
//        Color cursorColor,
//        TextStyle style,
//        InputDecoration decoration,
//        String hintText,
//        IconData prefixIcon,
//        Widget suffixIcon,
//        EdgeInsetsGeometry contentPadding,
//        bool enabled,
//        GestureTapCallback gestureTapCallback,
//        TextCapitalization textCapitalization = TextCapitalization.none,
//        bool obscureText = false,
//        int maxLength,
//        int maxLines = 1}) {
//    var textStyle = style;
//    if (textStyle == null) {
//      textStyle = UIUtills().getTextStyle(
//          color: AppColor.textColor,
////          fontName: AppFontName.appFontRegular,
//          fontsize: 14);
//    }
//
//    var inputDecoration = decoration;
//    if (inputDecoration == null) {
//      inputDecoration = InputDecoration(
//        hintText: hintText,
//        contentPadding: contentPadding ??
//            EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
//        focusedBorder: InputBorder.none,
//        enabledBorder: InputBorder.none,
//        hintStyle: TextStyle(
//            color: AppColor.textColor,
////            fontFamily: AppFontName.appFontRegular,
//            fontSize: 15.0),
//        prefixIcon: Container(
//            margin: EdgeInsets.only(right: 10),
//            child: Icon(
//              prefixIcon, color: AppColor.iconColorTextField, size: 20,)),
//        suffixIcon: suffixIcon,
//      );
//    }
//  }

  static String getMonthInString(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "Jan";
    }
  }


//Rounded Box With Shadow
  static BoxDecoration createRoundedBoxWithShadow({double radius}) {
    // yet this due to  1 Px shadow
    //https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/shadows.dart

    BoxShadow shadow1 = BoxShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 1.0,
        spreadRadius: -1.0,
        color: Color(0x33000000));
    BoxShadow shadow2 = BoxShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 1.0,
        spreadRadius: 0.0,
        color: Color(0x24000000));
    BoxShadow shadow3 = BoxShadow(
        offset: Offset(0.0, 1.0),
        blurRadius: 3.0,
        spreadRadius: 0.0,
        color: Color(0x1F000000));

    BorderRadius boxborderRadius = BorderRadius.all(Radius.circular(radius));

    BoxDecoration boxDecooration = BoxDecoration(
        boxShadow: [shadow1, shadow2, shadow3],
        color: AppColor.whiteColor,
        borderRadius: boxborderRadius);

    return boxDecooration;
  }
//endregion
}
