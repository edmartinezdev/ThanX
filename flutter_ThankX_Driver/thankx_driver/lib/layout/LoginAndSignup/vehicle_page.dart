import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/add_vehicle_bloc.dart';
import 'package:thankxdriver/common_widgets/common_button.dart';
import 'package:thankxdriver/common_widgets/text_field_with_label.dart';
import 'package:thankxdriver/control/ai_text_form_field.dart';
import 'package:thankxdriver/layout/FullScreenImageViewer.dart';
import 'package:thankxdriver/layout/LoginAndSignup/w9_form_page.dart';
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
  registration,
  insurance,
}

class VehiclePage extends StatefulWidget {
  final bool isInitialPage;

  VehiclePage({this.isInitialPage = false});

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode yearFocusNode = FocusNode();
  FocusNode modelFocusNode = FocusNode();
  FocusNode makeFocusNode = FocusNode();
  FocusNode licensePlateFocusNode = FocusNode();
  FileType fileType;

  AddVehicleBloc _bloc = AddVehicleBloc();
  StreamSubscription<AddVehicleInfoResponse> subscription;

  String registration, insurance;

  void getFilePath(SelectionType type) async {
    try {
      if (type == SelectionType.registration) {
        String filePath;
        MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
          if (file != null) {
            filePath = file.path;
            print("File " + filePath);

            if ((filePath != null) && (filePath.isNotEmpty)) {
              this._bloc.registration = File(filePath);
              this._bloc.registrationController.text = Path.basename(filePath);
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
              this._bloc.insurance = File(filePath);
              this._bloc.insuranceController.text = Path.basename(filePath);
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

  @override
  void initState() {
    super.initState();
    this._bloc.vehicleImages = List();
    this._bloc.vehicleImages.add(null);
    this._bloc.vehicleImages.add(null);
    this._bloc.vehicleImages.add(null);
    this._bloc.vehicleImages.add(null);
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            title: Text(
              AppTranslations.globalTranslations.screenTitleVehicle,
              style: UIUtills().getTextStyle(color: AppColor.appBartextColor, fontsize: 17, fontName: AppFont.sfProTextSemibold),
            ),
            centerTitle: true,
            backgroundColor: AppColor.whiteColor,
            elevation: 0.5,
          ),
          body: SingleChildScrollView(
            child: textFieldContainer(),
          ),
        ));
  }

  Future<bool> _willPopCallback() async {
    Logger().v("Open Alert for Option");
    Utils.showAlert(
      context,
      message: "Are you sure you want to exit from app?",
      arrButton: ["Cancel", AppTranslations.globalTranslations.btnOK],
      callback: (int index) {
        if (index == 1) {
          SystemNavigator.pop();
        }
      },
    );
    return false;
  }

  Widget textFieldContainer() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
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
                onChanged: this._bloc.year,
                keyboardType: TextInputType.number,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                style: UIUtills().getTextStyleRegular(
                  color: AppColor.textColor,
                  fontSize: 15,
                  characterSpacing: 0.4,
                  fontName: AppFont.sfProTextMedium,
                ),
                textType: TextFieldType.phoneNumber,
                action: TextInputAction.next,
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
                onChanged: this._bloc.make,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                textType: TextFieldType.none,
                action: TextInputAction.next,
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                style: UIUtills().getTextStyleRegular(
                  color: AppColor.textColor,
                  fontSize: 15,
                  characterSpacing: 0.4,
                  fontName: AppFont.sfProTextMedium,
                ),
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
                onChanged: this._bloc.model,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                style: UIUtills().getTextStyleRegular(
                  color: AppColor.textColor,
                  fontSize: 15,
                  characterSpacing: 0.4,
                  fontName: AppFont.sfProTextMedium,
                ),
                textType: TextFieldType.none,
                action: TextInputAction.next,
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
                onChanged: this._bloc.licenceNumber,
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
            vehiclePictureContainer(),
            vehicleRegisterContainer(),
            vehicleInsuranceContainer(),
            button()
          ],
        ),
      ),
    );
  }

  Widget get licenceFront {
    if (this._bloc.licenceFrontFile != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
            child: GestureDetector(
              onTap: () {
                List<String> mediaList = List();
                if (this._bloc.licenceFrontFile != null) {
                  mediaList.add(this._bloc.licenceFrontFile.path);
                } else {
                  mediaList.add("");
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                child: Image.file(
                  this._bloc.licenceFrontFile,
                  width: UIUtills().getProportionalHeight(150),
                  height: UIUtills().getProportionalHeight(120),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                this._bloc.licenceFrontFile = null;
              });
            },
            child: Visibility(
              visible: this._bloc.licenceFrontFile != null,
              child: Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: Image.asset(
                    AppImage.closeIcon,
                    width: UIUtills().getProportionalWidth(30.0),
                    height: UIUtills().getProportionalWidth(30.0),
                  )),
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
                if (file != null) {
                  this._bloc.licenceFrontFile = file;
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
                child: (this._bloc.licenceFrontFile != null) ? Container() : Image.asset(AppImage.plusIcon))),
      );
    }
  }

  Widget get licenceBack {
    if (this._bloc.licenceBackFile != null) {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
            child: GestureDetector(
              onTap: () {
                List<String> mediaList = List();
                if (this._bloc.licenceBackFile != null) {
                  mediaList.add(this._bloc.licenceBackFile.path);
                } else {
                  mediaList.add("");
                }
                Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: 0)));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                child: Image.file(this._bloc.licenceBackFile, width: UIUtills().getProportionalHeight(150), height: UIUtills().getProportionalHeight(120), fit: BoxFit.cover),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                this._bloc.licenceBackFile = null;
              });
            },
            child: Visibility(
              visible: this._bloc.licenceBackFile != null,
              child: Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(bottom: 0.0),
                  child: Image.asset(
                    AppImage.closeIcon,
                    width: UIUtills().getProportionalWidth(30.0),
                    height: UIUtills().getProportionalWidth(30.0),
                  )),
            ),
          ),
        ],
      );
    } else {
      return Container(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(new FocusNode());
              MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
                if (file != null) {
                  this._bloc.licenceBackFile = file;
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
                child: (this._bloc.licenceBackFile != null) ? Container() : Image.asset(AppImage.plusIcon))),
      );
    }
  }

  Widget licenceImageContainer() {
    return Container(
      child: Column(
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
                    SizedBox(height: UIUtills().getProportionalWidth(5.0)),
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
      ),
    );
  }

  Widget vehiclePictureContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(55), bottom: UIUtills().getProportionalHeight(21)),
          child: Text(
            AppTranslations.globalTranslations.vehicleImageText,
            style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.34),
          ),
        ),
        Container(
          height: UIUtills().getProportionalHeight(160),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: this._bloc.vehicleImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: UIUtills().getProportionalWidth(10.0)),
                      child: Column(
                        children: [
                          this._bloc.vehicleImages[index] != null
                              ? Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
                                      child: GestureDetector(
                                        onTap: () {
                                          List<String> mediaList = List();
                                          this._bloc.vehicleImages.forEach((element) {
                                            if (element != null) {
                                              mediaList.add(element.path);
                                            } else {
                                              mediaList.add("");
                                            }
                                          });
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenImageViewer(mediaList: mediaList, position: index)));
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(UIUtills().getProportionalWidth(10.0)),
                                          child: Image.file(
                                            this._bloc.vehicleImages[index],
                                            width: UIUtills().getProportionalHeight(150),
                                            height: UIUtills().getProportionalHeight(120),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this._bloc.vehicleImages[index] = null;
                                        });
                                      },
                                      child: Visibility(
                                        visible: this._bloc.vehicleImages[index] != null,
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
                              : Container(
                                  margin: EdgeInsets.only(top: UIUtills().getProportionalWidth(10.0), right: UIUtills().getProportionalWidth(10.0)),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      MediaSelector().handleImagePickingOperation(context, purpose: MediaFor.vehicle, isImageResize: false, callBack: (file) {
                                        if (file != null) {
                                          this._bloc.vehicleImages[index] = file;
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
                                      child: (this._bloc.vehicleImages[index] != null) ? Container() : Image.asset(AppImage.plusIcon),
                                    ),
                                  ),
                                ),
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
        ),
      ],
    );
  }

  Widget vehicleRegisterContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(55)),
          child: Text(
            AppTranslations.globalTranslations.vehicleRegistrationText,
            style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.34),
          ),
        ),
        Container(
            margin: EdgeInsets.only(
              top: UIUtills().getProportionalHeight(21),
            ),
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(new FocusNode());
                getFilePath(SelectionType.registration);
              },
              child: TextFieldWithLabel(
                suffixIcon: ImageIcon(
                  AssetImage(AppImage.uploadIcon),
                  color: AppColor.textColor,
                ),
                controller: this._bloc.registrationController,
                keyboardType: TextInputType.text,
                textType: TextFieldType.none,
                action: TextInputAction.next,
                enabled: false,
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
            )),
      ],
    );
  }

  Widget vehicleInsuranceContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: UIUtills().getProportionalHeight(55)),
          child: Text(
            AppTranslations.globalTranslations.vehicleInsuranceText,
            style: UIUtills().getTextStyle(fontsize: 14, fontName: AppFont.sfProTextSemibold, color: AppColor.textColor, characterSpacing: 0.34),
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
              getFilePath(SelectionType.insurance);
            },
            child: TextFieldWithLabel(
              suffixIcon: ImageIcon(
                AssetImage(AppImage.uploadIcon),
                color: AppColor.textColor,
              ),
              controller: this._bloc.insuranceController,
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

  Widget button() {
    return Container(
        margin: EdgeInsets.only(
          top: UIUtills().getProportionalWidth(81),
          bottom: UIUtills().getProportionalHeight(48),
        ),
        child: CommonButton(
          height: UIUtills().getProportionalWidth(50),
          width: double.infinity,
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            _addVehicleInfoApi();
          },
          textColor: AppColor.textColor,
          fontName: AppFont.sfProTextMedium,
          fontsize: 17,
          characterSpacing: 0,
          text: AppTranslations.globalTranslations.buttonNext,
        ));
  }

  void _addVehicleInfoApi() {
    // Dismiss Keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    // Validate Form
    final validationResult = this._bloc.isValidForm();
    if (!validationResult.item1) {
      Utils.showSnakBarwithKey(_scaffoldKey, validationResult.item2);
      return;
    }

    this.subscription = this._bloc.addVehicleOptionStream.listen((AddVehicleInfoResponse response) {
      this.subscription.cancel();

      Future.delayed(Duration(milliseconds: 900), () {
        UIUtills().dismissProgressDialog(context);
        if (response.status) {
          var route = MaterialPageRoute(
              builder: (_) => W9FormPage(
                    addVehicleBloc: this._bloc,
                  ));
          Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);
        } else {
          Utils.showSnakBarwithKey(_scaffoldKey, response.message);
        }
      });
    });
    // flutter defined function
    UIUtills().showProgressDialog(context);
    this._bloc.callAddVehicleApi();
  }
}
