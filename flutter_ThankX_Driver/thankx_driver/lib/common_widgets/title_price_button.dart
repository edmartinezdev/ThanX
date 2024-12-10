import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
class TitlePriceButton extends StatelessWidget {
  String title, price;
  VoidCallback onClick;
  Color backgroundColor;
  TextStyle style;
  TitlePriceButton({this.price,this.title,this.onClick,this.backgroundColor,this.style});

  @override
  Widget build(BuildContext context) {
    if(style==null){
       style = UIUtills().getTextStyleRegular(fontSize: 17,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.4);
    }

    return GestureDetector(
      onTap: (){
        this.onClick();
      },
      child: Container(
        decoration: BoxDecoration(
          color: (this.backgroundColor!=null)?backgroundColor:AppColor.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(16)),
        width: double.infinity,
        height: UIUtills().getProportionalHeight(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(title,style: style,),
            Text("\$"+price,style:  UIUtills().getTextStyleRegular(fontSize: 17,fontName: AppFont.sfProTextSemibold,color: AppColor.textColor,characterSpacing: 0.4),),
          ],
        ),
      ),
    );
  }
}
