
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:thankxdriver/bloc/add_bank_bloc.dart';
import 'package:thankxdriver/bloc/payment_history_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/MePage/Wallet/wallet_deposit_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_dateformat.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/date_utils.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';
import 'package:thankxdriver/utils/string_extension.dart';


class AddBankDetails extends StatefulWidget {
  PaymentHistoryBloc bloc;
  bool isComeFromDepositAccountPage = false;
  AddBankDetails({this.bloc,this.isComeFromDepositAccountPage});

  @override
  _AddBankDetailsState createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDateTime = DateTime.now();

  StreamSubscription<AddBankDetailResponse> _addBankSubscription;

  FocusNode accountHolderFirstNameFocusNode = FocusNode();
  FocusNode accountHolderLastNameFocusNode = FocusNode();
  FocusNode bankNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode pinCodeFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode ssnNumberFocusNode = FocusNode();
  FocusNode dateOfBirthFocusNode = FocusNode();

  FocusNode accountNumberFocusNode = FocusNode();
  FocusNode routingNumberFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    this.widget.bloc.emailTextController.text = User.currentUser.email;
    this.widget.bloc.phoneNumberTextController.text = User.currentUser.contactNumber.convertToUSAPhoneNumber();
    accountHolderFirstNameFocusNode.addListener(() => setState(() {}));
    accountHolderLastNameFocusNode.addListener(() => setState(() {}));
    bankNameFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    addressFocusNode.addListener(() => setState(() {}));
    cityFocusNode.addListener(() => setState(() {}));
    stateFocusNode.addListener(() => setState(() {}));
    pinCodeFocusNode.addListener(() => setState(() {}));
    phoneNumberFocusNode.addListener(() => setState(() {}));
    ssnNumberFocusNode.addListener(() => setState(() {}));
    dateOfBirthFocusNode.addListener(() => setState(() {}));
    accountNumberFocusNode.addListener(() => setState(() {}));
    routingNumberFocusNode.addListener(() => setState(() {}));


  }

  @override
  void dispose() {
    if (this._addBankSubscription != null) {
      this._addBankSubscription.cancel();
    }
    this.accountHolderFirstNameFocusNode.dispose();
    this.accountHolderLastNameFocusNode.dispose();
    this.bankNameFocusNode.dispose();
    this.emailFocusNode.dispose();
    this.addressFocusNode.dispose();
    this.cityFocusNode.dispose();
    this.stateFocusNode.dispose();
    this.pinCodeFocusNode.dispose();
    this.phoneNumberFocusNode.dispose();
    this.ssnNumberFocusNode.dispose();
    this.dateOfBirthFocusNode.dispose();
    this.accountNumberFocusNode.dispose();
    this.routingNumberFocusNode.dispose();

    this.widget.bloc.clearTextControllers();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColor.whiteColor,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text("Add Bank", style: UIUtills().getTextStyle(
            color: AppColor.appBartextColor,
            fontsize: 17,
            fontName: AppFont.sfCompactSemiBold
        ),),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: SafeArea(bottom:true, child: GestureDetector(onTap: (){
        FocusScope.of(context).unfocus();
      },child: Container(color: AppColor.whiteColor,child: SingleChildScrollView(child: textFieldContainer(),),),),)
    );
  }

  Widget textFieldContainer() {
    return Container(
      color: AppColor.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: AppColor.whiteColor,
            padding: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(28),
              left: UIUtills().getProportionalWidth(28),
              right: UIUtills().getProportionalWidth(28),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: TextFieldWithLabel(
//                    onChanged: this.widget.bloc.accountHolderName,
                    controller: this.widget.bloc.accountholderFirstNameTextController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    textType: TextFieldType.name,
                    action: TextInputAction.next,
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(accountHolderLastNameFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.firstNameText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: accountHolderFirstNameFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                    onChanged: this.widget.bloc.bankName,
                      controller: this.widget.bloc.accountholderLastNameTextController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.name,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(bankNameFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.lastNameText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: accountHolderLastNameFocusNode
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                    onChanged: this.widget.bloc.bankName,
                    controller: this.widget.bloc.bankNameTextController,
                    keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    textType: TextFieldType.charactersWithSpace,
                    action: TextInputAction.next,
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(addressFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.bankName,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: bankNameFocusNode
                  ),
                ),

              GestureDetector(onTap: (){
                _onTapDateSelection();
                FocusScope.of(context).requestFocus(addressFocusNode);
              },child: Container(
                margin: EdgeInsets.only(
                  top: UIUtills().getProportionalHeight(20),
                ),
                child: TextFieldWithLabel(
                    enabled: false,
//                      onChanged: this.widget.bloc.dateOfBirth,
                    controller: this.widget.bloc.birthDateTextController,
                    keyboardType: TextInputType.datetime,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    textType: TextFieldType.numericOnly,
                    action: TextInputAction.next,
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(addressFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.dateOfBirthText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: dateOfBirthFocusNode
                ),
              ),),

                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.address,
                      controller: this.widget.bloc.addressTextController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.none,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(cityFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.addressText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: addressFocusNode
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.address,
                      controller: this.widget.bloc.cityTextController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.charactersWithSpace,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(stateFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.cityText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: cityFocusNode
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.address,
                      controller: this.widget.bloc.stateTextController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.charactersWithSpace,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(pinCodeFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.stateText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: stateFocusNode
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.address,
                  maxLength: 5,
                      controller: this.widget.bloc.pinCodeTextController,
                      keyboardType: TextInputType.number,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.numericOnly,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.zipCodeText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: pinCodeFocusNode
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.email,
                      controller: this.widget.bloc.emailTextController,
                      keyboardType: TextInputType.emailAddress,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.email,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.emailText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: emailFocusNode
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.phoneNumber,
                      controller: this.widget.bloc.phoneNumberTextController,
                      keyboardType: TextInputType.phone,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.usaPhoneNumber,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(ssnNumberFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.phoneNumberText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: phoneNumberFocusNode
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                      onChanged: this.widget.bloc.ssnNumber,
                      maxLength: 4,
                      controller: this.widget.bloc.ssnNumberTextController,
                      keyboardType: TextInputType.number,
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      style: UIUtills().getTextStyleRegular(
                        color: AppColor.textColor,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      textType: TextFieldType.numericOnly,
                      action: TextInputAction.next,
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(accountNumberFocusNode);
                      },
                      labelText: AppTranslations.globalTranslations.ssnNumberText,
                      labelTextStyle: UIUtills().getTextStyleRegular(
                        color: AppColor.textColorLight,
                        fontSize: 15,
                        characterSpacing: 0.4,
                        fontName: AppFont.sfProTextMedium,
                      ),
                      focusNode: ssnNumberFocusNode
                  ),
                ),



                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                    onChanged: this.widget.bloc.accountNumber,
                  maxLength: 18,
                    controller: this.widget.bloc.accountNumberTextController,
                    keyboardType: TextInputType.phone,
                    textType: TextFieldType.phoneNumber,
                    action: TextInputAction.next,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(routingNumberFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.accountNumber,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: accountNumberFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
//                    onChanged: this.widget.bloc.routingNumber,
                  maxLength: 9,
                    controller: this.widget.bloc.routingNumberTextController,
                    keyboardType: TextInputType.number,
                    action: TextInputAction.done,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    textType: TextFieldType.phoneNumber,
                    onEditCompletie: () {
                      FocusScope.of(context).unfocus();
                    },
                    labelText: AppTranslations.globalTranslations.routingNumber,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: routingNumberFocusNode,
                  ),
                ),
              ],
            ),
          ),
          button()
        ],
      ),
    );
  }

  Widget button(){
    return Container(
        margin: EdgeInsets.only(
          top: UIUtills().getProportionalHeight(40),
          bottom: UIUtills().getProportionalHeight(48),
          left: UIUtills().getProportionalWidth(28),
          right: UIUtills().getProportionalWidth(28),
        ),
        child: CommonButton(
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: (){
            apiCallAddBankDetails();
          },
          textColor: AppColor.textColor,
          fontName:AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonNext,
        ));
  }


  /// ********************************    Api Call    ********************************  ///
  /// Api For Add Bank Details
  void apiCallAddBankDetails() {

    FocusScope.of(context).requestFocus(FocusNode());

    final validationResult = this.widget.bloc.isValidForm();
    if (!validationResult.item1) {
     Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }
    _addBankSubscription = this.widget.bloc.addBankOptionStream.listen((AddBankDetailResponse response) {
      _addBankSubscription.cancel();

      UIUtills().dismissProgressDialog(context);
          if (response.status) {
            Utils.showAlert(context, message: response.message, arrButton: [AppTranslations.globalTranslations.btnOK], callback: (_) {
              if (this.widget.isComeFromDepositAccountPage) {
                NavigationService().pop(result: 1);
              } else {
                NavigationService().pop();
                NavigationService().pop();
              }
            });
          }else{
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
          }
          setState(() {});

    });
    UIUtills().showProgressDialog(context);
    this.widget.bloc.callAddBankDetailApi();
  }


  void _onTapDateSelection() async {
    if (Platform.isIOS) {
      DatePicker.showDatePicker(
        context,
        pickerTheme: DateTimePickerTheme(
          showTitle: true,
          backgroundColor: AppColor.whiteColor,
          cancelTextStyle: UIUtills().getTextStyle(
              fontName: AppFont.sfProDisplayBold,
              fontsize: 14,
              color: AppColor.switchOnColor),
          confirmTextStyle: UIUtills().getTextStyle(
              fontName: AppFont.sfProDisplayBold,
              fontsize: 14,
              color: AppColor.primaryColor),
          confirm: Text('Done',
              style: UIUtills().getTextStyle(
                  fontName: AppFont.sfProDisplayBold,
                  fontsize: 14,
                  color: AppColor.primaryColor)),
          cancel: Text('Cancel',
              style: UIUtills().getTextStyle(
                  fontName: AppFont.sfProDisplayBold,
                  fontsize: 14,
                  color: AppColor.primaryColor)),
        ),
        minDateTime: DateTime(1950),
        maxDateTime: DateTime.now(),
//        initialDateTime: this.selectedDateTime,
        dateFormat: AppDataFormat.datePickerDateFormat,
        locale: DateTimePickerLocale.en_us,
        onConfirm: (dateTime, List<int> index) {
          if (dateTime != null) {
            _onSelectDateTime(datetime: dateTime);
          }
        },
      );
    } else if (Platform.isAndroid) {
      final DateTime picked = await showDatePicker(
        context: this.context,
        initialDate: this.selectedDateTime,
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      );

      if (picked != null) _onSelectDateTime(datetime: picked);
    }
  }

  void _onSelectDateTime({DateTime datetime}) {
    this.selectedDateTime = datetime;
    print ("================Date  "+ datetime.toString());
    this.widget.bloc.birthDateTextController.text = DateUtilss.dateToString(datetime, format: AppDataFormat.appDobFormat);
    if (mounted) {
      setState(() {});
    }
  }
}

