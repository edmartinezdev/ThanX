import 'package:flutter/material.dart';

import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

//enum ButtonType {
//  back,
//  close,
//  menu,
//  notification,
//  notificationUnread,
//  clear,
//  save
//}

//typedef ButtonTapCallback = void Function(ButtonType type);

class CommonWidget {


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

}
