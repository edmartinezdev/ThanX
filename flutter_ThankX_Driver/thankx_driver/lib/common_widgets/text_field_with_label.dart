import 'package:flutter/material.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class TextFieldWithLabel extends StatelessWidget {

  TextFieldType textType ;
  Key key ;
  TextInputType keyboardType;
  TextInputAction action ;
  VoidCallback onEditCompletie;
  ValueChanged<String> onChanged;
  FocusNode focusNode;
  TextEditingController controller;
  Color cursorColor;
  TextStyle style;
  String hintText;
  String labelText;
  Widget prefixIcon;
  EdgeInsets prefixPadding ;
  Color prefixIconColor ;
  Widget suffixIcon;
  EdgeInsetsGeometry contentPadding;
  BorderRadius borderRadius;
  bool enabled;
  GestureTapCallback gestureTapCallback;
  TextCapitalization textCapitalization ;
  bool obscureText ;
  int maxLength;
  int maxLines ;
  TextAlign align = TextAlign.left;
  TextStyle labelTextStyle ;
  Color backgroundColor;
  TextFieldWithLabel({
    this.textType = TextFieldType.none,
    this.key,
    this.keyboardType,
    this.action = TextInputAction.next,
    this.onEditCompletie,
    this.onChanged,
    this.focusNode,
    this.controller,
    this.cursorColor,
    this.style,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefixPadding = const EdgeInsets.only(right: 10),
    this.prefixIconColor = const Color(0xFFD8D8D8),
    this.suffixIcon,
    this.contentPadding,
    this.borderRadius,
    this.enabled,
    this.gestureTapCallback,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.align = TextAlign.left,
    this.labelTextStyle,
    this.backgroundColor
});

  @override
  Widget build(BuildContext context) {

    var textStyle = style;
    if (textStyle == null) {
      print("hint textStyle changes");
      textStyle = UIUtills().getTextStyle(
          color: AppColor.textColor,
//          fontName: AppFontName.appFontRegular,
          fontsize: 14);
    }

    if (labelTextStyle == null) {}

    var inputDecoration = InputDecoration(
        hintText: this.hintText,
        hintStyle: this.labelTextStyle,
        labelText: labelText,
        contentPadding: contentPadding ?? EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder:InputBorder.none,
        labelStyle: labelTextStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      );


    return Container(
//      height: UIUtills().getProportionalWidth(50),
      decoration: BoxDecoration(
        color: (backgroundColor!=null)?backgroundColor:AppColor.textFieldBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(10))
      ),
      child: AITextFormField(
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
      ),
    );
  }
}
