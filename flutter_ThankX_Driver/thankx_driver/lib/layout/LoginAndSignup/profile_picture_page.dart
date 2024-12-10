import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/cms_bloc.dart';
import 'package:thankxdriver/bloc/signup_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/navigation_serviece.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/layout/LoginAndSignup/vehicle_page.dart';
import 'package:thankxdriver/layout/MePage/WebViewPage/web_page.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

import '../../api_provider/all_response.dart';
import '../../utils/enum.dart';
import '../../utils/media_selector.dart';

// ignore: must_be_immutable
class ProfilePicturePage extends StatefulWidget {
  SignUpBloc signUpBloc;

  ProfilePicturePage({this.signUpBloc});

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> with AfterLayoutMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SignUpBloc _bloc;
  bool isWarningShown = false;
  StreamSubscription<UserAuthenticationResponse> subscription;

  final CMSBLOC _cmsbloc = CMSBLOC();
  StreamSubscription<CMSResponse> _cmsSubscription;

  File imageFile;

  void _handleChooseProfilePhotoAction() {
    if (this._bloc.imageFile != null) {
      Utils.showAlert(
        context,
        message: AppTranslations.globalTranslations.msgRemovePhoto,
        arrButton: [AppTranslations.globalTranslations.buttonCancel, AppTranslations.globalTranslations.btnOK],
        callback: (int index) {
          if (index == 1) {
            this._bloc.imageFile = null;
            setState(() {});
          }
        },
      );
    } else {
      showImageWarningDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    _bloc = this.widget.signUpBloc;
  }

  @override
  void dispose() {
    if (this._cmsSubscription != null) _cmsSubscription.cancel();
    _cmsbloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              NavigationService().pop();
            },
            child: Image.asset(AppImage.backArrow),
          ),
          title: Text(
            AppTranslations.globalTranslations.screenTitleProfilePicture,
            style: UIUtills().getTextStyle(color: AppColor.appBartextColor, fontsize: 17, fontName: AppFont.sfProTextSemibold),
          ),
          centerTitle: true,
          backgroundColor: AppColor.whiteColor,
          elevation: 0.5,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: AppColor.whiteColor,
          child: SafeArea(
            bottom: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[Container(), profilePictureContainer(), button()],
            ),
          ),
        ));
  }

  Widget get profilePic {
    final widths = UIUtills().getProportionalWidth(200);
    Widget profilePic;
    if (this._bloc.imageFile != null) {
      profilePic = GestureDetector(
        onTap: () {
          List<String> mediaList = List();
          mediaList.add(this._bloc.imageFile.path);
          Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(
            this._bloc.imageFile,
            width: widths,
            height: widths,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      profilePic = GestureDetector(
        onTap: () {
          showImageWarningDialog();
        },
        child: Image.asset(
          AppImage.profilePicturePlaceholder,
          width: widths,
          height: widths,
          fit: BoxFit.cover,
        ),
      );
    }
    return profilePic;
  }

  void selectImage() {
    MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.profile, isImageResize: false, callBack: (file) {
      if (file != null) {
        this._bloc.imageFile = file;
        setState(() {});
      }
    });
  }

  void showImageWarningDialog() {
    if (!isWarningShown) {
      Utils.showAlert(
        context,
        message: AppTranslations.globalTranslations.msgPhotoWarningMessage,
        barrierDismissible: false,
        arrButton: [AppTranslations.globalTranslations.btnOK],
        callback: (int index) {
          isWarningShown = true;
          selectImage();
        },
      );
    } else {
      selectImage();
    }
  }

  Widget profilePictureContainer() {
    return Container(
      height: UIUtills().getProportionalWidth(220),
      width: UIUtills().getProportionalWidth(220),
      child: Stack(
        children: <Widget>[
          profilePic,
          GestureDetector(
            onTap: () {
              _handleChooseProfilePhotoAction();
            },
            child: Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 0.0),
                child: (this._bloc.imageFile != null) ? Image.asset(AppImage.closeIcon) : Image.asset(AppImage.addIcon)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return Column(
      children: <Widget>[
        CommonButton(
          margin: EdgeInsets.only(
            left: UIUtills().getProportionalWidth(28),
            right: UIUtills().getProportionalWidth(28),
          ),
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            _clickOnCreateAccount();
          },
          textColor: AppColor.textColor,
          fontName: AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonNext,
        ),
        InkWell(
          onTap: () {
            _callApiForCMSDetail();
          },
          child: Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(10),
              bottom: UIUtills().getProportionalHeight(20),
            ),
            child: Text(
              AppTranslations.globalTranslations.strTermsAndConditions,
              textAlign: TextAlign.center,
              style: UIUtills().getTextStyleRegular(color: AppColor.textColor, fontSize: 12, characterSpacing: 0.0, fontName: AppFont.sfProTextMedium),
            ),
          ),
        )
      ],
    );
  }

  void _clickOnCreateAccount() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    // Validate Form
    this.subscription = this._bloc.signupOptionStream.listen((UserAuthenticationResponse response) {
      this.subscription.cancel();
      if (imageFile != null) {
        this._bloc.request.selectedFile = imageFile;
      }
      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);
        if (response.status) {
          var route = MaterialPageRoute(builder: (context) {
            return VehiclePage();
          });
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        } else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
      });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._bloc.callSignUpApi();
  }

  void _callApiForCMSDetail() {
    this._cmsSubscription = this._cmsbloc.cmsResponseStream.listen(
      (CMSResponse response) {
        this._cmsSubscription.cancel();

        Future.delayed(
          Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond),
          () {
            UIUtills().dismissProgressDialog(context);
            if (response.status) {
              NavigationService().push(
                MaterialPageRoute(
                  builder: (_) => WebViewPage(
                    webViewType: WebViewType.termsCondition,
                  ),
                ),
              );
              setState(() {});
            } else {
              Utils.showSnakBarwithKey(_scaffoldKey, response.message);
            }
          },
        );
      },
    );
    UIUtills().showProgressDialog(context);
    this._cmsbloc.getCMSDetails();
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
