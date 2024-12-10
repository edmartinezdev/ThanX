import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/add_vehicle_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/LoginAndSignup/submit_dialog.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

enum SelectionType {
  w9Form
}
class SubmitForm extends StatefulWidget {
  @override
  _SubmitFormState createState() => _SubmitFormState();
}


class _SubmitFormState extends State<SubmitForm> {

  AddVehicleBloc _w9Formbloc = AddVehicleBloc();
  StreamSubscription<BaseResponse> subscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  void getFilePath(SelectionType type) async {
    try {
      if (type == SelectionType.w9Form) {
//        String filePath = await FilePicker.getFilePath(type: FileType.custom, allowedExtensions: ["pdf","jpg","jpeg"]);

        String filePath;
        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
          if (file != null) {
            filePath = file.path;
            print("File "+ filePath);
            if ((filePath != null) && (filePath.isNotEmpty)) {
              this._w9Formbloc.w9Form = File(filePath);
              this._w9Formbloc.w9FormController.text = Path.basename(filePath);
            }

            setState(() {});
          }
        });

//        if ((filePath != null) && (filePath.isNotEmpty)) {
//          this._w9Formbloc.w9Form = File(filePath);
//          this._w9Formbloc.w9FormController.text = Path.basename(filePath);
//        }
      }
      setState(() {});
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_willPopCallback,
      child:  Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          leading: Container(),
          title: Text(
            AppTranslations.globalTranslations.screenTitleW9Form,
            style: UIUtills().getTextStyle(
                color: AppColor.appBartextColor,
                fontsize: 17,
                fontName: AppFont.sfProTextSemibold),
          ),
          centerTitle: true,
          backgroundColor: AppColor.whiteColor,
          elevation: 0.5,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: textFieldContainer(),
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    Logger().v("Open Alert for Option");
    Utils.showAlert(
      context,
      message: "Are you sure you want to exit from app?",
      arrButton: ["Cancel",AppTranslations.globalTranslations.btnOK],
      callback: (int index) {
        if(index == 1) {
          SystemNavigator.pop();
        }
      },
    );
    return false;
  }

  Widget textFieldContainer() {
    return Container(
      height: MediaQuery.of(context).size.height -
          UIUtills().getProportionalHeight(100),
      color: AppColor.whiteColor,
      padding: EdgeInsets.only(
        top: UIUtills().getProportionalHeight(28),
        left: UIUtills().getProportionalWidth(28),
        right: UIUtills().getProportionalWidth(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[uploadFileContainer(), button()],
      ),
    );
  }

  Widget uploadFileContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppTranslations.globalTranslations.buttonSubmit,
          style: UIUtills().getTextStyle(
              fontsize: 14,
              fontName: AppFont.sfProTextSemibold,
              color: AppColor.textColor,
              characterSpacing: 0.35),
        ),
        Container(
          margin: EdgeInsets.only(
            top: UIUtills().getProportionalHeight(21),
          ),
          child:GestureDetector(onTap: (){
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(new FocusNode());
            getFilePath(SelectionType.w9Form);
          },child:  TextFieldWithLabel(
            controller: this._w9Formbloc.w9FormController,
            suffixIcon: ImageIcon(
              AssetImage(AppImage.uploadIcon),
              color: AppColor.textColor,
            ),
            keyboardType: TextInputType.text,
            textType: TextFieldType.none,
            enabled: false,
            action: TextInputAction.next,
            style: UIUtills().getTextStyleRegular(
              color: AppColor.textColor,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
            onEditCompletie: () {
              FocusScope.of(context).unfocus();
            },
            labelText: AppTranslations.globalTranslations.selectfileText,
            labelTextStyle: UIUtills().getTextStyleRegular(
              color: AppColor.textColorLight,
              fontSize: 15,
              characterSpacing: 0.4,
              fontName: AppFont.sfProTextMedium,
            ),
//            focusNode: makeFocusNode,
          ),),
        ),
      ],
    );
  }

  Widget button() {
    return Container(
        margin: EdgeInsets.only(
          bottom: UIUtills().getProportionalHeight(48),
        ),
        child: Column(
          children: <Widget>[
            CommonButton(
              height: UIUtills().getProportionalWidth(50),
              width: double.infinity,
              backgroundColor: AppColor.primaryColor,
              onPressed: () {
                _addW9FormApi();
              },
              textColor: AppColor.textColor,
              fontName: AppFont.sfProTextMedium,
              fontsize: 17,
              characterSpacing: 0,
              text: AppTranslations.globalTranslations.buttonSubmit,
            ),
//            Container(
//              margin: EdgeInsets.only(
//                  top: UIUtills().getProportionalHeight(18),
//                  left: UIUtills().getProportionalWidth(64),
//                  right: UIUtills().getProportionalWidth(64)),
//              child: GestureDetector(
//                child: Text(
//                  "By clicking Submit, you agree to our Privacy Policy and Terms & Conditions.",
//                  textAlign: TextAlign.center,
//                  style: UIUtills().getTextStyle(
//                      fontName: AppFont.sfProDisplayRegular,
//                      color: AppColor.textColor,
//                      fontsize: 10,
//                      characterSpacing: 1.0),
//                ),
//              ),
//            )
          ],
        ));
  }

  void submitDialog() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (BuildContext bc) {
          return SubmitDialog();
        });
  }




  void _addW9FormApi() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    if (this._w9Formbloc.w9Form == null) {
      Utils.showSnakBarwithKey(_scaffoldKey, 'Please attach W9 form.');
      return;
    }
    
    // Validate Form
    this.subscription = this._w9Formbloc.addW9FormOptionStream.listen((BaseResponse response) {
      this.subscription.cancel();

      Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
              () {
            UIUtills().dismissProgressDialog(context);

            if (response.status) {
              submitDialog();
            } else {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            }
          });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._w9Formbloc.callAddW9FormApi();
  }
}
