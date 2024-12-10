import 'package:flutter/material.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/custom/custom_text_field.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

class AddCardPage extends StatefulWidget {
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final FocusNode cardNoFocusNode = FocusNode();
  final FocusNode expFocusNode = FocusNode();
  final FocusNode cvcFocusNode = FocusNode();
  final FocusNode zipCodeFocusNode = FocusNode();

  var textStyle = UIUtills().getTextStyleRegular(
    color: AppColor.addCardTextColor,
    fontSize: 12,
    fontName: AppFont.sfCompactRegular,
  );
  var textStyle1 = UIUtills().getTextStyleRegular(
    color: AppColor.addCardTextColor,
    fontSize: 16,
    fontName: AppFont.sfCompactRegular,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "CANCEL",
                  style: UIUtills().getTextStyle(
                      color: AppColor.textColor,
                      fontName: AppFont.sfProTextSemibold,
                      fontsize: 11,
                      characterSpacing: 0.26),
                ),
              ),
            ),
            Text(
              AppTranslations.globalTranslations.paymentMethodTitle,
              style: UIUtills().getTextStyle(
                characterSpacing: 0.4,
                color: AppColor.appBartextColor,
                fontsize: 17,
                fontName: AppFont.sfProTextSemibold,
              ),
            ),
            Container(
              width: UIUtills().getProportionalWidth(50),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                UIUtills().getProportionalHeight(75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[mainColumn(), button()],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainColumn() {
    return Container(
      margin: EdgeInsets.only(
        top: UIUtills().getProportionalHeight(25),
      ),
      child: textFieldColumn(),
    );
  }

  Widget textFieldColumn() {
    return Container(
      margin: EdgeInsets.only(
        right: UIUtills().getProportionalWidth(27),
        left: UIUtills().getProportionalWidth(27),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(36),
            ),
            child: CommonWidget.createTextField(
                style: textStyle1,
                focusNode: cardNoFocusNode,
                textType: TextFieldType.phoneNumber,
                maxLength: 16,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.cardBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.cardBorderColor),
                  ),
                  prefixIcon: ImageIcon(
                    AssetImage(AppImage.paymentCard),
                    color: AppColor.textColor,
                  ),
                  contentPadding: EdgeInsets.only(
                      top: UIUtills().getProportionalHeight(20.0),
                      left: UIUtills().getProportionalWidth(16),
                      bottom: UIUtills().getProportionalHeight(20)),
                  hintText: AppTranslations.globalTranslations.txtCardNo,
                  hintStyle: textStyle1,
                  labelStyle: textStyle,
                ),
                onEditCompletie: () {
                  FocusScope.of(context).requestFocus(expFocusNode);
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(34)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: UIUtills().getProportionalWidth(175),
                  child: CommonWidget.createTextField(
                      style: textStyle,
                      focusNode: expFocusNode,
                      textType: TextFieldType.cardExpiry,
                      maxLength: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColor.cardBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColor.cardBorderColor),
                        ),
                        prefixIcon: ImageIcon(
                          AssetImage(AppImage.calendar),
                          color: AppColor.textColor,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: UIUtills().getProportionalHeight(22.0),
                            left: UIUtills().getProportionalWidth(16),
                            bottom: UIUtills().getProportionalHeight(22)),
                        hintText: AppTranslations.globalTranslations.txtExp,
                        hintStyle: textStyle,
                        labelStyle: textStyle,
                      ),
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(cvcFocusNode);
                      }),
                ),
                Container(
                  width: UIUtills().getProportionalWidth(131),
                  child: CommonWidget.createTextField(
                      style: textStyle,
                      focusNode: cvcFocusNode,
                      obscureText: true,
                      maxLength: 3,
                      textType: TextFieldType.phoneNumber,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColor.cardBorderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: AppColor.cardBorderColor),
                        ),
                        prefixIcon: ImageIcon(
                          AssetImage(AppImage.lock),
                          color: AppColor.textColor,
                        ),
                        contentPadding: EdgeInsets.only(
                            top: UIUtills().getProportionalHeight(22.0),
                            left: UIUtills().getProportionalWidth(16),
                            bottom: UIUtills().getProportionalHeight(22)),
                        hintText: AppTranslations.globalTranslations.txtCvc,
                        hintStyle: textStyle,
                        labelStyle: textStyle,
                      ),
                      onEditCompletie: () {
                        FocusScope.of(context).requestFocus(zipCodeFocusNode);
                      }),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(34)),
            child: CommonWidget.createTextField(
                style: textStyle,
                focusNode: zipCodeFocusNode,
                textType: TextFieldType.phoneNumber,
                maxLength: 5,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.cardBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.cardBorderColor),
                  ),
//                  prefixIcon: ImageIcon(
//                    AssetImage(AppImage.password),
//                    color: AppColor.addCardIconColor,
//                  ),
                  contentPadding: EdgeInsets.only(
                      top: UIUtills().getProportionalHeight(22.0),
                      left: UIUtills().getProportionalWidth(16),
                      bottom: UIUtills().getProportionalHeight(22)),
                  hintText: AppTranslations.globalTranslations.txtZipCodes,
                  hintStyle: textStyle,
                  labelStyle: textStyle,
                ),
                onEditCompletie: () {
                  FocusScope.of(context).unfocus();
                }),
          ),
        ],
      ),
    );
  }

  Widget button() {
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
          onPressed: () {
            Navigator.of(context).pop();
//            Navigator.push(context, MaterialPageRoute(builder: (context){
//              return ProfilePicturePage();
//            },),);
          },
          textColor: AppColor.textColor,
          fontName: AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonAddPaymentMethod,
        ));
  }
}
