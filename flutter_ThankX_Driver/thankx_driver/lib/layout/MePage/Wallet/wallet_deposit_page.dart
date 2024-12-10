import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/bank_list_bloc.dart';
import 'package:thankxdriver/bloc/payment_history_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Wallet/add_bank_details.dart';
import 'package:thankxdriver/layout/MePage/Wallet/added_bank_list_adapter.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class WalletDepositPage extends StatefulWidget {
  PaymentHistoryBloc bloc;

  WalletDepositPage({this.bloc});

  @override
  _WalletDepositPageState createState() => _WalletDepositPageState();
}

class _WalletDepositPageState extends State<WalletDepositPage> with AfterLayoutMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<WithdrawAmountResponse> _withdrawAmountSubscription;
  StreamSubscription<CheckStripeAccountResponse> _checkStripeAccountSubscription;

  BankListBloc bankListBloc = BankListBloc();
  StreamSubscription<BankListResponse> _bankListSubscription;

  @override
  void dispose() {
    if (_withdrawAmountSubscription != null) _withdrawAmountSubscription.cancel();
    if (_checkStripeAccountSubscription != null) _checkStripeAccountSubscription.cancel();
    if (_bankListSubscription != null) _bankListSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      AppTranslations.globalTranslations.strCancel.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: UIUtills().getTextStyle(fontsize: 11, characterSpacing: 0.26, fontName: AppFont.sfProTextSemibold),
                    ),
                  ),
                ),
                Text(
                  AppTranslations.globalTranslations.walletTitle,
                  style: UIUtills().getTextStyle(
                    characterSpacing: 0.4,
                    color: AppColor.appBartextColor,
                    fontsize: 17,
                    fontName: AppFont.sfProTextSemibold,
                  ),
                ),
                Container(
                  width: UIUtills().getProportionalWidth(65),
                )
              ],
            ),
          ),
          centerTitle: false,
          backgroundColor: AppColor.whiteColor,
          elevation: 0.5,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              amountContainer(),
              mainContainer(),
            ],
          ),
        ));
  }

  Widget amountContainer() {
    return Card(
      color: AppColor.whiteColor,
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.only(
          top: UIUtills().getProportionalHeight(34), left: UIUtills().getProportionalWidth(16), right: UIUtills().getProportionalWidth(16), bottom: UIUtills().getProportionalHeight(20)),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(60), bottom: UIUtills().getProportionalHeight(50)),
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "\$",
                  style: UIUtills().getTextStyle(fontsize: 51, fontName: AppFont.sfProDisplayLight, color: AppColor.textColor, characterSpacing: 0.0),
                ),
                Text(
                  "${this.widget.bloc.model.totalAmount.toStringAsFixed(2)}",
//                      "20.00",
                  style: UIUtills().getTextStyle(fontsize: 51, fontName: AppFont.sfProDisplayBold, color: AppColor.textColor, characterSpacing: 0.0),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: UIUtills().getProportionalHeight(320),
            child: AddedBankListAdapter(
              scaffoldKey: this._scaffoldKey,
              bloc: this.bankListBloc,
              selectedBankCallback: (i) {
                this.bankListBloc.currentCardIndex = i;
                this.bankListBloc.request.bankAccountId = this.bankListBloc.aryOfBankList[i].id;
                setState(() {});
              },
              callback: () {
                var route = MaterialPageRoute(builder: (_) => AddBankDetails(bloc: this.widget.bloc,isComeFromDepositAccountPage: false));
                NavigationService().push(route);
              },
            ),
          ),
          buttonContainer()
        ],
      ),
    );
  }

  Widget buttonContainer() {
    if (this.bankListBloc.aryOfBankList.length > 0) {
      return Container(
          margin: EdgeInsets.only(
            bottom: UIUtills().getProportionalHeight(24),
            left: UIUtills().getProportionalWidth(28),
            right: UIUtills().getProportionalWidth(28),
          ),
          child: CommonButton(
            height: UIUtills().getProportionalWidth(40),
            width: double.infinity,
            backgroundColor: AppColor.primaryColor,
            onPressed: () {
              var index = this.bankListBloc.currentCardIndex;
              checkStripeAccountApi();
//                  print("=======================${this.widget.bloc.withdrawAmountModel.isBankAdded.toString()?? ""}");
//                    Navigator.of(context).pop();
            },
            textColor: AppColor.textColor,
            fontName: AppFont.sfProTextMedium,
            fontsize: 17,
            characterSpacing: 0,
            text: AppTranslations.globalTranslations.buttonDeposit + " \$" + this.widget.bloc.model.totalAmount.toStringAsFixed(2),
          ));
    } else {
      return Container();
    }
  }

  Widget accountDetails() {
//    if(this.widget.bloc.model.accountNumber != null){
//      return Container();
//    }
//    else{
//      String accountNumber = this.widget.bloc.model.accountNumber;
//      String lastFourDigits = accountNumber.substring(accountNumber.length - 4);

//      return  Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(
//                left: UIUtills().getProportionalWidth(16),
//                top: UIUtills().getProportionalHeight(151)),
//            child: Text(
//              "Transfer to",
//              style: UIUtills().getTextStyle(
//                  fontName: AppFont.sfProTextSemibold,
//                  fontsize: 14,
//                  color: AppColor.textColor),
//            ),
//          ),
//          Container(
//            margin: EdgeInsets.only(
//                top: UIUtills().getProportionalHeight(34),
//                left: UIUtills().getProportionalWidth(24),
//                right: UIUtills().getProportionalWidth(24)),
//            child: Row(
////                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Row(
//                  children: <Widget>[
//                    Container(
//                      height: UIUtills().getProportionalWidth(30),
//                      width: UIUtills().getProportionalWidth(30),
//                      decoration: BoxDecoration(
//                          color: AppColor.dialogDividerColor,
//                          borderRadius: BorderRadius.circular(5)),
//                      child: Image.asset(
//                        AppImage.paymentIcon,
//                      ),
//                    ),
//                    SizedBox(
//                      width: UIUtills().getProportionalWidth(16),
//                    ),
//                    Container(
//                      height: 50,
//                      color: Colors.red,
//                      child:lastFourDigits
//                      Text(
//                        "● ● ● ● " + "${lastFourDigits}",
//                        style: UIUtills().getTextStyle(
//                            color: AppColor.textColor,
//                            fontName: AppFont.sfProDisplayMedium,
//                            fontsize: 15,
//                            characterSpacing: 0.36),
//                      ),
//                    ),
//                  ],
//                ),
////                    GestureDetector(
////                      onTap: () {
////                        Navigator.push(context,
////                            MaterialPageRoute(builder: (context) {
////                          return AddBankDetails();
////                        }));
////                      },
////                      child: Container(
////                        color: Colors.transparent,
////                        child: Text(
////                          "Change",
////                          style: UIUtills().getTextStyle(
////                            color: AppColor.textColor,
////                            fontName: AppFont.sfCompactRegular,
////                            fontsize: 10,
////                          ),
////                        ),
////                      ),
////                    )
//              ],
//            ),
//          ),
//        ],
//      );
//  }
  }

  void withDrawAmountApi() {
    _withdrawAmountSubscription = this.widget.bloc.withdrawAmountOptionSubject.listen(
      (WithdrawAmountResponse response) {
        _withdrawAmountSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            UIUtills().dismissProgressDialog(context);
            if (!response.status) {
            } else {
              NavigationService().pop();
            }
            Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            setState(() {});
          },
        );
      },
    );
    this.widget.bloc.callWithdrawAmountApi(amount: this.widget.bloc?.model?.totalAmount ?? 0, id: this.bankListBloc.aryOfBankList[this.bankListBloc.currentCardIndex].id);
    UIUtills().showProgressDialog(context);
  }

  void checkStripeAccountApi() {
    _checkStripeAccountSubscription = this.widget.bloc.checkStripeAccountOptionSubject.listen(
      (CheckStripeAccountResponse response) {
        _checkStripeAccountSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            UIUtills().dismissProgressDialog(context);

            if (!response.status) {
              if (response.data != null) {
                Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              } else {
                Utils.showSnakBarwithKey(_scaffoldKey, response.message);
//                  var route = MaterialPageRoute(builder: (_) => AddBankDetails(bloc: this.widget.bloc,));
//                  NavigationService().push(route);
              }
            } else {
              if (this.widget?.bloc?.checkStripeAccountModel?.status == "verified") {
                this.withDrawAmountApi();
              } else if (this.widget?.bloc?.checkStripeAccountModel?.status == "unverified") {
                Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              } else {
                Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              }
            }

            setState(() {});
          },
        );
      },
    );
    this.widget.bloc.callStripeAccountApi();
    UIUtills().showProgressDialog(context);
  }

  void bankListApi({bool isFirst = true}) {
    // Validate Form
    this._bankListSubscription = this.bankListBloc.bankListOptionStream.listen((BankListResponse response) {
      this._bankListSubscription.cancel();

      if (isFirst) UIUtills().dismissProgressDialog(context);

      if (response.status) {
        setState(() {});
      } else {
        Utils.showSnakBarwithKey(_scaffoldKey, response.message);
      }
    });
    // flutter defined function
    if (isFirst) UIUtills().showProgressDialog(context);
    this.bankListBloc.apiCallBankList();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    bankListApi();
  }
}
