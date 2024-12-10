import 'dart:core';

import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/order_status_buttons_tile.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class SelectDeliveryType extends StatefulWidget {
  List<String> title;
  List<String> price;
  List<String> desc;
  IntButtonChangeCallBack callback;

 SelectDeliveryType({this.title,this.price, this.desc, this.callback});

  @override
  _SelectDeliveryTypeState createState() => _SelectDeliveryTypeState();
}

class _SelectDeliveryTypeState extends State<SelectDeliveryType> {

  int selected = 0;

  Widget getDeliveryTypeContainer(int i){

    BorderRadius radius;
    if(i==0)radius = BorderRadius.only(topRight: Radius.circular(21),topLeft:Radius.circular(21));
    if(i== this.widget.title.length-1) radius = BorderRadius.only(bottomRight: Radius.circular(21),bottomLeft:Radius.circular(21));
    if(radius==null) radius = BorderRadius.all(Radius.circular(0));

    return GestureDetector(
      onTap: (){
        selected = i+1;
        this.widget.callback(selected);
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(6)),
        height: UIUtills().getProportionalHeight(90),
        width: double.infinity,
        decoration: BoxDecoration(
          color: (selected- 1== i)?AppColor.textColor : AppColor.textFieldBackgroundColor,
          borderRadius: radius
        ),
        padding: EdgeInsets.only(left: UIUtills().getProportionalWidth(21),right: UIUtills().getProportionalWidth(25)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset((i==selected-1)?AppImage.awaitingReceiver:AppImage.drop,height: UIUtills().getProportionalWidth(20),width: UIUtills().getProportionalWidth(20),),

             SizedBox(width: UIUtills().getProportionalWidth(21),),

            Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    width: UIUtills().getProportionalWidth(245),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                       Text(this.widget.title[i],style: UIUtills().getTextStyleRegular(
                           fontSize: 15,
                           fontName: AppFont.sfProDisplayBold,
                           color: (i==selected-1) ?AppColor.whiteColor : AppColor.textColor,
                            characterSpacing: 0.36
                       ),),
                        Text("\$"+this.widget.price[i],style: UIUtills().getTextStyleRegular(
                            fontSize: 15,
                            fontName: AppFont.sfProTextMedium,
                            color: (i==selected-1) ?AppColor.whiteColor : AppColor.textColor,
                            characterSpacing: 0.36
                        ),)
                      ],
                    ),
                  ),

                  SizedBox(height: UIUtills().getProportionalHeight(13),),

                  Text(this.widget.desc[i],style: UIUtills().getTextStyleRegular(
                      fontSize: 10,
                      fontName: AppFont.sfProTextMedium,
                      color: (i==selected-1) ?AppColor.whiteColor : AppColor.textColor,
                      characterSpacing: 0.2
                  ),)
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          getDeliveryTypeContainer(0),
          getDeliveryTypeContainer(1),
          getDeliveryTypeContainer(2)
        ],
      ),
    );
  }
}
