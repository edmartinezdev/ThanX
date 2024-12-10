import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/profile_detail_bloc.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

class UpdatePersonalDetails extends StatefulWidget {
  ProfileDetailBloc profileDetailBloc;

  UpdatePersonalDetails({this.profileDetailBloc});

  @override
  _UpdatePersonalDetailsState createState() => _UpdatePersonalDetailsState();
}

class _UpdatePersonalDetailsState extends State<UpdatePersonalDetails> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phonenumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode reEnterPasswordFocusNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<UserAuthenticationResponse> _editUserProfileSubscription;

  void _handleChooseProfilePhotoAction() {
    if (this.widget.profileDetailBloc.selectedUserPhoto != null) {
      this.widget.profileDetailBloc.selectedUserPhoto = null;
      setState(() {});
    } else if (this.widget.profileDetailBloc.userProfile.profilePicture != null) {
      this.widget.profileDetailBloc.userProfile.profilePicture = null;
      setState(() {});
    } else {
      MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.profile, isImageResize: false, callBack: (file) {
        if (file != null) {
          this.widget.profileDetailBloc.selectedUserPhoto = file;
          setState(() {});
        }
      });
    }
  }

  void _handleEditAction() {
    FocusScope.of(context).unfocus();
    _editProfileAction();
    setState(() {});
  }

  @override
  void dispose() {
    if (this._editUserProfileSubscription != null) {
      this._editUserProfileSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10)),
              child: Center(
                child: Text(
                  "Cancel",
                  style: UIUtills().getTextStyle(
                    characterSpacing: 0.25,
                    color: AppColor.appBartextColor,
                    fontsize: 11,
                    fontName: AppFont.sfProTextSemibold,
                  ),
                ),
              ),
            )),
        title: Text(
          AppTranslations.globalTranslations.profileTitle,
          style: UIUtills().getTextStyle(
            characterSpacing: 0.4,
            color: AppColor.appBartextColor,
            fontsize: 17,
            fontName: AppFont.sfProTextSemibold,
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: this._handleEditAction,
            child: Container(
              margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(20)),
              child: Center(
                child: Text(
                  AppTranslations.globalTranslations.txtSave,
                  style: UIUtills().getTextStyle(
                    characterSpacing: 0.25,
                    color: AppColor.appBartextColor,
                    fontsize: 11,
                    fontName: AppFont.sfProTextSemibold,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: UIUtills().getProportionalHeight(38)),
        children: <Widget>[
          Container(
            color: Colors.transparent,
            width: double.infinity,
            alignment: Alignment.center,
            child: profilePictureContainer(),
          ),
          textFieldContainer()
//            button()
        ],
      ),
    );
  }

  Widget get profilePic {
    final widths = UIUtills().getProportionalWidth(200);
    Widget profilePic;
    if (this.widget.profileDetailBloc.selectedUserPhoto != null) {
      profilePic = GestureDetector(
        onTap: (){
          List<String> mediaList = List();
          mediaList.add(this.widget.profileDetailBloc.selectedUserPhoto.path);
          Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
      },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.file(
            this.widget.profileDetailBloc.selectedUserPhoto,
            width: widths,
            height: widths,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      profilePic = GestureDetector(
        onTap: () {
          if (this.widget.profileDetailBloc.userProfile.profilePicture != null && this.widget.profileDetailBloc.userProfile.profilePicture.isNotEmpty) {
            List<String> mediaList = List();
            mediaList.add(this.widget.profileDetailBloc.userProfile.profilePicture ?? "");
            Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
          } else if (this.widget.profileDetailBloc.selectedUserPhoto != null) {
            List<String> mediaList = List();
            mediaList.add(this.widget.profileDetailBloc.selectedUserPhoto.path);
            Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
          } else {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).requestFocus(new FocusNode());
            _handleChooseProfilePhotoAction();
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage.assetNetwork(
            placeholder: AppImage.profilePicturePlaceholder,
            image: this.widget.profileDetailBloc.userProfile.profilePicture ?? "",
            width: widths,
            height: widths,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return profilePic;
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
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              _handleChooseProfilePhotoAction();
            },
            child: Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(bottom: 0.0),
                child: Image.asset((this.widget.profileDetailBloc.selectedUserPhoto != null || this.widget.profileDetailBloc.userProfile.profilePicture != null)
                    ? AppImage.closeIcon
                    : AppImage.addIcon)),
          ),
        ],
      ),
    );
  }

  Widget textFieldContainer() {
    return Container(
      color: AppColor.whiteColor,
      margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(36), bottom: UIUtills().getProportionalHeight(78)),
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
                    controller: this.widget.profileDetailBloc.firstNameController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    textType: TextFieldType.name,
                    action: TextInputAction.next,
                    onChanged: (s) {
                      Focus.of(context).nextFocus();
                      setState(() {});
                    },
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
                    controller: this.widget.profileDetailBloc.lastNameController,
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
                    onChanged: (s) {
                      Focus.of(context).nextFocus();
                      setState(() {});
                    },
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
                    controller: this.widget.profileDetailBloc.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    textType: TextFieldType.usaPhoneNumber,
                    action: TextInputAction.done,
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColor,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    onChanged: (s) {
                      Focus.of(context).nextFocus();
                      setState(() {});
                    },
                    onEditCompletie: () {
                      FocusScope.of(context).unfocus();
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
                    controller: this.widget.profileDetailBloc.emailController,
                    enabled: false,
//                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.emailAddress,
                    textType: TextFieldType.email,
                    action: TextInputAction.next,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    style: UIUtills().getTextStyleRegular(
                      color: AppColor.textColorLight,
                      fontSize: 15,
                      characterSpacing: 0.4,
                      fontName: AppFont.sfProTextMedium,
                    ),
                    onChanged: (s) {
                      Focus.of(context).nextFocus();
                      setState(() {});
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editProfileAction() {
    // dismiss key board
    FocusScope.of(context).unfocus();

    final validationResult = this.widget.profileDetailBloc.isValidForm();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }
    setState(() {});
    this._editUserProfileSubscription = this.widget.profileDetailBloc.editProfileStream.listen((UserAuthenticationResponse response) {
      this._editUserProfileSubscription.cancel();
      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);
        if (!response.status) {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        } else {
          this.widget.profileDetailBloc.userProfile.profilePicture = response.data.profilePicture;
          this.widget.profileDetailBloc.userProfile.firstname = response.data.firstname;
          this.widget.profileDetailBloc.userProfile.lastname = response.data.lastname;
          this.widget.profileDetailBloc.userProfile.contactNumber = response.data.contactNumber;
          Utils.showAlert(context,
              message: response.message, arrButton: [AppTranslations.globalTranslations.buttonOk], callback: (_) => Navigator.of(context).pop());
        }
      });
    });
    this.widget.profileDetailBloc.callEditUserProfileApi();
    UIUtills().showProgressDialog(context);
  }
}
