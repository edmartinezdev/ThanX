import 'package:flutter/material.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import 'add_card.dart';

class PaymentMethodPage extends StatefulWidget {
//  bool isFromCart;
//  PaymentMethodPage(this.isFromCart);
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int count = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.paymentMethodTitle,
          style: UIUtills().getTextStyle(
            characterSpacing: 0.4,
            color: AppColor.appBartextColor,
            fontsize: 17,
            fontName: AppFont.sfProTextSemibold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColor.whiteColor,
        child: ListView.builder(
          itemCount: count,
          padding: EdgeInsets.only(top: UIUtills().getProportionalHeight(20)),
          itemBuilder: (BuildContext ctxt, int index) {
            bool isNotlast = (index != count - 1);
            if (index == 0) {
              return Container(
                child: Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          onCardClick(!isNotlast);
                        },
                        child: isNotlast ? addedCardColumn() : addCardColumn()),
                  ],
                ),
              );
            } else {
              return Container(

                child: InkWell(
                    onTap: () {
                      onCardClick(!isNotlast);
                    },
                    child: isNotlast ? addedCardColumn() : addCardColumn()),
              );
            }
          },
        ),
      ),
    );
  }



  Widget addedCardColumn() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(12),
            left: UIUtills().getProportionalWidth(24),
            right: UIUtills().getProportionalWidth(24),
            bottom: UIUtills().getProportionalHeight(12),
          ),
          child: addedCard(),
        ),
      ],
    );
  }

  Widget addCardColumn() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: UIUtills().getProportionalWidth(24),
            right: UIUtills().getProportionalWidth(24),

          ),
          child: GestureDetector(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddCardPage();
            },),);
          },child: addPaymentMethod(),),
        ),
      ],
    );
  }

  Widget addPaymentMethod() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(48)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: UIUtills().getProportionalWidth(30),
                width: UIUtills().getProportionalWidth(30),
                decoration: BoxDecoration(
                    color: AppColor.boarderInCardColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Image.asset(AppImage.plusPayment),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: UIUtills().getProportionalWidth(16)),
                child: Text(
                  AppTranslations.globalTranslations.addPaymentMethodText,
                  style: UIUtills().getTextStyle(
                    color: AppColor.textColor,
                    fontName: AppFont.sfProTextMedium,
                    fontsize: 14,
                  ),
                ),
              )
            ],
          ),
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(12)),
            child: Image.asset(
              AppImage.rightArrow,
            ),
          )
        ],
      ),
    );
  }

  Widget addedCard() {
    return Container(
      color: AppColor.whiteColor,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: UIUtills().getProportionalWidth(30),
                    width: UIUtills().getProportionalWidth(30),
                    decoration: BoxDecoration(
                        color: AppColor.boarderInCardColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Image.asset(AppImage.paymentIcon),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: UIUtills().getProportionalWidth(16)),
                    child: Text(
                      "● ● ● ●3456",
                      style: UIUtills().getTextStyle(
                          color: AppColor.textColor,
                          fontName: AppFont.sfProTextMedium,
                          fontsize: 15,
                          characterSpacing: 0.36),
                    ),
                  )
                ],
              ),
              Container(
                margin:
                    EdgeInsets.only(top: UIUtills().getProportionalHeight(8)),
                child: Icon(
                  Icons.more_vert,
                  color: AppColor.textColor,
                  size: 19,
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: UIUtills().getProportionalHeight(15),
                ),
            height: 1,
            width: double.infinity,
            color: AppColor.paymentMethodDividerColor,
          ),
        ],
      ),
    );
  }

  void onCardClick(bool isAddNewCard) {
//    if(this.widget.isFromCart){
//      if(isAddNewCard){
////        MaterialPageRoute route = MaterialPageRoute(builder:(_)=> SelectCardType(isFromCart: true,));
////        NavigationService().navigateTo(route);
//      }else{
////        NavigationService().navigateNamedTo("/OrderConfirmationPage");
//      }
//    }else{
//      if(isAddNewCard){
////        MaterialPageRoute route = MaterialPageRoute(builder:(_)=> SelectCardType(isFromCart: false,));
////        NavigationService().navigateTo(route);
//      }
//    }
  }
}
