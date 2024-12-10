import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/bank_list_bloc.dart';
import 'package:thankxdriver/bloc/payment_history_bloc.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Wallet/add_bank_details.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class DepositAccountPage extends StatefulWidget {
  @override
  _DepositAccountPageState createState() => _DepositAccountPageState();
}

class _DepositAccountPageState extends State<DepositAccountPage> with AfterLayoutMixin {
  BankListBloc blockOfBankList = BankListBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PaymentHistoryBloc bloc;
  StreamSubscription<BankListResponse> sbOfBankListResponse;
  StreamSubscription<BaseResponse> sbOfDeleteBankDetail;

  @override
  void initState() {
    super.initState();
    this.bloc = PaymentHistoryBloc.createWith(bloc: this.bloc);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.apiCallBankList();
  }

  @override
  void dispose() {
    if (this.sbOfBankListResponse != null) this.sbOfBankListResponse.cancel();
    if (this.sbOfDeleteBankDetail != null) this.sbOfDeleteBankDetail.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.whiteColor,
      appBar: this.setAppBar(),
      body: this.blockOfBankList.isApiResponseReceived ? this.setContainerOfListView() : Container(),
    );
  }

  Widget setContainerOfListView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(20)),
      child: ListView.builder(
        itemCount: this.blockOfBankList.aryOfBankList.length + 1,
        padding: EdgeInsets.symmetric(vertical: UIUtills().getProportionalWidth(20)),
        itemBuilder: (context, index) {
          if (this.blockOfBankList.aryOfBankList.length == index) {
            return this.setContainerOfAddBankAccount();
          } else {
            return setContainerOfCardDetails(index: index);
          }
        },
      ),
    );
  }

  Widget setContainerOfCardDetails({int index}) {
    return Container(
      color: AppColor.whiteColor,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          UIUtills().setCommonSizeBox(value: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: UIUtills().getProportionalWidth(30),
                    width: UIUtills().getProportionalWidth(30),
                    decoration: BoxDecoration(color: AppColor.boarderInCardColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Image.asset(AppImage.paymentIcon),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(16)),
                    child: Text(
                      "● ● ● ●" + this.blockOfBankList.aryOfBankList[index].last4,
                      style: UIUtills().getTextStyle(color: AppColor.textColor, fontName: AppFont.sfProTextMedium, fontsize: 15, characterSpacing: 0.36),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  apiCallDeleteBankDetails(index);
                },
                child: Container(
                  margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(8)),
                  child: Icon(
                    Icons.delete,
                    color: AppColor.textColor,
                    size: 19,
                  ),
                ),
              )
            ],
          ),
          UIUtills().setCommonSizeBox(value: 10),
          setContainerOfDivider,

        ],
      ),
    );
  }

  /// Container Of Add Bank Account
  Widget setContainerOfAddBankAccount() {
    return GestureDetector(
      onTap: () {
        this.pushToAddAccountPage();
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: UIUtills().getProportionalWidth(30),
                  width: UIUtills().getProportionalWidth(30),
                  decoration: BoxDecoration(color: AppColor.boarderInCardColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Image.asset(AppImage.plusPayment),
                ),
                Container(
                  margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(16)),
                  child: Text(
                    this.blockOfBankList.aryOfBankList.isNotEmpty ? AppTranslations.globalTranslations.changeDepositAccountText : AppTranslations.globalTranslations.addDepositAccountText,
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
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset(
                AppImage.rightArrow,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ********************************    Api Call    ********************************  ///
  /// Api For Get Bank List
  void apiCallBankList() {
    // Validate Form
    this.sbOfBankListResponse = this.blockOfBankList.bankListOptionStream.listen((BankListResponse response) {
      this.sbOfBankListResponse.cancel();
      UIUtills().dismissProgressDialog(context);
      this.blockOfBankList.isApiResponseReceived = true;
      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        if (response.status) {
        } else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
        setState(() {});
      });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this.blockOfBankList.apiCallBankList();
  }

  /// Api Delete Ban
  void apiCallDeleteBankDetails(int index) {
    this.sbOfDeleteBankDetail = this.blockOfBankList.deleteBankStream.listen((BaseResponse response) {
      this.sbOfDeleteBankDetail.cancel();

      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);

        if (response.status) {
          this.blockOfBankList.aryOfBankList.removeAt(index);
          if (mounted) {
            setState(() {});
          }
        }
        Utils.showSnakBarwithKey(this._scaffoldKey, response.message);
      });
    });
    UIUtills().showProgressDialog(context);

    this.blockOfBankList.apiCallDeleteBankDetails(this.blockOfBankList.aryOfBankList[index].id);
  }

  /// Helper Func
  Widget setAppBar() {
    return AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.depositAccount,
          style: UIUtills().getTextStyle(characterSpacing: 0.4, color: AppColor.appBartextColor, fontsize: 17, fontName: AppFont.sfProTextSemibold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5);
  }

  Widget get setContainerOfDivider => Container(height: 1, width: double.infinity, color: AppColor.paymentMethodDividerColor);

  Future<void> pushToAddAccountPage() async {
    var value = await NavigationService().push(MaterialPageRoute(builder: (context) {
      return AddBankDetails(bloc: this.bloc,isComeFromDepositAccountPage: true,);
    }));

    if (value == 1) this.apiCallBankList();
  }

}
