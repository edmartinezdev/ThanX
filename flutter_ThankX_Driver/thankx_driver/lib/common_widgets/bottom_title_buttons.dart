import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import 'order_status_buttons_tile.dart';

class BottomTitleButton extends StatefulWidget {
  int noOfButtons;
  List<String> titles;
  List<String> images ;
  IntButtonChangeCallBack onChange;
  BottomTitleButton({ this.noOfButtons,this.titles,this.images ,this.onChange});

  @override
  _BottomTitleButtomState createState() => _BottomTitleButtomState();
}

class _BottomTitleButtomState extends State<BottomTitleButton> {

  int selected =0 ;

  Widget getImageTitleColumn(int i){
    return GestureDetector(
      onTap: (){
        this.selected = i+1;
        setState(() {});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: UIUtills().getProportionalWidth(40),
            width: UIUtills().getProportionalWidth(40),
            decoration: BoxDecoration(
              color:(i == selected-1)?AppColor.primaryColor: AppColor.textFieldBackgroundColor,
              shape: BoxShape.circle
            ),
            child:Center(child: Image.asset(this.widget.images[i]))
            ,),
          SizedBox(height: UIUtills().getProportionalHeight(9),),
          Text(this.widget.titles[i],style: UIUtills().getTextStyleRegular(color: AppColor.textColor,fontSize: 10,fontName: AppFont.sfProTextMedium,characterSpacing: 0.2),)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> rowWidgets = List();
    
    for(int i = 0 ;i<this.widget.noOfButtons ; i++){
      rowWidgets.add(
        Container(
          margin: EdgeInsets.only(right: (i < this.widget.noOfButtons-1)?UIUtills().getProportionalWidth(35):0),
          child: getImageTitleColumn(i),
        )
      );
    }
    
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowWidgets,
    );
  }
}
