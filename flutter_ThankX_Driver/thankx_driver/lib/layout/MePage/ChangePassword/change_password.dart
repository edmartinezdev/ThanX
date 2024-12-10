import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';
import 'package:thankxdriver/bloc/change_password_bloc.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmNewPasswordFocusNode = FocusNode();

  ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();
  StreamSubscription<BaseResponse> _changePasswordSubscription;


  TextEditingController currentPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    oldPasswordFocusNode.addListener(() => setState(() {}));
    newPasswordFocusNode.addListener(() => setState(() {}));
    confirmNewPasswordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {

    _changePasswordSubscription?.cancel();

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget get createSaveChangesButton {
    return Container(
        margin: EdgeInsets.only(
          top: UIUtills().getProportionalWidth(20),
        ),
        child: CommonButton(
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            onChangePasswordClick();
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) {
//                  return ProfilePicturePage();
//                },
//              ),
//            );
          },
          textColor: AppColor.textColor,
          fontName: AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.changePasswordTitle,
        ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(AppImage.backArrow),
          ),
          title: Text(
            AppTranslations.globalTranslations.changePasswordTitle,
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
        body: GestureDetector(
          child: ListView(
            padding: EdgeInsets.only(
                top: UIUtills().getProportionalHeight(38),
                right: UIUtills().getProportionalWidth(16),
                left: UIUtills().getProportionalWidth(16)),
            children: <Widget>[
              textFieldContainer(),
              this.createSaveChangesButton,
            ],
          ),
          onTap: () => FocusScope.of(context).unfocus(),
        ),
        backgroundColor: AppColor.whiteColor);
  }

  Widget textFieldContainer() {
    return Column(
      children: <Widget>[
        Container(
          child: TextFieldWithLabel(
            controller: currentPasswordController,
            keyboardType: TextInputType.text,
            obscureText: true,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            textType: TextFieldType.none,
            action: TextInputAction.next,
            onChanged: (s) {
              Focus.of(context).nextFocus();
              setState(() {});
            },
            onEditCompletie: () {
              FocusScope.of(context).requestFocus(newPasswordFocusNode);
            },
            labelText: AppTranslations.globalTranslations.oldPasswordText,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            focusNode: oldPasswordFocusNode,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(20),
          ),
          child: TextFieldWithLabel(
            controller: newPasswordController,
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
            onChanged: (s) {
              Focus.of(context).nextFocus();
              setState(() {});
            },
            onEditCompletie: () {
              FocusScope.of(context).requestFocus(confirmNewPasswordFocusNode);
            },
            labelText: AppTranslations.globalTranslations.newPasswordText,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            focusNode: newPasswordFocusNode,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(20),
          ),
          child: TextFieldWithLabel(
            controller: confirmPasswordController,
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
            onChanged: (s) {
//        orderName = s;
              setState(() {});
            },
            onEditCompletie: () {
              FocusScope.of(context).unfocus();
            },
            labelText:
            AppTranslations.globalTranslations.confirmNewPasswordText,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            focusNode: confirmNewPasswordFocusNode,
          ),
        ),
      ],
    );
  }

  void onChangePasswordClick() {

    /* Resign keyboard focus */
    FocusScope.of(context).requestFocus(FocusNode());

    final validationResult = _changePasswordBloc.isValidPassword(currentPasswordController.text,newPasswordController.text,confirmPasswordController.text);
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }
//    widget.isApicallRunning = true;
    if (this.mounted) { setState(() {}); }
    _changePasswordSubscription = _changePasswordBloc.changePasswordStream.listen((BaseResponse response) {
      _changePasswordSubscription.cancel();
//      widget.isApicallRunning = false;
      if (this.mounted) { setState(() {}); }
      if (!response.status) {
        Future.delayed(Duration(milliseconds: 100), () => Utils.showSnakBarwithKey(_scaffoldKey, response.message) );
      } else{
        setState(() {
          currentPasswordController.text = '';
          newPasswordController.text = '';
          confirmPasswordController.text = '';
        });
        Utils.showAlert(context, message: response.message, arrButton: [AppTranslations.globalTranslations.btnOK], callback: (_) => Navigator.of(context).pop() );
      }
    });
    _changePasswordBloc.changePasswordApi(currentPasswordController.text,newPasswordController.text);
  }


}
