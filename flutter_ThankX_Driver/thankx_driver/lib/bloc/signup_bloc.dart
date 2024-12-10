import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/layout/LoginAndSignup/profile_picture_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';
import 'package:thankxdriver/utils/string_extension.dart';



class SignUpBloc extends BaseBloc {
  final _signupOptionSubject = PublishSubject<UserAuthenticationResponse>();
  Observable<UserAuthenticationResponse> get signupOptionStream => _signupOptionSubject.stream;

  File imageFile ;

 final TextEditingController firstNameController = TextEditingController();
 final TextEditingController lastNameController = TextEditingController();
 final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPasswordController = TextEditingController();


  final _firstName = BehaviorSubject<String>();
  final _lastName = BehaviorSubject<String>();
  final _phoneNumber = BehaviorSubject<String>();
  final _email = BehaviorSubject<String>();
  final _confirmEmail = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmPassword = BehaviorSubject<String>();


  // add data to stream
  Function(String) get firstName => _firstName.sink.add;
  Function(String) get lastName => _lastName.sink.add;
  Function(String) get phoneNumber => _phoneNumber.sink.add;
  Function(String) get email => _email.sink.add;
  Function(String) get confirmEmail => _confirmEmail.sink.add;
  Function(String) get password => _password.sink.add;
  Function(String) get confirmPassword => _confirmPassword.sink.add;

  SignupRequest request = SignupRequest();

  void callSignUpApi() async {
    if (imageFile != null) {
      request.selectedFile = imageFile;
    }
    UserAuthenticationResponse response = await repository.signupApi(params: request);
    _signupOptionSubject.sink.add(response);
  }

  Tuple2<bool, String> isValidForm() {
    List< Tuple2<ValidationType, String> > arrList = [];
    arrList.add( Tuple2(ValidationType.firstName, this.firstNameController.text ?? ''));
    arrList.add(Tuple2(ValidationType.lastName,this.lastNameController.text ?? ''));
    arrList.add( Tuple2(ValidationType.phoneNumber, this.phonenumberController.text ?? ''));
    arrList.add(Tuple2(ValidationType.email,this.emailController.text ?? ''));
    arrList.add( Tuple2(ValidationType.confirmEmail, this.confirmEmailController.text ?? ''));
    arrList.add(Tuple2(ValidationType.passWord,this.passwordController.text ?? ''));
    arrList.add(Tuple2(ValidationType.confirmPassWord,this.reEnterPasswordController.text ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    if(validationResult.item1 == true){
      if (this.emailController.text != this.confirmEmailController.text) {
        return Tuple2(false, AppTranslations.globalTranslations.msgPasswordConfirmEmailMatch);
      }
      else if (this.passwordController.text != this.reEnterPasswordController.text) {
        return Tuple2(false, AppTranslations.globalTranslations.msgPasswordConfirmPasswordMatch);
      }

    }

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  final _checkEmailAndPhoneOptionSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get checkEmailAndPhoneOptionStream => _checkEmailAndPhoneOptionSubject.stream;
  void checkEmailAndPhoneApi() async {
    CheckEmailAndPhoneNumberRequest request = CheckEmailAndPhoneNumberRequest();
    request.userType = '2';
    request.contactNumber = this.phonenumberController.text.convertToPhoneNumber();
    request.email = this.emailController.text;

    BaseResponse response = await repository.checkEmailAndPhoneNumberApi(params: request);
    _checkEmailAndPhoneOptionSubject.sink.add(response);
  }

  @override
  dispose() {
    super.dispose();
    _firstName.close();
    _lastName.close();
    _phoneNumber.close();
    _email.close();
    _confirmEmail.close();
    _password.close();
    _confirmPassword.close();
    _signupOptionSubject.close();
    _checkEmailAndPhoneOptionSubject.close();
  }
}