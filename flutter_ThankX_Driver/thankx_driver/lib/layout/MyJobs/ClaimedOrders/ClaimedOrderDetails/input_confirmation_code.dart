import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thankxdriver/bloc/order_tracking_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/pin_entry.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

typedef VoidCallbackString(String i);
typedef VoidCallBackMultipart(File imageFile,String pin,String dropOffMessage);

class InputConfirmationCode extends StatefulWidget {

  VoidCallbackString onPinEntered;
  VoidCallBackMultipart onNoAtHomeDropOff;
  OrderDetailsData order;
  BuildContext contx;
  OrderTrackingBloc bloc;

  InputConfirmationCode({this.onPinEntered,this.contx,this.order,this.onNoAtHomeDropOff,this.bloc});
  @override
  _InputConfirmationCodeState createState() => _InputConfirmationCodeState();

}

class _InputConfirmationCodeState extends State<InputConfirmationCode> {
  String pintext = "";
  int currentStep = 1 ;
  File imageFile ;
  TextEditingController dropOffMessageController = TextEditingController();

  Widget get divider=>Container(
    height: 0.5,
    width: double.infinity,
    color: AppColor.dividerColor,
    margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(10)),
  );

  @override
  void dispose() {
    dropOffMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentStep ==1  ? getConfirmationCodeWidget() : getNotAtHomeWidget();
  }

  getConfirmationCodeWidget(){
   return Container(
      decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),top: UIUtills().getProportionalWidth(10)+MediaQuery.of(context).viewPadding.top,bottom: UIUtills().getProportionalHeight(20)+MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(20),vertical: UIUtills().getProportionalHeight(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppTranslations.globalTranslations.InputDeliveryCode,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextRegular,color: AppColor.textColor,fontSize: 12),),
          SizedBox(height: UIUtills().getProportionalHeight(15),),
          divider,
          getPinTextField(),
          CommonButton(
            height: UIUtills().getProportionalWidth(38),
            width: double.infinity,
            backgroundColor: AppColor.primaryColor,
            onPressed: (){
              if(this.widget.order.atHome){
                this.widget.onPinEntered(pintext);
              }else{
                this.widget.bloc.pinText = pintext;
                var validationResult = this.widget.bloc.isValidDropOffPin();
                if(!validationResult.item1){
                  Utils.showAlert(this.widget.contx,message: validationResult.item2,arrButton: ["Ok"],callback: (i){
//        NavigationService().pop();
                  });
                  return;
                }else{
                  currentStep = 2;
                  setState(() {});
                }
              }
            },
            textColor: AppColor.textColor,
            fontName:AppFont.sfProTextSemibold,
            fontsize: 12,
            text: (this.widget.order.atHome)?AppTranslations.globalTranslations.ConfirmDelivery:AppTranslations.globalTranslations.buttonNext,
            characterSpacing: 0,
          ),
        ],
      ),
    );
  }

  getNotAtHomeWidget(){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        height: getHeight(),
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        margin: EdgeInsets.only(left: UIUtills().getProportionalWidth(10),right: UIUtills().getProportionalWidth(10),top: UIUtills().getProportionalWidth(30),bottom: UIUtills().getProportionalHeight(20)+MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: UIUtills().getProportionalHeight(20),),
              Text(AppTranslations.globalTranslations.dropOffDetails,style: UIUtills().getTextStyleRegular(fontName: AppFont.sfProTextRegular,color: AppColor.textColor,fontSize: 12),),
              SizedBox(height: UIUtills().getProportionalHeight(15),),
              divider,
              Container(
                margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(40)),
                child: vehiclePictureContainer(),
              ),
              Container(
                margin: EdgeInsets.only(left:UIUtills().getProportionalWidth(4),right: UIUtills().getProportionalWidth(4),top: UIUtills().getProportionalWidth(40),bottom: UIUtills().getProportionalWidth(30)),
                height: UIUtills().getProportionalWidth(120),
                child: TextFieldWithLabel(
                  keyboardType: TextInputType.multiline,
                  contentPadding: EdgeInsets.all(UIUtills().getProportionalWidth(16)),
                  textCapitalization: TextCapitalization.sentences,
                  controller: dropOffMessageController,
                  action: TextInputAction.newline,
                  style: UIUtills().getTextStyleRegular(
                    color: AppColor.textColor,
                    fontSize: 15,
                    characterSpacing: 0.4,
                    fontName: AppFont.sfProTextMedium,
                  ),
                  maxLines:30,
                  maxLength: 280,
                  onEditCompletie: (){
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  hintText: "Add message",
                  labelTextStyle: UIUtills().getTextStyleRegular(
                    color: AppColor.textColorLight,
                    fontSize: 15,
                    characterSpacing: 0.4,
                    fontName: AppFont.sfProTextMedium,
                  ),
                ),
              ),
              CommonButton(
                height: UIUtills().getProportionalWidth(38),
                width: double.infinity,
                backgroundColor: AppColor.primaryColor,
                onPressed: (){
                  this.widget.onNoAtHomeDropOff(imageFile,pintext,dropOffMessageController.text);
                },
                textColor: AppColor.textColor,
                fontName:AppFont.sfProTextSemibold,
                fontsize: 12,
                text: "Send",
                characterSpacing: 0,
              ),
              SizedBox(height: UIUtills().getProportionalHeight(20),),
            ],
          ),
        ),
      ),
    );
  }


  Widget get profilePic {
    final widths = UIUtills().getProportionalHeight(170);
    Widget profilePic;
    if (imageFile != null) {
      profilePic = ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.file(
          imageFile,
          width: double.infinity,
          height: widths,
          fit: BoxFit.cover,
        ),
      );
    } else {
      profilePic = ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
              alignment: Alignment.center,
              height: UIUtills().getProportionalHeight(170),
              decoration: BoxDecoration(
                  color: AppColor.profilePicBackGroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ))));
    }
    return profilePic;
  }

  void _handleChooseProfilePhotoAction() {
    MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
      if (file != null) {
        imageFile = file;
        setState(() {});
      }
      },
    );
    setState(() {});
  }

  Widget vehiclePictureContainer() {
    return  Stack(
      children: <Widget>[
        GestureDetector(onTap: (){
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(new FocusNode());
          _handleChooseProfilePhotoAction();
        },
          child: profilePic,
        ),
        GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              _handleChooseProfilePhotoAction();
            },
            child: Container(
                margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(50)),
                alignment: Alignment.center,
                child: (imageFile != null)?Container() : Image.asset(AppImage.plusIcon))

        ),

        Positioned(
            child: Container(
                margin: EdgeInsets.only(
                    top: UIUtills().getProportionalHeight(30)),
                alignment: Alignment.center,
                child:(imageFile != null)?Container() : Text("Add Image",style: UIUtills().getTextStyleRegular(color: AppColor.textColorLight, fontSize: 14,characterSpacing: 0.4, fontName: AppFont.sfProTextMedium,),
                ))
        )

      ],
    );
  }


  getPinTextField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: UIUtills().getProportionalWidth(42),vertical: UIUtills().getProportionalWidth(60)),
      child: PinEntryTextField(
        showFieldAsBox: true,
//        onSubmit: (String pin){
//          pintext = pin;
//          setState(() {});
//        }, // end onSubmit
      onChanged: (str){
        pintext = str;
        setState(() {});
      },
      ),
    );

  }

  getHeight() {

    if(MediaQuery.of(context).viewInsets.bottom > 0){
      return MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - UIUtills().getProportionalWidth(40);
    }
    else return UIUtills().getProportionalWidth(10)+ UIUtills().getProportionalHeight(10)+MediaQuery.of(context).viewInsets.bottom +UIUtills().getProportionalHeight(20)+UIUtills().getProportionalHeight(20) +UIUtills().getProportionalWidth(40)+UIUtills().getProportionalWidth(40)+ UIUtills().getProportionalWidth(30) +UIUtills().getProportionalWidth(120)+UIUtills().getProportionalHeight(170) +UIUtills().getProportionalWidth(38)+ UIUtills().getProportionalWidth(20);
  }


}
