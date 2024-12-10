import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:thankxdriver/bloc/profile_detail_bloc.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

// ignore: must_be_immutable
class DriverTab extends StatefulWidget {
  ProfileDetailBloc profileDetailBloc;

  DriverTab({this.profileDetailBloc});

  @override
  _DriverTabState createState() => _DriverTabState();
}

class _DriverTabState extends State<DriverTab> {
  FocusNode yearFocusNode = FocusNode();
  FocusNode modelFocusNode = FocusNode();
  FocusNode makeFocusNode = FocusNode();
  FocusNode licensePlateFocusNode = FocusNode();

  int sliderPosition = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: textFieldContainer(),
    );
  }

  Widget textFieldContainer() {
    List<Widget> imageWidgetList = List();
    if (this.widget.profileDetailBloc.getDriver.photo != null && this.widget.profileDetailBloc.getDriver.photo.isNotEmpty)
      imageWidgetList.add(getImageContainer(this.widget.profileDetailBloc.getDriver.photo));
    if (this.widget.profileDetailBloc.getDriver.photo2 != null && this.widget.profileDetailBloc.getDriver.photo2.isNotEmpty)
      imageWidgetList.add(getImageContainer(this.widget.profileDetailBloc.getDriver.photo2));
    if (this.widget.profileDetailBloc.getDriver.photo3 != null && this.widget.profileDetailBloc.getDriver.photo3.isNotEmpty)
      imageWidgetList.add(getImageContainer(this.widget.profileDetailBloc.getDriver.photo3));
    if (this.widget.profileDetailBloc.getDriver.photo4 != null && this.widget.profileDetailBloc.getDriver.photo4.isNotEmpty)
      imageWidgetList.add(getImageContainer(this.widget.profileDetailBloc.getDriver.photo4));

    return Container(
      color: AppColor.whiteColor,
      padding: EdgeInsets.only(
        top: UIUtills().getProportionalHeight(28),
        left: UIUtills().getProportionalWidth(28),
        right: UIUtills().getProportionalWidth(28),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              List<String> mediaList = List();
              if (this.widget.profileDetailBloc.getDriver.photo != null && this.widget.profileDetailBloc.getDriver.photo.isNotEmpty)
                mediaList.add(this.widget.profileDetailBloc.getDriver.photo);
              if (this.widget.profileDetailBloc.getDriver.photo2 != null && this.widget.profileDetailBloc.getDriver.photo2.isNotEmpty)
                mediaList.add(this.widget.profileDetailBloc.getDriver.photo2);
              if (this.widget.profileDetailBloc.getDriver.photo3 != null && this.widget.profileDetailBloc.getDriver.photo3.isNotEmpty)
                mediaList.add(this.widget.profileDetailBloc.getDriver.photo3);
              if (this.widget.profileDetailBloc.getDriver.photo4 != null && this.widget.profileDetailBloc.getDriver.photo4.isNotEmpty)
                mediaList.add(this.widget.profileDetailBloc.getDriver.photo4);
              Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: sliderPosition)));
            },
            child: ImageSlideshow(
              width: double.infinity,
              height: UIUtills().getProportionalHeight(170),
              initialPage: 0,
              indicatorColor: AppColor.primaryColor,
              indicatorBackgroundColor: Colors.grey,
              children: imageWidgetList,
              onPageChanged: (value) {
                sliderPosition = value;
              },
              autoPlayInterval: 0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(35)),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.yearController,
              enabled: false,
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
                FocusScope.of(context).requestFocus(modelFocusNode);
              },
              labelText: AppTranslations.globalTranslations.yearText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: yearFocusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(20),
            ),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.makeController,
              enabled: false,
              textCapitalization: TextCapitalization.sentences,
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
                FocusScope.of(context).requestFocus(licensePlateFocusNode);
              },
              labelText: AppTranslations.globalTranslations.makeText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: makeFocusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(20),
            ),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.modelController,
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
                FocusScope.of(context).requestFocus(makeFocusNode);
              },
              labelText: AppTranslations.globalTranslations.modelText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: modelFocusNode,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(20),
            ),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.licenseController,
              enabled: false,
              keyboardType: TextInputType.text,
              action: TextInputAction.done,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
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
              labelText: AppTranslations.globalTranslations.licensePlateText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: licensePlateFocusNode,
            ),
          ),
          licenceImageContainer(),
          vehicleRegisterContainer(),
          vehicleInsuranceContainer(),
        ],
      ),
    );
  }

  ClipRRect getImageContainer(String imageURL) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
      child: FadeInImage.assetNetwork(
        fit: BoxFit.cover,
        height: UIUtills().getProportionalHeight(170),
        width: double.infinity,
        placeholder: AppImage.profilePicturePlaceholder,
        image: imageURL ?? "",
      ),
    );
  }

  Widget get licenceFront {
    if (this.widget.profileDetailBloc.getDriver.licenceFront != null && this.widget.profileDetailBloc.getDriver.licenceFront.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          List<String> mediaList = List();
          mediaList.add(this.widget.profileDetailBloc.getDriver.licenceFront ?? "");
          Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            height: UIUtills().getProportionalHeight(120),
            width: UIUtills().getProportionalHeight(150),
            placeholder: AppImage.profilePicturePlaceholder,
            image: this.widget.profileDetailBloc.getDriver.licenceFront ?? "",
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
        child: Container(
            width: UIUtills().getProportionalHeight(150),
            height: UIUtills().getProportionalHeight(120),
            decoration: BoxDecoration(
              color: AppColor.dividerBackgroundColor,
              borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppImage.imagePlaceholder,
              fit: BoxFit.cover,
              width: UIUtills().getProportionalHeight(150),
              height: UIUtills().getProportionalHeight(120),
            )),
      );
    }
  }

  Widget get licenceBack {
    if (this.widget.profileDetailBloc.getDriver.licenceBack != null && this.widget.profileDetailBloc.getDriver.licenceBack.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          List<String> mediaList = List();
          mediaList.add(this.widget.profileDetailBloc.getDriver.licenceBack ?? "");
          Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
          child: FadeInImage.assetNetwork(
            fit: BoxFit.cover,
            height: UIUtills().getProportionalHeight(120),
            width: UIUtills().getProportionalHeight(150),
            placeholder: AppImage.profilePicturePlaceholder,
            image: this.widget.profileDetailBloc.getDriver.licenceBack ?? "",
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
        child: Container(
            width: UIUtills().getProportionalHeight(150),
            height: UIUtills().getProportionalHeight(120),
            decoration: BoxDecoration(
              color: AppColor.dividerBackgroundColor,
              borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              AppImage.imagePlaceholder,
              fit: BoxFit.cover,
              width: UIUtills().getProportionalHeight(150),
              height: UIUtills().getProportionalHeight(120),
            )),
      );
    }
  }

  Widget licenceImageContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(55), bottom: UIUtills().getProportionalHeight(21)),
          child: Text(
            AppTranslations.globalTranslations.licenceImageText,
            style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.34),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  licenceFront,
                  SizedBox(
                    height: UIUtills().getProportionalWidth(5.0),
                  ),
                  Text(
                    AppTranslations.globalTranslations.frontImageText,
                    style: UIUtills().getTextStyle(fontsize: 10, fontName: AppFont.sfProTextRegular, color: AppColor.textColor, characterSpacing: 0.34),
                  )
                ],
              ),
            ),
            SizedBox(
              width: UIUtills().getProportionalWidth(10.0),
            ),
            Expanded(
              child: Column(
                children: [
                  licenceBack,
                  SizedBox(
                    height: UIUtills().getProportionalWidth(5.0),
                  ),
                  Text(
                    AppTranslations.globalTranslations.backImageText,
                    style: UIUtills().getTextStyle(fontsize: 10, fontName: AppFont.sfProTextRegular, color: AppColor.textColor, characterSpacing: 0.34),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget vehicleRegisterContainer() {
    return GestureDetector(
      onTap: () {
        List<String> mediaList = List();
        mediaList.add(this.widget.profileDetailBloc.getDriver.vehicleRegistration);
        Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(60)),
            child: Text(
              AppTranslations.globalTranslations.vehicleRegistrationText,
              style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.35),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(21),
            ),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.registrationController,
              enabled: false,
              keyboardType: TextInputType.phone,
              textType: TextFieldType.usaPhoneNumber,
              action: TextInputAction.next,
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
                FocusScope.of(context).requestFocus(licensePlateFocusNode);
              },
              labelText: AppTranslations.globalTranslations.selectfileText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: makeFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  Widget vehicleInsuranceContainer() {
    return GestureDetector(
      onTap: () {
        List<String> mediaList = List();
        mediaList.add(this.widget.profileDetailBloc.getDriver.vehicleInsurance);
        Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(60)),
            child: Text(
              AppTranslations.globalTranslations.vehicleInsuranceText,
              style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.35),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(21), bottom: UIUtills().getProportionalHeight(48)),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.insuranceController,
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
              onChanged: (s) {
                Focus.of(context).nextFocus();
                setState(() {});
              },
              onEditCompletie: () {
                FocusScope.of(context).requestFocus(licensePlateFocusNode);
              },
              labelText: AppTranslations.globalTranslations.selectfileText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              focusNode: makeFocusNode,
            ),
          ),
        ],
      ),
    );
  }
}
