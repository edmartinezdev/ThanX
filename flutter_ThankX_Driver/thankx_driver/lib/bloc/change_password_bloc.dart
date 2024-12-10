import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:thankxdriver/api_provider/all_request.dart';

import 'package:tuple/tuple.dart';

import 'base_bloc.dart';

class ChangePasswordBloc extends BaseBloc {

  final _changePasswordSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get changePasswordStream => _changePasswordSubject.stream;

  dispose() {
    _changePasswordSubject.close();
  }

  Tuple2<bool, String> isValidPassword(String currentPassword,String newPassword,String confirmPassword) {
    List< Tuple2<ValidationType, String> > arrList = [];
    arrList.add( Tuple2(ValidationType.currentPassword,currentPassword));
    arrList.add( Tuple2(ValidationType.newPassword,newPassword));
    arrList.add( Tuple2(ValidationType.confirmNewPassword,confirmPassword));

    var validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    if (!validationResult.item1) {
      return Tuple2(validationResult.item1, validationResult.item2);
    }
    if (newPassword != confirmPassword) {
      return Tuple2(false, AppTranslations.globalTranslations.newAndConfirmPassword);
    }
    return Tuple2(true, '');
  }


  void changePasswordApi(String currentPassword,String newPassword) async {

    ChangePasswordRequest changePasswordRequest = new ChangePasswordRequest();
    changePasswordRequest.userId = User.currentUser.sId;
    changePasswordRequest.currentPassword =currentPassword;
    changePasswordRequest.newPassword = newPassword;
    BaseResponse model = await repository.changePasswordApi(params: changePasswordRequest);
    _changePasswordSubject.sink.add(model);
  }
}