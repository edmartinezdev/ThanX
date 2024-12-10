import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
typedef OnItemSelected(String value);
class DropDownMenuButton extends StatefulWidget {
  String hint;
  List<String> items;
  OnItemSelected onItemSelected;


  DropDownMenuButton({this.items,this.hint,this.onItemSelected});

  @override
  _DropDownMenuButtonState createState() => _DropDownMenuButtonState();
}

class _DropDownMenuButtonState extends State<DropDownMenuButton> {
  String selected;
  @override
  Widget build(BuildContext context) {

    return  DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(this.widget.hint,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextMedium,color: AppColor.textColorLight,fontSize: 15,characterSpacing: 0.36),),
          value: selected,
          isExpanded: true,
          onChanged: this._onDropDownValueChange,
          icon: Image.asset(AppImage.downArrow),
          items: this.widget.items.map<DropdownMenuItem<String>>((String value) {

            final dropDownText = Align(child: Text(
              value, style: UIUtills().getTextStyleRegular(fontSize: 12,fontName: AppFont.sfProTextMedium,characterSpacing: 0.25,color: AppColor.textColorMedium),),
              alignment: Alignment.centerLeft,);

            final dropDownMenuItem = DropdownMenuItem<String>(
              value: value, child: dropDownText,);

            return dropDownMenuItem;

          }).toList(),
        ),
    );
  }

  void _onDropDownValueChange(String value) {
    selected = value;
    this.widget.onItemSelected(value);
    setState(() {});
  }

}
