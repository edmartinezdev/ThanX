import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

typedef void IntButtonChangeCallBack(int i);

class OrderStatusButtonsTile extends StatefulWidget {

  int noOfButtons;
  int currentState;
  IntButtonChangeCallBack statusChangeCallback;
  List<String> images ;
  bool isButtonClickable;
  OrderStatusButtonsTile({this.noOfButtons, this.images,this.currentState,this.statusChangeCallback,this.isButtonClickable = true});

  @override
  _OrderStatusButtonsTileState createState() => _OrderStatusButtonsTileState();
}

class _OrderStatusButtonsTileState extends State<OrderStatusButtonsTile> {

  getStatusButtons(int index) => GestureDetector(
    onTap: (){
      if(this.widget.isButtonClickable){
        this.widget.currentState =index;
        this.widget.statusChangeCallback(index);
        setState(() {});
      }
    },
    child: Container(
      height: UIUtills().getProportionalWidth(34),
      width: UIUtills().getProportionalWidth(34),
      decoration: BoxDecoration(
        color: (index == this.widget.currentState)? AppColor.primaryColor:AppColor.statusButtonUnSelectedColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: Image.asset( this.widget.images[index-1],width: UIUtills().getProportionalWidth(17),height: UIUtills().getProportionalWidth(17))),
    ),
  );

  getStatusDivider()=>Container(
    margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(5)),
    height: UIUtills().getProportionalWidth(3),
    width: UIUtills().getProportionalWidth(27),
    color: AppColor.dividerBackgroundColor,
  );


  @override
  Widget build(BuildContext context) {

    List<Widget> mainRow = List<Widget>();

    for(int i = 1 ; i<=this.widget.noOfButtons ; i++){
      mainRow.add(getStatusButtons(i));
      if(i < this.widget.noOfButtons)mainRow.add(getStatusDivider());
    }

    return Container(
        height: UIUtills().getProportionalWidth(34),
        margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(12),left: UIUtills().getProportionalWidth(28),right:UIUtills().getProportionalWidth(28)),
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mainRow
        ));
  }

}
