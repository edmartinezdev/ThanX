import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_font.dart';
import '../utils/app_image.dart';
import '../utils/ui_utils.dart';

class RouteDetailsView extends StatelessWidget {
  List<String> addresses ;
  List<String> name;
  RouteDetailsView({this.addresses,this.name});
  
  Widget getIconsColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(AppImage.circle,height: UIUtills().getProportionalWidth(16),width: UIUtills().getProportionalWidth(16),fit: BoxFit.fill,),
        Container(
          margin: EdgeInsets.symmetric(vertical: UIUtills().getProportionalHeight(4)),
          width: 1,
          height: UIUtills().getProportionalWidth(36),
          color: AppColor.textColorLight,
        ),
        Image.asset(AppImage.circle,height: UIUtills().getProportionalWidth(16),width: UIUtills().getProportionalWidth(16),fit: BoxFit.fill,),
      ],
    );
  }

  Widget getAddressNameColumn(int i){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(addresses[i],maxLines: 1,style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfProTextMedium,color: AppColor.textColor,characterSpacing: 0.36),),
        SizedBox(height: UIUtills().getProportionalHeight(11),),
        Text(name[i],style: UIUtills().getTextStyleRegular(fontSize: 14,fontName: AppFont.sfProTextMedium,color: AppColor.textColorLight,characterSpacing: 0.36),),
      ],
    );
  }

 Widget getMainAddressColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getAddressNameColumn(0),
        SizedBox(height: UIUtills().getProportionalHeight(16),),
        getAddressNameColumn(1),
      ],
    );
 }
  

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getIconsColumn(),
        SizedBox(width: UIUtills().getProportionalWidth(14),),
        getMainAddressColumn()
      ],
    );
  }
}
