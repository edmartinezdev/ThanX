import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/payment_history_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/pull_to_refresh_list_view.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Wallet/wallet_deposit_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class WalletPage extends StatefulWidget {
  PaymentHistoryBloc paymentHistoryBloc;

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PaymentHistoryBloc _paymentHistoryBloc;
  StreamSubscription<PaymentHistoryResponse> _paymentHistorySubscription;

//  @override
//  void afterFirstLayout(BuildContext context) {
//   paymentHistoryApi(offset: 0);
//  }

  @override
  void initState() {
    super.initState();

    _paymentHistoryBloc =
        PaymentHistoryBloc.createWith(bloc: this.widget.paymentHistoryBloc);
    this.widget.paymentHistoryBloc = this._paymentHistoryBloc;
    Future.delayed(
      Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
      () {
        if (mounted) {
          this.paymentHistoryApi(offset: 0);
        }
      },
    );
  }

  @override
  void dispose() {
    if (_paymentHistorySubscription != null)
      _paymentHistorySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(AppImage.backArrow),
          ),
          title: Text(
            AppTranslations.globalTranslations.walletTitle,
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
          child: Column(
            children: <Widget>[
              depositContainer(),
              Expanded(
                child: listContainer(),
              )
            ],
          ),
        ));
  }

  Widget depositContainer() {
    return Card(
      color: AppColor.whiteColor,
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.only(
          top: UIUtills().getProportionalHeight(34),
          left: UIUtills().getProportionalWidth(16),
          right: UIUtills().getProportionalWidth(16),
          bottom: UIUtills().getProportionalHeight(20)),
      child: Column(
        children: <Widget>[
          Container(
              margin:
                  EdgeInsets.only(top: UIUtills().getProportionalHeight(60)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "\$",
                    style: UIUtills().getTextStyle(
                        fontsize: 51,
                        fontName: AppFont.sfProDisplayLight,
                        color: AppColor.textColor,
                        characterSpacing: 0.0),
                  ),
                  Text(

                    (this._paymentHistoryBloc?.model?.totalAmount ?? 00.0).toStringAsFixed(2),
                    style: UIUtills().getTextStyle(
                        fontsize: 51,
                        fontName: AppFont.sfProDisplayBold,
                        color: AppColor.textColor,
                        characterSpacing: 0.0),
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(
                top: UIUtills().getProportionalWidth(40),
                bottom: UIUtills().getProportionalHeight(24),
                left: UIUtills().getProportionalWidth(12),
                right: UIUtills().getProportionalWidth(12),
              ),
              child: (this._paymentHistoryBloc?.model?.totalAmount != 0)
                  ? CommonButton(
                      height: UIUtills().getProportionalWidth(40),
                      width: double.infinity,
                      backgroundColor: AppColor.primaryColor,
                      onPressed: () {
                        NavigationService().push( MaterialPageRoute(builder: (context) {return WalletDepositPage(bloc: this._paymentHistoryBloc,);})).then((r){paymentHistoryApi(offset: 0);});
                        //                        Navigator.push(context, MaterialPageRoute(builder: (context) {return WalletDepositPage(bloc: this._paymentHistoryBloc,);
//                            },
//                          ),
//                        );
                      },
                      textColor: AppColor.textColor,
                      fontName: AppFont.sfProTextMedium,
                      fontsize: 17,
                      characterSpacing: 0,
                      text: AppTranslations.globalTranslations.buttonDeposit,
                    )
                  : Container())
        ],
      ),
    );
  }

  Widget listContainer() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: UIUtills().getProportionalHeight(38),
                left: UIUtills().getProportionalWidth(28)),
            child: Text(
              AppTranslations.globalTranslations.paymentHistory,
              style: UIUtills().getTextStyle(
                  fontName: AppFont.sfProTextSemibold,
                  fontsize: 14,
                  color: AppColor.textColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: UIUtills().getProportionalHeight(16),
                left: UIUtills().getProportionalWidth(16),
                right: UIUtills().getProportionalWidth(16)),
            width: double.infinity,
            height: 1,
            color: AppColor.dialogDividerColor,
          ),
          Expanded(
            child: withEmptyList(),
          )
        ],
      ),
    );
  }

  Widget withEmptyList() {
    if(!this._paymentHistoryBloc.isApiResponseReceived){
      return Container();
    }
    final listView = PullToRefreshListView(
      itemCount: this._paymentHistoryBloc.isLoadMore ? this._paymentHistoryBloc.paymentHistoryList.length + 1 : this._paymentHistoryBloc.paymentHistoryList.length,
      padding: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(20)),
      onRefresh: () async => this.paymentHistoryApi(offset: 0),
      builder: (contex, index) {
        if (index == this._paymentHistoryBloc.paymentHistoryList.length) {
          Future.delayed(Duration(milliseconds: 100), () => this.paymentHistoryApi(offset: this._paymentHistoryBloc.paymentHistoryList.length),);
          return Utils.buildLoadMoreProgressIndicator();
        }
        return commonWidget(
            "${this._paymentHistoryBloc.paymentHistoryList[index].convertedDateForEdit}",
            (this._paymentHistoryBloc.paymentHistoryList[index].paymentType == 1)
                ? "+ \$"+this._paymentHistoryBloc.paymentHistoryList[index].amount.toStringAsFixed(2)
                :"- \$"+this._paymentHistoryBloc.paymentHistoryList[index].amount.toStringAsFixed(2));
      },
    );

    if (this._paymentHistoryBloc.paymentHistoryList.isNotEmpty) {
      return listView;
    } else {
      return Stack(
        children: <Widget>[
          listView,
          Visibility(
            visible: this._paymentHistoryBloc.isApiResponseReceived,
            child: Container(
              height: UIUtills().screenHeight,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("Payment history is not available."),
            ),
          )
        ],
      );
    }
  }

  Widget commonWidget(String date, String amount) {
    return Container(
      margin: EdgeInsets.only(
          top: UIUtills().getProportionalHeight(20),
          left: UIUtills().getProportionalWidth(16),
          right: UIUtills().getProportionalWidth(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: UIUtills().getProportionalHeight(33),
            decoration: BoxDecoration(
              color: AppColor.roundedButtonColor,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(17), right: Radius.circular(17)),
//                      shape: BoxShape.rectangle
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                left: UIUtills().getProportionalWidth(14),
                right: UIUtills().getProportionalWidth(14)),
            child: Text(
              date,
              style: UIUtills().getTextStyle(
                  fontName: AppFont.sfProDisplayRegular,
                  fontsize: 12,
                  characterSpacing: 0.3,
                  color: AppColor.textColor),
            ),
          ),
          Container(
            child: Text(
              amount,
              style: UIUtills().getTextStyle(
                  fontsize: 14,
                  fontName: AppFont.sfProDisplayMedium,
                  color: AppColor.textColor),
            ),
          )
        ],
      ),
    );
  }

  void paymentHistoryApi({@required int offset}) {
    final bool isNeedLoader = this._paymentHistoryBloc.paymentHistoryList.length == 0;

    _paymentHistorySubscription =
        this._paymentHistoryBloc.paymentHistoryOptionStream.listen(
      (PaymentHistoryResponse response) {
        _paymentHistorySubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            this._paymentHistoryBloc.isApiResponseReceived = true;
            if (isNeedLoader) {
              UIUtills().dismissProgressDialog(context);
            }
            if (!response.status) {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
              return;
            }
            setState(() {});
          },
        );
      },
    );
    this._paymentHistoryBloc.callPaymentHistoryApi(offset: offset);
    if (isNeedLoader) {
      UIUtills().showProgressDialog(context);
    }
  }
}
