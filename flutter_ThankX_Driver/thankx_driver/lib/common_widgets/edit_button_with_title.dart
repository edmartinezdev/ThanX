import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class EditButtonWithTitle extends StatelessWidget {
  String title;
  VoidCallback callback;
  EditButtonWithTitle({this.title,this.callback});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfCompactSemiBold,color: AppColor.textColor,characterSpacing: 0.3),),
        Container(
          height: UIUtills().getProportionalHeight(20),
          width: UIUtills().getProportionalWidth(45),
          decoration: BoxDecoration(
              color: Colors.transparent,
            border: Border.all(width: 1,color: AppColor.textColor),
            borderRadius: BorderRadius.all(Radius.circular(11))
          ),
          child: InkWell(
              onTap: (){
                this.callback();
              },
              child: Center(child: Text("Edit",style: UIUtills().getTextStyleRegular(fontSize: 10,fontName: AppFont.sfProTextMedium,color: AppColor.textColor ),))),
        )
      ],
    );
  }
}
