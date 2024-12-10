//import 'package:rxdart/rxdart.dart';
//import 'package:thankxdriver/api_provider/all_request.dart';
//import 'package:thankxdriver/api_provider/all_response.dart';
//import 'package:thankxdriver/bloc/base_bloc.dart';
//import 'package:thankxdriver/localization/localization.dart';
//import 'package:thankxdriver/model/add_bank_details_model.dart';
//import 'package:thankxdriver/validation/validation.dart';
//import 'package:tuple/tuple.dart';
//
//class AddBankBloc extends BaseBloc {
//  final _addBankOptionSubject = PublishSubject<AddBankDetailResponse>();
//  Observable<AddBankDetailResponse> get addBankOptionStream => _addBankOptionSubject.stream;
//
//
//  final _accountNumber = BehaviorSubject<String>();
//  final _accountHolderName = BehaviorSubject<String>();
//  final _routingNumber = BehaviorSubject<String>();
//  final _bankName = BehaviorSubject<String>();
////
//  // add data to stream
//  Function(String) get accountNumber => _accountNumber.sink.add;
//  Function(String) get accountHolderName => _accountHolderName.sink.add;
//  Function(String) get routingNumber => _routingNumber.sink.add;
//  Function(String) get bankName => _bankName.sink.add;
//
//  AddBankDetailModel model;
//
//  @override
//  dispose() {
//    super.dispose();
//    _accountNumber.close();
//    _routingNumber.close();
//    _accountHolderName.close();
//    _bankName.close();
//
//    _addBankOptionSubject.close();
//  }
//
//  Tuple2<bool, String> isValidForm() {
//    List< Tuple2<ValidationType, String> > arrList = [];
//    arrList.add( Tuple2(ValidationType.accountNameHolder, this._accountHolderName.value ?? ''));
//    arrList.add(Tuple2(ValidationType.bankName,this._bankName.value ?? ''));
//    arrList.add(Tuple2(ValidationType.accountNumber,this._accountNumber.value ?? ''));
//    arrList.add(Tuple2(ValidationType.routingNumber,this._routingNumber.value ?? ''));
//
//    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
////    if(validationResult.item1 == true){
////      if (this._password.value != this._confirmPassword.value) {
////        return Tuple2(false, AppTranslations.globalTranslations.msgPasswordConfirmPasswordMatch);
////      }
////    }
//
//    return Tuple2(validationResult.item1, validationResult.item2);
//  }
//
//
//  void callAddBankDetailApi() async {
//    AddBankDetailRequest request = AddBankDetailRequest();
//    request.routingNumber = this._routingNumber.value;
//    request.accHolderName = this._accountHolderName.value;
//
////    request.bankName = this._bankName.value;
//    request.accountNumber = this._accountNumber.value;
//
//    AddBankDetailResponse response = await repository.addBankDetailsApi(params: request);
//    _addBankOptionSubject.sink.add(response);
//  }
//
//}
