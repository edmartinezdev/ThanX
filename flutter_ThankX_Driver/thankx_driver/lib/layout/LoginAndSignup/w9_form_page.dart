import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/add_vehicle_bloc.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/LoginAndSignup/profile_picture_page.dart';
import 'package:thankxdriver/layout/LoginAndSignup/submit_dialog.dart';
import 'package:thankxdriver/layout/LoginAndSignup/submit_form.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/logger.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class W9FormPage extends StatefulWidget {
  AddVehicleBloc addVehicleBloc;
  final bool isInitialPage;
  W9FormPage({this.addVehicleBloc, this.isInitialPage = false});

  @override
  _W9FormPageState createState() => _W9FormPageState();
}



class _W9FormPageState extends State<W9FormPage> {
  FocusNode makeFocusNode = FocusNode();
//  TextEditingController controller = new TextEditingController();
final _scaffoldKey = GlobalKey<ScaffoldState>();
  final CMSBLOC _bloc = CMSBLOC();
  StreamSubscription<CMSResponse> _cmsSubscription;


   _launchInBrowser() async {
    if(this._bloc.cmsModel.w9Form != null) {
      String url = this._bloc.cmsModel.w9Form;
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Could not launch $url';
      }
      this._bloc.downloadW9Controller.text = this._bloc.cmsModel.w9Form;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
            () => this._callApiForCMSDetail());
//    this.widget.addVehicleBloc;
//    controller.text = this.widget.addVehicleBloc.addVehicleInfoModel.w9Form ?? '';
//    print("=========>${controller.text}+==========>${this.widget.addVehicleBloc.addVehicleInfoModel.w9Form}=====");

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: this._willPopCallback,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          title: Text(
            AppTranslations.globalTranslations.screenTitleW9Form,
            style: UIUtills().getTextStyle(
                color: AppColor.appBartextColor, fontsize: 17, fontName: AppFont.sfProTextSemibold
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.whiteColor,
          elevation: 0.5,
        ),
        body: SafeArea(
          bottom: true,
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
        children: <Widget>[downloadFileContainer(), button()],
      ),
    );
  }

  Widget downloadFileContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppTranslations.globalTranslations.downloadText,
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
          child: GestureDetector(onTap: (){
            _launchInBrowser();
          },child: TextFieldWithLabel(
            suffixIcon: ImageIcon(
              AssetImage(AppImage.downloadIcon),
              color: AppColor.textColor,
            ),
            controller: this._bloc.downloadW9Controller,
            enabled: false,
            keyboardType: TextInputType.text,
            textType: TextFieldType.none,
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
            focusNode: makeFocusNode,
          ),),
        ),
      ],
    );
  }

  Widget button() {
    return Container(
        margin: EdgeInsets.only(
//          top: UIUtills().getProportionalWidth(81),
          bottom: UIUtills().getProportionalHeight(20),
        ),
        child: Column(
          children: <Widget>[
            CommonButton(
              height: UIUtills().getProportionalWidth(50),
              width: double.infinity,
              backgroundColor: AppColor.primaryColor,
              onPressed: () {
                var route = MaterialPageRoute(builder: (context) {return SubmitForm();});
                Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
              },
              textColor: AppColor.textColor,
              fontName: AppFont.sfProTextMedium,
              fontsize: 17,
              characterSpacing: 0,
              text: AppTranslations.globalTranslations.buttonNext,
            ),
            Container(
              margin:
                  EdgeInsets.only(top: UIUtills().getProportionalHeight(18)),
              child: GestureDetector(
                onTap: (){
                  var route = MaterialPageRoute(builder: (context) {return SubmitForm();});
                  Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
                },
                child: Text(
                  AppTranslations.globalTranslations.saveAndComeBackLaterText,
                  style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 12,
                      characterSpacing: 1.0,
                      fontName: AppFont.sfProTextMedium),
                ),
              ),
            )
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

  void _callApiForCMSDetail() {
    this._cmsSubscription = this._bloc.cmsResponseStream.listen(
          (CMSResponse response) {
        this._cmsSubscription.cancel();
        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
              () {
            UIUtills().dismissProgressDialog(context);
            if (response.status) {
              setState(() {});
            } else {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            }
          },
        );
      },
    );
    UIUtills().showProgressDialog(context);
    this._bloc.getCMSDetails();
  }
}
