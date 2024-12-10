import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/bank_list_bloc.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/bank_list_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

typedef  void IntButtonChangeCallBack(int i);

class AddedBankListAdapter extends StatefulWidget {
  BankListBloc bloc;
  VoidCallback callback;
  IntButtonChangeCallBack selectedBankCallback;
  var scaffoldKey;
  AddedBankListAdapter({this.bloc, this.callback,this.scaffoldKey, this.selectedBankCallback});

  @override
  _AddedBankListAdapterState createState() => _AddedBankListAdapterState();
}

class _AddedBankListAdapterState extends State<AddedBankListAdapter> {
  int selected;
  bool isNotlast;
  StreamSubscription<BaseResponse> subscription;

  initState(){
    super.initState();
    selected = this.widget.bloc.currentCardIndex;
  }
  List<Widget> cardsColumn = List();

  @override
  Widget build(BuildContext context) {
    cardsColumn.clear();

    for(int i= 0 ;i<this.widget.bloc.aryOfBankList.length;i++){
      cardsColumn.add(getCardAdapter(i));
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      color: AppColor.whiteColor,
      child: ListView.builder(
        itemCount: this.widget.bloc.bankCount,
        padding: EdgeInsets.only(top: UIUtills().getProportionalHeight(20)),
        itemBuilder: (BuildContext ctxt, int index) {
          isNotlast = (index != this.widget.bloc.bankCount - 1);
          if (index == 0) {
            return Container(
              child: Column(
                children: <Widget>[
                  InkWell(
                      onTap: () {
//                          onCardClick(!isNotlast);
                      },
                      child:
                          isNotlast ? addedCardColumn(index) : addCardColumn()),
                ],
              ),
            );
          } else {
            return Container(
              child: InkWell(
                  onTap: () {
//                      onCardClick(!isNotlast);
                  },
                  child: isNotlast ? addedCardColumn(index) : addCardColumn()),
            );
          }
        },
      ),
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
          child: GestureDetector(
            onTap: () {
              this.widget.callback();
            },
            child: addPaymentMethod(),
          ),
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
                  AppTranslations.globalTranslations.addBankDetailsText,
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

  Widget addedCardColumn(int index) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(12),
            left: UIUtills().getProportionalWidth(24),
            right: UIUtills().getProportionalWidth(24),
            bottom: UIUtills().getProportionalHeight(12),
          ),
          child: addedCard(index),
        ),
      ],
    );
  }

  Widget addedCard(int index) {
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
                    margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(10)),
                    child: getCardAdapter(index)
                  ),
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
//                      "● ● ● ●3456",
                      "● ● ● ●" + this.widget.bloc.aryOfBankList[index].last4,
                      style: UIUtills().getTextStyle(
                          color: AppColor.textColor,
                          fontName: AppFont.sfProTextMedium,
                          fontsize: 15,
                          characterSpacing: 0.36),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  _deleteBankOperation(index);
                  },
                child: Container(
                  margin:
                      EdgeInsets.only(top: UIUtills().getProportionalHeight(8)),
                  child: Icon(
                    Icons.delete,
                    color: AppColor.textColor,
                    size: 19,
                  ),
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

  getCardAdapter(int index) {
    return GestureDetector(
      onTap: () {
        selected = index;
        this.widget.selectedBankCallback(selected);
        setState(() {});
      },
      child: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                (selected == index) ? AppImage.awaitingReceiver : AppImage.drop,
                color: (selected == index) ? null : AppColor.dividerBackgroundColor,
                height: UIUtills().getProportionalWidth(20),
                width: UIUtills().getProportionalWidth(20),
              ),
            ],
          ),
        ],
      )),
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

  _deleteBankOperation(int index) {
    BankListModel bankModel = this.widget.bloc.aryOfBankList[index];
    this.subscription =
         this.widget.bloc.deleteBankStream.listen((BaseResponse response) {
          this.subscription.cancel();

          Future.delayed(
              Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
                  () {
                UIUtills().dismissProgressDialog(context);

                if (response.status) {

                  this.widget.bloc.aryOfBankList.removeAt(index);
                  if (mounted) {
                    setState(() {});
                  }
                }
                Utils.showSnakBarwithKey(this.widget.scaffoldKey, response.message);
              });
        });
    this.widget.bloc.apiCallDeleteBankDetails(bankModel.id);
    UIUtills().showProgressDialog(context);
  }
}
