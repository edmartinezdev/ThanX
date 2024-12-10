import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import 'order_status_buttons_tile.dart';

class TitleSwitch extends StatefulWidget {
  String title1,title2,image1,image2;
  TextStyle titleTextStyle;
  IntButtonChangeCallBack callback;

  TitleSwitch({this.title1,this.title2,this.image1,this.image2,this.titleTextStyle,this.callback});

  @override
  _TitleSwitchState createState() => _TitleSwitchState();
}

class _TitleSwitchState extends State<TitleSwitch> {

 bool isFirstSelected = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(this.widget.title1,style: this.widget.titleTextStyle,),
        SizedBox(width: UIUtills().getProportionalWidth(15),),
        GestureDetector(
            onTap: (){
              isFirstSelected = !isFirstSelected;
              this.widget.callback(isFirstSelected?1:2);
              setState(() {});
            },
            child: Image.asset((isFirstSelected)?this.widget.image1:this.widget.image2,width: UIUtills().getProportionalWidth(45),height: UIUtills().getProportionalWidth(25),)),
        SizedBox(width: UIUtills().getProportionalWidth(15),),
        Text(this.widget.title2,style: this.widget.titleTextStyle,),
      ],
    );
  }
}
