import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

typedef VoidCallbackInt(int i);
class TopBottomRadiusButton extends StatefulWidget {

  List<String> buttons;
  VoidCallbackInt buttonChangeNotifier;
  TopBottomRadiusButton({this.buttons,this.buttonChangeNotifier});

  @override
  _TopBottomRadiusButotnState createState() => _TopBottomRadiusButotnState();
}

class _TopBottomRadiusButotnState extends State<TopBottomRadiusButton> {

  /// 0=notselected 1= firstSelected 2=secondSelected
  int selected = 0;

  onButtonChange(int i){
    selected = i;
    this.widget.buttonChangeNotifier(i);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            onButtonChange(1);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(54)),
            height: UIUtills().getProportionalWidth(50),
            width: double.infinity,
            decoration: BoxDecoration(
                color : (selected==1)?AppColor.textColor:AppColor.unSelectedButtonColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
            ),
            child: Center(child: Text(this.widget.buttons[0],style: UIUtills().getTextStyleRegular(fontSize: 15,color: (selected==1)?AppColor.whiteColor:AppColor.textColor,fontName: AppFont.sfProDisplayMedium,characterSpacing: 0.4),)),
          ),
        ),
        SizedBox(height: UIUtills().getProportionalWidth(6),),
        GestureDetector(
          onTap: (){
            onButtonChange(2);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(54)),
            height: UIUtills().getProportionalWidth(50),
            width: double.infinity,
            decoration: BoxDecoration(
                color : (selected==2)?AppColor.textColor:AppColor.unSelectedButtonColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Center(child: Text(this.widget.buttons[1],style: UIUtills().getTextStyleRegular(fontSize: 15,color: (selected==2)?AppColor.whiteColor:AppColor.textColor,fontName: AppFont.sfProDisplayMedium,characterSpacing: 0.4),)),
          ),
        )
      ],
    );
  }
}
