import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/get_driver_model.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/model/user_profile_model.dart';
import 'package:thankxdriver/model/vehicle_images_model.dart';
import 'package:thankxdriver/utils/string_extension.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';
import 'package:thankxdriver/utils/string_extension.dart';

class ProfileDetailBloc extends BaseBloc {
  bool isProfileChange = false;

  File selectedUserPhoto;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  UserProfileModel userModel;

  void resetDetail() {
    this.selectedUserPhoto = null;
    firstNameController.text = _userProfile.firstname;
    lastNameController.text = _userProfile.lastname;
    emailController.text = _userProfile.email;
    phoneNumberController.text = _userProfile.contactNumber.convertToUSAPhoneNumber();
  }

  //region Get User Profile
  UserProfileModel _userProfile;

  UserProfileModel get userProfile => (this._userProfile != null) ? this._userProfile : User.currentUser.convertToUserProfile();
  final _getProfileSubject = PublishSubject<UserProfileResponse>();

  Observable<UserProfileResponse> get getProfileStream => _getProfileSubject.stream;

  void callGetUserProfileApi() async {
    UserProfileResponse response = await repository.getUserProfileApi();
    if (response.status) {
      this._userProfile = response.data;
      this.resetDetail();
    }
    _getProfileSubject.sink.add(response);
  }

  //endregion

  Tuple2<bool, String> isValidForm() {
//    print('this'+ (this._firstName.value ?? ''));
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.firstName, this.firstNameController.text ?? ''));
    arrList.add(Tuple2(ValidationType.lastName, this.lastNameController.text ?? ''));
    arrList.add(Tuple2(ValidationType.phoneNumber, this.phoneNumberController.text ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    if (validationResult.item1) {
      if (this.selectedUserPhoto == null && this.userProfile.profilePicture == null) {
        return Tuple2(false, 'Please select profile image.');
      }
    }
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  //region Edit Profile
  final _editProfileSubject = PublishSubject<UserAuthenticationResponse>();

  Observable<UserAuthenticationResponse> get editProfileStream => _editProfileSubject.stream;

  void callEditUserProfileApi() async {
    EditProfileRequest request = EditProfileRequest();
    request.firstname = this.firstNameController.text ?? '';
    request.lastname = this.lastNameController.text ?? '';
    request.contactNumber = (this.phoneNumberController.text ?? '').convertToPhoneNumber();
    request.userType = '2';
    request.selectedFile = this.selectedUserPhoto;

    UserAuthenticationResponse response = await repository.updateUserProfileApi(params: request);
    _editProfileSubject.sink.add(response);
  }

  //endregion

  //region Get Driver

  final TextEditingController yearController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();

  VehicleImagesModel registrationPDf;
  VehicleImagesModel insurancePDF;

  VehicleImagesModel licenceFront;
  VehicleImagesModel licenceBack;

  List<VehicleImagesModel> vehicleImages = List();

  GetDriverModel _getDriver;

  GetDriverModel get getDriver => _getDriver;

  void resetDriver() {
    this.registrationPDf = null;
    this.insurancePDF = null;
    this.licenceFront = null;
    this.licenceBack = null;
    vehicleImages = List();
    yearController.text = _getDriver.year;
    modelController.text = _getDriver.model;
    makeController.text = _getDriver.make;
    licenseController.text = _getDriver.licenceNumber;
    registrationController.text = basename(_getDriver.vehicleRegistration);
    insuranceController.text = basename(_getDriver.vehicleInsurance);
  }

  final _getDriverSubject = PublishSubject<GetDriverResponse>();

  Observable<GetDriverResponse> get getDriverStream => _getDriverSubject.stream;

  void callGetDriverApi() async {
    GetDriverResponse response = await repository.getGetDriverApi();
    if (response.status) {
      this._getDriver = response.data;
      this.resetDriver();
    }
    _getDriverSubject.sink.add(response);
  }

  Tuple2<bool, String> isValidForms() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.year, this.yearController.text ?? ''));
    arrList.add(Tuple2(ValidationType.model, this.modelController.text ?? ''));
    arrList.add(Tuple2(ValidationType.make, makeController.text ?? ''));
    arrList.add(Tuple2(ValidationType.licence, this.licenseController.text ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    if (validationResult.item1) {
      if (this.vehicleImages == null) {
        return Tuple2(false, 'Please attach vehicle images.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 0 && this.vehicleImages[0].file == null && this.vehicleImages[0].imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle front image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 1 && this.vehicleImages[1].file == null && this.vehicleImages[1].imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle back image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 2 && this.vehicleImages[2].file == null && this.vehicleImages[2].imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle side 1 image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 3 && this.vehicleImages[3].file == null && this.vehicleImages[3].imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle side 2 image.');
      } else if (this.licenceFront.file == null && this.licenceFront.imageURL.isEmpty) {
        return Tuple2(false, 'Please attach licence front image.');
      } else if (this.licenceBack.file == null && this.licenceBack.imageURL.isEmpty) {
        return Tuple2(false, 'Please attach licence back image.');
      } else if (this.registrationPDf.file == null && this.registrationPDf.imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle registration document.');
      } else if (this.insurancePDF == null && this.insurancePDF.imageURL.isEmpty) {
        return Tuple2(false, 'Please attach vehicle insurance document.');
      }
    }
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  //region update driver
  final _editDriverSubject = PublishSubject<GetDriverResponse>();

  Observable<GetDriverResponse> get editDriverStream => _editDriverSubject.stream;

  void callEditDriverApi() async {
    EditDriverRequest request = EditDriverRequest();
    request.year = this.yearController.text ?? '';
    request.model = this.modelController.text ?? '';
    request.licenceNumber = this.licenseController.text ?? '';
    request.make = this.makeController.text ?? '';

    if (vehicleImages != null && vehicleImages.length > 0 && vehicleImages[0].file != null) {
      request.selectedFile = vehicleImages[0].file;
    }
    if (vehicleImages != null && vehicleImages.length > 1 && vehicleImages[1].file != null) {
      request.selectedFile2 = vehicleImages[1].file;
    }
    if (vehicleImages != null && vehicleImages.length > 2 && vehicleImages[2].file != null) {
      request.selectedFile3 = vehicleImages[2].file;
    }
    if (vehicleImages != null && vehicleImages.length > 3 && vehicleImages[3].file != null) {
      request.selectedFile4 = vehicleImages[3].file;
    }

    if (licenceFront != null && licenceFront.file != null) {
      request.licenceFront = licenceFront.file;
    }
    if (licenceBack != null && licenceBack.file != null) {
      request.licenceBack = licenceBack.file;
    }
    if (registrationPDf != null && registrationPDf.file != null) {
      request.registration = registrationPDf.file;
    }
    if (insurancePDF != null && insurancePDF.file != null) {
      request.insurance = insurancePDF.file;
    }
    GetDriverResponse response = await repository.editDriverApi(params: request);
    _editDriverSubject.sink.add(response);
  }

  //endregion

  @override
  dispose() {
    super.dispose();
    _getProfileSubject.close();
    _getDriverSubject.close();
    _editProfileSubject.close();
    _editDriverSubject.close();
  }
}
