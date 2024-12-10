import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/forgot_password_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import '../../api_provider/all_response.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ForgotPasswordBloc _bloc  = ForgotPasswordBloc();
  StreamSubscription<BaseResponse> subscription;

  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    this._bloc.dispose();
    if (this.subscription != null) {
      this.subscription.cancel();
    }
    this.emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            NavigationService().pop();
          },
          child: Image.asset(AppImage.backArrow),
        ),
        title: Text(
          AppTranslations.globalTranslations.screenTitleForgotPassword,
          style: UIUtills().getTextStyle(
              color: AppColor.appBartextColor,
              fontsize: 17,
              fontName: AppFont.sfProTextSemibold),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child:  Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height-75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    mainContainer(),
                    button()
                  ],
                ),
              ),
            ),
          )

        ],
      ),),

    );
  }


  Widget mainContainer(){
    return Container(
      margin: EdgeInsets.only(
        top: UIUtills().getProportionalHeight(28),
        left: UIUtills().getProportionalWidth(28),
        right: UIUtills().getProportionalWidth(28),

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextFieldWithLabel(
            onChanged: this._bloc.email,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.done,
//              borderRadius: BorderRadius.only(
//                  bottomLeft: Radius.circular(10.0),
//                  bottomRight: Radius.circular(10.0)),
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            textType: TextFieldType.email,
            onEditCompletie: () {
              FocusScope.of(context).unfocus();
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
        ],
      ),
    );
  }


  Widget button(){
    return Container(
        margin: EdgeInsets.only(
          bottom: UIUtills().getProportionalHeight(48),
          left: UIUtills().getProportionalWidth(28),
          right: UIUtills().getProportionalWidth(28),
        ),
        child: CommonButton(
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: (){
            _forgortPasswordApiCall();
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return LoginPage();
//        },),);
          },
          textColor: AppColor.textColor,
          fontName:AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonSubmit,
        ));
  }
  void _forgortPasswordApiCall() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    final validationResult = this._bloc.isValidForm();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }

    // Validate Form
    this.subscription = this._bloc.forgotPasswordStream.listen((BaseResponse response){
      this.subscription.cancel();

      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);

        if (response.status) {
          Utils.showAlert(context, message: response.message, arrButton: [AppTranslations.globalTranslations.buttonOk], callback: (_) => NavigationService().pop());
        }
        else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
      });



    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._bloc.callForgotPasswordApi();
  }

}
