import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/profile_detail_bloc.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/vehicle_images_model.dart';
import 'package:thankxdriver/utils/app_color.dart';
import 'package:thankxdriver/utils/app_font.dart';
import 'package:thankxdriver/utils/app_image.dart';
import 'package:thankxdriver/utils/enum.dart';
import 'package:thankxdriver/utils/media_selector.dart';
import 'package:thankxdriver/utils/ui_utils.dart';
import 'package:thankxdriver/utils/utils.dart';

enum SelectionType {
  registration,
  insurance,
}

// ignore: must_be_immutable
class UpdateDriverDetails extends StatefulWidget {
  ProfileDetailBloc profileDetailBloc;

  UpdateDriverDetails({this.profileDetailBloc});

  @override
  _UpdateDriverDetailsState createState() => _UpdateDriverDetailsState();
}

class _UpdateDriverDetailsState extends State<UpdateDriverDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<GetDriverResponse> _editDriverSubscription;

  FocusNode yearFocusNode = FocusNode();
  FocusNode modelFocusNode = FocusNode();
  FocusNode makeFocusNode = FocusNode();
  FocusNode licensePlateFocusNode = FocusNode();

  void getFilePath(SelectionType type) async {
    try {
      if (type == SelectionType.registration) {
        String filePath;
        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
          if (file != null) {
            filePath = file.path;
            print("File " + filePath);
            if ((filePath != null) && (filePath.isNotEmpty)) {
              this.widget.profileDetailBloc.registrationPDf.isLocalFile = true;
              this.widget.profileDetailBloc.registrationPDf.file = File(filePath);
              this.widget.profileDetailBloc.registrationController.text = Path.basename(filePath);
            }
            setState(() {});
          }
        });
      } else if (type == SelectionType.insurance) {
        String filePath;
        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
          if (file != null) {
            filePath = file.path;
            print("File " + filePath);
            if ((filePath != null) && (filePath.isNotEmpty)) {
              this.widget.profileDetailBloc.insurancePDF.isLocalFile = true;
              this.widget.profileDetailBloc.insurancePDF.file = File(filePath);
              this.widget.profileDetailBloc.insuranceController.text = Path.basename(filePath);
            }
            setState(() {});
          }
        });
      }
      setState(() {});
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  void _handleEditAction() {
    FocusScope.of(context).unfocus();
    _editDriverAction();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    if (_editDriverSubscription != null) _editDriverSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    this.widget.profileDetailBloc.vehicleImages = List();
    this
        .widget
        .profileDetailBloc
        .vehicleImages
        .add(VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.photo ?? "", isLocalFile: false));
    this
        .widget
        .profileDetailBloc
        .vehicleImages
        .add(VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.photo2 ?? "", isLocalFile: false));
    this
        .widget
        .profileDetailBloc
        .vehicleImages
        .add(VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.photo3 ?? "", isLocalFile: false));
    this
        .widget
        .profileDetailBloc
        .vehicleImages
        .add(VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.photo4 ?? "", isLocalFile: false));

    this.widget.profileDetailBloc.licenceFront =
        VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.licenceFront ?? "", isLocalFile: false);

    this.widget.profileDetailBloc.licenceBack =
        VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.licenceBack ?? "", isLocalFile: false);

    this.widget.profileDetailBloc.registrationPDf =
        VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.vehicleRegistration ?? "", isLocalFile: false);

    this.widget.profileDetailBloc.insurancePDF =
        VehicleImagesModel(file: null, imageURL: this.widget.profileDetailBloc.getDriver.vehicleInsurance ?? "", isLocalFile: false);
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
          AppTranslations.globalTranslations.driverTitle,
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
      body: SingleChildScrollView(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: mainContainer()),
      ),
    );
  }

  Widget mainContainer() {
    return Container(
      color: AppColor.whiteColor,
      padding: EdgeInsets.only(
        top: UIUtills().getProportionalHeight(28),
        left: UIUtills().getProportionalWidth(28),
        right: UIUtills().getProportionalWidth(28),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(bottom: UIUtills().getProportionalHeight(21)),
            child: Text(
              AppTranslations.globalTranslations.vehicleImageText,
              style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.34),
            ),
          ),
          vehiclePicture(),
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(35)),
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.yearController,
              keyboardType: TextInputType.phone,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
              style: UIUtills().getTextStyleRegular(
                color: AppColor.textColor,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              textType: TextFieldType.phoneNumber,
              action: TextInputAction.next,
              onChanged: (s) {
                Focus.of(context).nextFocus();
                setState(() {});
              },
              onEditCompletie: () {
                FocusScope.of(context).requestFocus(makeFocusNode);
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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textType: TextFieldType.none,
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
                FocusScope.of(context).requestFocus(modelFocusNode);
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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
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
                FocusScope.of(context).requestFocus(licensePlateFocusNode);
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
//          button()
        ],
      ),
    );
  }

  Widget get licenceFront {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
          child: (!(this.widget.profileDetailBloc.licenceFront.isLocalFile) && this.widget.profileDetailBloc.licenceFront.imageURL.isNotEmpty)
              ? GestureDetector(
                  onTap: () {
                    List<String> mediaList = List();
                    if (this.widget.profileDetailBloc.licenceFront.isLocalFile && this.widget.profileDetailBloc.licenceFront.file != null) {
                      mediaList.add(this.widget.profileDetailBloc.licenceFront.file.path);
                    } else if (!this.widget.profileDetailBloc.licenceFront.isLocalFile && this.widget.profileDetailBloc.licenceFront.imageURL.isNotEmpty) {
                      mediaList.add(this.widget.profileDetailBloc.licenceFront.imageURL);
                    } else {
                      mediaList.add("");
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      height: UIUtills().getProportionalHeight(120),
                      width: UIUtills().getProportionalHeight(150),
                      placeholder: AppImage.profilePicturePlaceholder,
                      image: this.widget.profileDetailBloc.licenceFront.imageURL ?? "",
                    ),
                  ),
                )
              : (this.widget.profileDetailBloc.licenceFront.isLocalFile && this.widget.profileDetailBloc.licenceFront.file != null)
                  ? GestureDetector(
                      onTap: () {
                        List<String> mediaList = List();
                        if (this.widget.profileDetailBloc.licenceFront.isLocalFile && this.widget.profileDetailBloc.licenceFront.file != null) {
                          mediaList.add(this.widget.profileDetailBloc.licenceFront.file.path);
                        } else if (!this.widget.profileDetailBloc.licenceFront.isLocalFile && this.widget.profileDetailBloc.licenceFront.imageURL.isNotEmpty) {
                          mediaList.add(this.widget.profileDetailBloc.licenceFront.imageURL);
                        } else {
                          mediaList.add("");
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                        child: Image.file(
                          this.widget.profileDetailBloc.licenceFront.file,
                          width: UIUtills().getProportionalHeight(150),
                          height: UIUtills().getProportionalHeight(120),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
                          if (file != null) {
                            this.widget.profileDetailBloc.licenceFront.isLocalFile = true;
                            this.widget.profileDetailBloc.licenceFront.file = file;

                            print("File " + file.path);
                            setState(() {});
                          }
                        });
                      },
                      child: Container(
                        width: UIUtills().getProportionalHeight(150),
                        height: UIUtills().getProportionalHeight(120),
                        decoration: BoxDecoration(
                          color: AppColor.dividerBackgroundColor,
                          borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(AppImage.plusIcon),
                      ),
                    ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (this.widget.profileDetailBloc.licenceFront.isLocalFile) {
                this.widget.profileDetailBloc.licenceFront.file = null;
              } else {
                this.widget.profileDetailBloc.licenceFront.imageURL = "";
              }
            });
          },
          child: Visibility(
            visible: this.widget.profileDetailBloc.licenceFront.file != null || this.widget.profileDetailBloc.licenceFront.imageURL.isNotEmpty,
            child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(bottom: 0.0),
                child: Image.asset(
                  AppImage.closeIcon,
                  width: UIUtills().getProportionalWidth(30.0),
                  height: UIUtills().getProportionalWidth(30.0),
                )),
          ),
        )
      ],
    );
  }

  Widget get licenceBack {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
          child: (!(this.widget.profileDetailBloc.licenceBack.isLocalFile) && this.widget.profileDetailBloc.licenceBack.imageURL.isNotEmpty)
              ? GestureDetector(
                  onTap: () {
                    List<String> mediaList = List();
                    if (this.widget.profileDetailBloc.licenceBack.isLocalFile && this.widget.profileDetailBloc.licenceBack.file != null) {
                      mediaList.add(this.widget.profileDetailBloc.licenceBack.file.path);
                    } else if (!this.widget.profileDetailBloc.licenceBack.isLocalFile && this.widget.profileDetailBloc.licenceBack.imageURL.isNotEmpty) {
                      mediaList.add(this.widget.profileDetailBloc.licenceBack.imageURL);
                    } else {
                      mediaList.add("");
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      height: UIUtills().getProportionalHeight(120),
                      width: UIUtills().getProportionalHeight(150),
                      placeholder: AppImage.profilePicturePlaceholder,
                      image: this.widget.profileDetailBloc.licenceBack.imageURL ?? "",
                    ),
                  ),
                )
              : (this.widget.profileDetailBloc.licenceBack.isLocalFile && this.widget.profileDetailBloc.licenceBack.file != null)
                  ? GestureDetector(
                      onTap: () {
                        List<String> mediaList = List();
                        if (this.widget.profileDetailBloc.licenceBack.isLocalFile && this.widget.profileDetailBloc.licenceBack.file != null) {
                          mediaList.add(this.widget.profileDetailBloc.licenceBack.file.path);
                        } else if (!this.widget.profileDetailBloc.licenceBack.isLocalFile && this.widget.profileDetailBloc.licenceBack.imageURL.isNotEmpty) {
                          mediaList.add(this.widget.profileDetailBloc.licenceBack.imageURL);
                        } else {
                          mediaList.add("");
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                        child: Image.file(
                          this.widget.profileDetailBloc.licenceBack.file,
                          width: UIUtills().getProportionalHeight(150),
                          height: UIUtills().getProportionalHeight(120),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(new FocusNode());
                        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
                          if (file != null) {
                            this.widget.profileDetailBloc.licenceBack.isLocalFile = true;
                            this.widget.profileDetailBloc.licenceBack.file = file;

                            print("File " + file.path);
                            setState(() {});
                          }
                        });
                      },
                      child: Container(
                        width: UIUtills().getProportionalHeight(150),
                        height: UIUtills().getProportionalHeight(120),
                        decoration: BoxDecoration(
                          color: AppColor.dividerBackgroundColor,
                          borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(AppImage.plusIcon),
                      ),
                    ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (this.widget.profileDetailBloc.licenceBack.isLocalFile) {
                this.widget.profileDetailBloc.licenceBack.file = null;
              } else {
                this.widget.profileDetailBloc.licenceBack.imageURL = "";
              }
            });
          },
          child: Visibility(
            visible: this.widget.profileDetailBloc.licenceBack.file != null || this.widget.profileDetailBloc.licenceBack.imageURL.isNotEmpty,
            child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(bottom: 0.0),
                child: Image.asset(
                  AppImage.closeIcon,
                  width: UIUtills().getProportionalWidth(30.0),
                  height: UIUtills().getProportionalWidth(30.0),
                )),
          ),
        )
      ],
    );
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
            Column(
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
            SizedBox(
              width: UIUtills().getProportionalWidth(10.0),
            ),
            Column(
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
          ],
        ),
      ],
    );
  }

  Widget vehicleRegisterContainer() {
    return Column(
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              getFilePath(SelectionType.registration);
            },
            child: TextFieldWithLabel(
              controller: this.widget.profileDetailBloc.registrationController,
              enabled: false,
              suffixIcon: ImageIcon(
                AssetImage(AppImage.uploadIcon),
                color: AppColor.textColor,
              ),
              keyboardType: TextInputType.text,
              textType: TextFieldType.none,
              action: TextInputAction.next,
              style: UIUtills().getTextStyleRegular(
                color: AppColor.textColor,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
              labelText: AppTranslations.globalTranslations.selectfileText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget vehicleInsuranceContainer() {
    return Column(
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              getFilePath(SelectionType.insurance);
            },
            child: TextFieldWithLabel(
              enabled: false,
              controller: this.widget.profileDetailBloc.insuranceController,
              suffixIcon: ImageIcon(
                AssetImage(AppImage.uploadIcon),
                color: AppColor.textColor,
              ),
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
              labelText: AppTranslations.globalTranslations.selectfileText,
              labelTextStyle: UIUtills().getTextStyleRegular(
                color: AppColor.textColorLight,
                fontSize: 15,
                characterSpacing: 0.4,
                fontName: AppFont.sfProTextMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget vehiclePicture() {
    return Container(
      height: UIUtills().getProportionalHeight(160),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: this.widget.profileDetailBloc.vehicleImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(10.0)),
                  child: Column(
                    children: [
                      this.widget.profileDetailBloc.vehicleImages[index] != null
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
                                  child: (!(this.widget.profileDetailBloc.vehicleImages[index].isLocalFile) &&
                                          this.widget.profileDetailBloc.vehicleImages[index].imageURL.isNotEmpty)
                                      ? GestureDetector(
                                          onTap: () {
                                            List<String> mediaList = List();
                                            this.widget.profileDetailBloc.vehicleImages.forEach((element) {
                                              if (element != null) {
                                                if (element.isLocalFile && element.file != null)
                                                  mediaList.add(element.file.path ?? "");
                                                else if (!element.isLocalFile && element.imageURL.isNotEmpty)
                                                  mediaList.add(element.imageURL ?? "");
                                              }
                                            });
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: index)));
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                                            child: FadeInImage.assetNetwork(
                                              fit: BoxFit.cover,
                                              height: UIUtills().getProportionalHeight(120),
                                              width: UIUtills().getProportionalHeight(150),
                                              placeholder: AppImage.profilePicturePlaceholder,
                                              image: this.widget.profileDetailBloc.vehicleImages[index].imageURL,
                                            ),
                                          ),
                                        )
                                      : (this.widget.profileDetailBloc.vehicleImages[index].isLocalFile &&
                                              this.widget.profileDetailBloc.vehicleImages[index].file != null)
                                          ? GestureDetector(
                                              onTap: () {
                                                List<String> mediaList = List();
                                                this.widget.profileDetailBloc.vehicleImages.forEach((element) {
                                                  if (element != null) {
                                                    if (element.isLocalFile && element.file != null)
                                                      mediaList.add(element.file.path ?? "");
                                                    else if (!element.isLocalFile && element.imageURL.isNotEmpty)
                                                      mediaList.add(element.imageURL ?? "");
                                                  }
                                                });
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: index)));
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                                                child: Image.file(
                                                  this.widget.profileDetailBloc.vehicleImages[index].file,
                                                  width: UIUtills().getProportionalHeight(150),
                                                  height: UIUtills().getProportionalHeight(120),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context).unfocus();
                                                FocusScope.of(context).requestFocus(new FocusNode());
                                                MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false,
                                                    callBack: (file) {
                                                  if (file != null) {
                                                    this.widget.profileDetailBloc.vehicleImages[index].isLocalFile = true;
                                                    this.widget.profileDetailBloc.vehicleImages[index].file = file;

                                                    print("File " + file.path);
                                                    setState(() {});
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: UIUtills().getProportionalHeight(150),
                                                height: UIUtills().getProportionalHeight(120),
                                                decoration: BoxDecoration(
                                                  color: AppColor.dividerBackgroundColor,
                                                  borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                                                ),
                                                alignment: Alignment.center,
                                                child: Image.asset(AppImage.plusIcon),
                                              ),
                                            ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (this.widget.profileDetailBloc.vehicleImages[index].isLocalFile) {
                                        this.widget.profileDetailBloc.vehicleImages[index].file = null;
                                      } else {
                                        this.widget.profileDetailBloc.vehicleImages[index].imageURL = "";
                                      }
                                    });
                                  },
                                  child: Visibility(
                                    visible: this.widget.profileDetailBloc.vehicleImages[index].file != null ||
                                        this.widget.profileDetailBloc.vehicleImages[index].imageURL.isNotEmpty,
                                    child: Container(
                                        alignment: Alignment.topRight,
                                        margin: EdgeInsets.only(bottom: 0.0),
                                        child: Image.asset(
                                          AppImage.closeIcon,
                                          width: UIUtills().getProportionalWidth(30.0),
                                          height: UIUtills().getProportionalWidth(30.0),
                                        )),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: UIUtills().getProportionalWidth(5.0),
                      ),
                      Text(
                        index == 0
                            ? AppTranslations.globalTranslations.frontImageText
                            : index == 1
                                ? AppTranslations.globalTranslations.backImageText
                                : index == 2
                                    ? AppTranslations.globalTranslations.side1ImageText
                                    : AppTranslations.globalTranslations.side2ImageText,
                        style: UIUtills().getTextStyle(fontsize: 10, fontName: AppFont.sfProTextRegular, color: AppColor.textColor, characterSpacing: 0.34),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _editDriverAction() {
    // dismiss key board
    FocusScope.of(context).unfocus();

    final validationResult = this.widget.profileDetailBloc.isValidForms();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }
    setState(() {});
    this._editDriverSubscription = this.widget.profileDetailBloc.editDriverStream.listen((GetDriverResponse response) {
      this._editDriverSubscription.cancel();
      Future.delayed(Duration(milliseconds: UIUtills().apiCallHaltDurationInMilliSecond), () {
        UIUtills().dismissProgressDialog(context);
        if (!response.status) {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        } else {
          this.widget.profileDetailBloc.getDriver.year = response.data.year;
          this.widget.profileDetailBloc.getDriver.make = response.data.make;
          this.widget.profileDetailBloc.getDriver.model = response.data.model;
          this.widget.profileDetailBloc.getDriver.licenceNumber = response.data.licenceNumber;
          this.widget.profileDetailBloc.getDriver.licenceFront = response.data.licenceFront;
          this.widget.profileDetailBloc.getDriver.licenceBack = response.data.licenceBack;
          this.widget.profileDetailBloc.getDriver.photo = response.data.photo;
          this.widget.profileDetailBloc.getDriver.photo2 = response.data.photo2;
          this.widget.profileDetailBloc.getDriver.photo3 = response.data.photo3;
          this.widget.profileDetailBloc.getDriver.photo4 = response.data.photo4;
          this.widget.profileDetailBloc.getDriver.vehicleInsurance = response.data.vehicleInsurance;
          this.widget.profileDetailBloc.getDriver.vehicleRegistration = response.data.vehicleRegistration;

          Utils.showAlert(context,
              message: response.message, arrButton: [AppTranslations.globalTranslations.buttonOk], callback: (_) => Navigator.of(context).pop());
        }
      });
    });

    this.widget.profileDetailBloc.callEditDriverApi();
    UIUtills().showProgressDialog(context);
  }
}
