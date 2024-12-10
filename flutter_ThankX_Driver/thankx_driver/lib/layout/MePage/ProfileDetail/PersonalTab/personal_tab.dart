import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/profile_detail_bloc.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class PersonalTab extends StatefulWidget {
  ProfileDetailBloc profileDetailBloc;

  PersonalTab({this.profileDetailBloc});

  @override
  _PersonalTabState createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phonenumberFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode reEnterPasswordFocusNode = FocusNode();

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }

  Widget profilePictureContainer() {
    return Container(
      height: UIUtills().getProportionalWidth(220),
      width: UIUtills().getProportionalWidth(220),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              List<String> mediaList = List();
              mediaList.add(this.widget.profileDetailBloc.userProfile.profilePicture);
              Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: UIUtills().getProportionalWidth(200),
                height: UIUtills().getProportionalWidth(200),
                placeholder: AppImage.profilePicturePlaceholder,
                image: this.widget.profileDetailBloc.userProfile.profilePicture ?? "",
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Visibility(
              visible: (isSelected) ? true : false,
              child: Container(alignment: Alignment.bottomRight, margin: EdgeInsets.only(bottom: 0.0), child: Image.asset(AppImage.closeIcon)),
            ),
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
                    enabled: false,
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
                    enabled: false,
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
                    enabled: false,
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
                    onChanged: (s) {
                      Focus.of(context).nextFocus();
                      setState(() {});
                    },
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
                    controller: this.widget.profileDetailBloc.emailController,
                    enabled: false,
//                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.emailAddress,
                    textType: TextFieldType.email,
                    action: TextInputAction.next,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
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
                      FocusScope.of(context).requestFocus(reEnterPasswordFocusNode);
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
//                Container(
//                  margin: EdgeInsets.only(
//                    top: UIUtills().getProportionalHeight(20),
//                  ),
//                  child: TextFieldWithLabel(
//                    keyboardType: TextInputType.text,
//                    obscureText: true,
//                    action: TextInputAction.done,
//                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(10.0),
//                        bottomRight: Radius.circular(10.0)),
//                    style: UIUtills().getTextStyleRegular(
//                      color: AppColor.textColor,
//                      fontSize: 15,
//                      characterSpacing: 0.4,
//                      fontName: AppFont.sfProTextMedium,
//                    ),
//                    textType: TextFieldType.name,
//                    onChanged: (s) {
////        orderName = s;
//                      setState(() {});
//                    },
//                    onEditCompletie: () {
//                      FocusScope.of(context).unfocus();
//                    },
//                    labelText:
//                        AppTranslations.globalTranslations.reEnterPassword,
//                    labelTextStyle: UIUtills().getTextStyleRegular(
//                      color: AppColor.textColorLight,
//                      fontSize: 15,
//                      characterSpacing: 0.4,
//                      fontName: AppFont.sfProTextMedium,
//                    ),
//                    focusNode: reEnterPasswordFocusNode,
//                  ),
//                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
