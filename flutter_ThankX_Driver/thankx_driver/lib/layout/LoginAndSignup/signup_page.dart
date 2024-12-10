import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/signup_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/LoginAndSignup/profile_picture_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';
import 'package:thankxdriver/utils/string_extension.dart';

import '../../api_provider/all_response.dart';
class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SignUpBloc _bloc = SignUpBloc();
  StreamSubscription<BaseResponse> subscription;

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phonenumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode confirmEmailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode reEnterPasswordFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc;
    firstNameFocusNode.addListener(() => setState(() {}));
    lastNameFocusNode.addListener(() => setState(() {}));
    phonenumberFocusNode.addListener(() => setState(() {}));
    emailFocusNode.addListener(() => setState(() {}));
    confirmEmailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
    reEnterPasswordFocusNode.addListener(() => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColor.whiteColor,
    key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            NavigationService().pop();
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(AppTranslations.globalTranslations.screenTitlePersonalInfo, style: UIUtills().getTextStyle(
            color: AppColor.appBartextColor,
            fontsize: 17,
            fontName: AppFont.sfProTextSemibold
        ),),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: Container(color: AppColor.whiteColor,child: SingleChildScrollView(child: textFieldContainer(),),),
    );
  }

  Widget textFieldContainer() {
    return Container(
      color: AppColor.whiteColor,
      child: Column(
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
                    onChanged: this._bloc.firstName,
                    controller: this._bloc.firstNameController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
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
                      FocusScope.of(context).requestFocus(lastNameFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.firstNameText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: firstNameFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.lastName,
                    controller: this._bloc.lastNameController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
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
                      FocusScope.of(context).requestFocus(phonenumberFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.lastNameText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: lastNameFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.phoneNumber,
                    controller: this._bloc.phonenumberController,
                    keyboardType: TextInputType.phone,
                    textType: TextFieldType.usaPhoneNumber,
                    action: TextInputAction.next,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.phoneNumberText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: phonenumberFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.email,
                    controller: this._bloc.emailController,
//                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.emailAddress,
                    textType: TextFieldType.email,
                    action: TextInputAction.next,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    onEditCompletie: () {
                      FocusScope.of(context).requestFocus(confirmEmailFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.emailText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: emailFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.confirmEmail,
//                    textCapitalization: TextCapitalization.words,
                    controller: this._bloc.confirmEmailController,
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
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.confirmEmailText,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: confirmEmailFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.password,
                    controller: this._bloc.passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
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
                      FocusScope.of(context).requestFocus(reEnterPasswordFocusNode);
                    },
                    labelText: AppTranslations.globalTranslations.password,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: passwordFocusNode,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(20),
                  ),
                  child: TextFieldWithLabel(
                    onChanged: this._bloc.confirmPassword,
                    controller: this._bloc.reEnterPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
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
                    textType: TextFieldType.none,
                    onEditCompletie: () {
                      FocusScope.of(context).unfocus();
                    },
                    labelText: AppTranslations.globalTranslations.reEnterPassword,
                    labelTextStyle: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    focusNode: reEnterPasswordFocusNode,
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
          top: UIUtills().getProportionalWidth(100),
          bottom: UIUtills().getProportionalHeight(48),
          left: UIUtills().getProportionalWidth(28),
          right: UIUtills().getProportionalWidth(28),
        ),
        child: CommonButton(
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: (){
            _checkEmialAndPhoneApi();
          },
          textColor: AppColor.textColor,
          fontName:AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonNext,
        ));
  }



  void _checkEmialAndPhoneApi() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    // Validate Form
    final validationResult = this._bloc.isValidForm();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }
    this.subscription = this._bloc.checkEmailAndPhoneOptionStream.listen((BaseResponse response) {
      this.subscription.cancel();

      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);

        if (response.status) {
          _bloc.request.firstname = this._bloc.firstNameController.text;
          _bloc.request.lastname = this._bloc.lastNameController.text;
          _bloc.request.contactNumber = this._bloc.phonenumberController.text.convertToPhoneNumber();
          _bloc.request.email = this._bloc.emailController.text;
          _bloc.request.password = this._bloc.passwordController.text;
          var route = MaterialPageRoute(builder: (_) => ProfilePicturePage(signUpBloc: this._bloc,));
          Navigator.of(context).push(route);
//          NavigationService().push(route);
        } else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
      });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._bloc.checkEmailAndPhoneApi();
  }
}
