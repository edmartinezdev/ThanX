import 'dart:core';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/add_bank_details_model.dart';
import 'package:thankxdriver/model/bank_list_model.dart';
import 'package:thankxdriver/model/check_stripe_account_model.dart';
import 'package:thankxdriver/model/payment_history_model.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/model/withdraw_amount_model.dart';
import 'package:thankxdriver/utils/date_utils.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';
import 'package:thankxdriver/utils/string_extension.dart';


class PaymentHistoryBloc extends BaseBloc {

  PaymentHistoryBloc.createWith({PaymentHistoryBloc bloc}) {
    if (bloc != null) {
      this._paymentHistoryList = bloc.paymentHistoryList;
      this._isLoadMore = bloc.isLoadMore;
    }
  }


  final _paymentHistoryBlocOptionSubject = PublishSubject<PaymentHistoryResponse>();
  Observable<PaymentHistoryResponse> get paymentHistoryOptionStream => _paymentHistoryBlocOptionSubject.stream;

  bool _isLoadMore = false;
  bool get isLoadMore => _isLoadMore;
  bool isApiResponseReceived = false;

  PaymentHistoryModel model;

  List<PaymentHistory> _paymentHistoryList = [];
  List<PaymentHistory> get paymentHistoryList => this._paymentHistoryList;

  void callPaymentHistoryApi({int offset}) async {
    PaymentHistoryRequest request = PaymentHistoryRequest();
    request.limit = this.defaultFetchLimit;
    request.offset = offset;

    PaymentHistoryResponse response = await repository.getAllPaymentHistorytApi(params: request);
    if (response.status) {
      model = response.data;
    }
    if (offset == 0) {
      this._paymentHistoryList.clear();
    }

    this._paymentHistoryList.addAll(response.data.paymentHistory);
    _isLoadMore = (response.data.paymentHistory.isNotEmpty) && ((response.data.paymentHistory ?? []).length % this.defaultFetchLimit) == 0;
    _paymentHistoryBlocOptionSubject.sink.add(response);

  }

  BankListModel bankModel = BankListModel();
//region Withdraw amount
  final _withdrawAmountOptionSubject = PublishSubject<WithdrawAmountResponse>();
  Observable<WithdrawAmountResponse> get withdrawAmountOptionSubject => _withdrawAmountOptionSubject.stream;
  WithdrawAmountModel withdrawAmountModel;

  void callWithdrawAmountApi({double amount, String id}) async {

    WithDrawAmountRequest request = WithDrawAmountRequest();
    request.amount = amount;
    request.bankAccountId = id;
    WithdrawAmountResponse response = await repository.withdrawAmountApi(params: request);
    withdrawAmountModel = response.data;
    if(response.status){
      withdrawAmountModel = response.data;
    }
    else{
      withdrawAmountModel = response.data;
    }
    _withdrawAmountOptionSubject.sink.add(response);

  }

  //endregion

  CheckStripeAccountModel checkStripeAccountModel;


//  //region bank account account
//  final _checkBankAccountOptionSubject = PublishSubject<CheckStripeAccountResponse>();
//  Observable<CheckStripeAccountResponse> get checkBankAccountOptionSubject => _checkBankAccountOptionSubject.stream;
//  void callBankAccountApi() async {
//
//    CheckStripeAccountRequest request = CheckStripeAccountRequest();
//    request.userId = User.currentUser.sId;
//
//    CheckStripeAccountResponse response = await repository.checkStripeAccountApi(params: request);
//    checkStripeAccountModel = response.data;
//    if(response.status){
//      checkStripeAccountModel = response.data;
//    }
//    _checkStripeAccountOptionSubject.sink.add(response);
//
//  }
//  //endregion

  //region check stripe account
  final _checkStripeAccountOptionSubject = PublishSubject<CheckStripeAccountResponse>();
  Observable<CheckStripeAccountResponse> get checkStripeAccountOptionSubject => _checkStripeAccountOptionSubject.stream;
  void callStripeAccountApi() async {

    CheckStripeAccountRequest request = CheckStripeAccountRequest();
    request.userId = User.currentUser.sId;

    CheckStripeAccountResponse response = await repository.checkStripeAccountApi(params: request);
    checkStripeAccountModel = response.data;
    if(response.status){
      checkStripeAccountModel = response.data;
    }
    _checkStripeAccountOptionSubject.sink.add(response);

  }
  //endregion



//region add bank details
  final _addBankOptionSubject = PublishSubject<AddBankDetailResponse>();
  Observable<AddBankDetailResponse> get addBankOptionStream => _addBankOptionSubject.stream;

  final _accountHolderName = BehaviorSubject<String>();
  final _dateOfBirth = BehaviorSubject<String>();
  final _address = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _phoneNumber = BehaviorSubject<String>();
  final _ssnNumber = BehaviorSubject<String>();
  final _accountNumber = BehaviorSubject<String>();
  final _routingNumber = BehaviorSubject<String>();
//  final _bankName = BehaviorSubject<String>();

  TextEditingController accountholderFirstNameTextController = TextEditingController();
  TextEditingController accountholderLastNameTextController = TextEditingController();
  TextEditingController bankNameTextController = TextEditingController();
  TextEditingController birthDateTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController pinCodeTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController ssnNumberTextController = TextEditingController();
  TextEditingController accountNumberTextController = TextEditingController();
  TextEditingController routingNumberTextController = TextEditingController();

  clearTextControllers(){
    accountholderFirstNameTextController.clear();
    accountholderLastNameTextController.clear();
    bankNameTextController.clear();
    birthDateTextController.clear();
    addressTextController.clear();
    cityTextController.clear();
    stateTextController.clear();
    pinCodeTextController.clear();
    emailTextController.clear();
    phoneNumberTextController.clear();
    ssnNumberTextController.clear();
    accountNumberTextController.clear();
    routingNumberTextController.clear();
  }


  // add data to stream
  Function(String) get accountHolderName => _accountHolderName.sink.add;
  Function(String) get address => _address.sink.add;

//  Function(String) get bankName => _bankName.sink.add;
  Function(String) get dateOfBirth => _dateOfBirth.sink.add;
  Function(String) get email => _email.sink.add;
  Function(String) get phoneNumber => _phoneNumber.sink.add;
  Function(String) get ssnNumber => _ssnNumber.sink.add;
  Function(String) get accountNumber => _accountNumber.sink.add;
  Function(String) get routingNumber => _routingNumber.sink.add;

  AddBankDetailModel bankDetailModel = AddBankDetailModel();


  void callAddBankDetailApi( ) async {
    DateTime date = DateUtilss.stringToDate(birthDateTextController.text, format: AppDataFormat.appDobFormat);

    AddBankDetailRequest request = AddBankDetailRequest();
    request.accHolderName = this.accountholderFirstNameTextController.text + " "+this.accountholderLastNameTextController.text;
    request.bankName = this.bankNameTextController.text;
    request.month = DateUtilss.dateToString(date, format: AppDataFormat.serverMonthFormat);
    request.day =DateUtilss.dateToString(date, format: AppDataFormat.serverDayFormat);
    request.year = DateUtilss.dateToString(date, format: AppDataFormat.serverYearFormat);
    request.address = this.addressTextController.text;
    request.email = this.emailTextController.text;
    request.phoneNumber = this.phoneNumberTextController.text.convertToPhoneNumber();
    request.ssnNumber = this.ssnNumberTextController.text;
    request.accountNumber = this.accountNumberTextController.text;
    request.routingNumber = this.routingNumberTextController.text;
    request.state = this.stateTextController.text;
    request.city = this.cityTextController.text;
    request.pincode = this.pinCodeTextController.text;

    AddBankDetailResponse response = await repository.addBankDetailsApi(params: request);
    _addBankOptionSubject.sink.add(response);
  }

  Tuple2<bool, String> isValidForm() {
    List< Tuple2<ValidationType, String> > arrList = [];
    arrList.add( Tuple2(ValidationType.firstName, this.accountholderFirstNameTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.lastName, this.accountholderLastNameTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.bankName,this.bankNameTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.city,this.cityTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.state,this.stateTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.zipCode,this.pinCodeTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.birthDate, this.birthDateTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.userAddress, this.addressTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.email, this.emailTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.phoneNumber, this.phoneNumberTextController.text ?? ''));
    arrList.add( Tuple2(ValidationType.ssnNumber, this.ssnNumberTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.accountNumber,this.accountNumberTextController.text ?? ''));
    arrList.add(Tuple2(ValidationType.routingNumber,this.routingNumberTextController.text ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
//    if(validationResult.item1 == true){
//      if (this._password.value != this._confirmPassword.value) {
//        return Tuple2(false, AppTranslations.globalTranslations.msgPasswordConfirmPasswordMatch);
//      }
//    }

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  //endregion

  @override
  dispose() {
    super.dispose();
    _accountNumber.close();
    _routingNumber.close();
    _accountHolderName.close();
    _dateOfBirth.close();
    _ssnNumber.close();
    _phoneNumber.close();
    _email.close();
    _address.close();


//    accountholderNameTextController.dispose();
//    bankNameTextController.dispose();
//    birthDateTextController.dispose();
//    addressTextController.dispose();
//    cityTextController.dispose();
//    stateTextController.dispose();
//    pinCodeTextController.dispose();
//    ssnNumberTextController.dispose();
//    accountNumberTextController.dispose();
//    routingNumberTextController.dispose();

    _addBankOptionSubject.close();
    _paymentHistoryBlocOptionSubject.close();
    _withdrawAmountOptionSubject.close();
    _checkStripeAccountOptionSubject.close();
//    _checkBankAccountOptionSubject.close();
  }
}