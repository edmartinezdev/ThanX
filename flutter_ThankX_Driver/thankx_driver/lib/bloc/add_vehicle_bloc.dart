import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/add_vehicle_model.dart';
import 'package:thankxdriver/validation/validation.dart';
import 'package:tuple/tuple.dart';

class AddVehicleBloc extends BaseBloc {
  final _addVehicleOptionSubject = PublishSubject<AddVehicleInfoResponse>();

  Observable<AddVehicleInfoResponse> get addVehicleOptionStream => _addVehicleOptionSubject.stream;

  File licenceFrontFile, licenceBackFile, registration, insurance;
  List<File> vehicleImages = List();

  final _year = BehaviorSubject<String>();
  final _model = BehaviorSubject<String>();
  final _licenceNumber = BehaviorSubject<String>();
  final _make = BehaviorSubject<String>();

  // add data to stream
  Function(String) get year => _year.sink.add;

  Function(String) get model => _model.sink.add;

  Function(String) get make => _make.sink.add;

  Function(String) get licenceNumber => _licenceNumber.sink.add;

  TextEditingController registrationController = new TextEditingController();
  TextEditingController insuranceController = new TextEditingController();
  AddVehicleInfoModel addVehicleInfoModel;
  TextEditingController w9Controller = new TextEditingController();

  void callAddVehicleApi() async {
    AddVehicleRequest request = AddVehicleRequest();
    request.year = this._year.value;
    request.model = this._model.value;
    request.licenceNumber = this._licenceNumber.value;
    request.make = this._make.value;

    if (vehicleImages != null && vehicleImages.length > 0) {
      request.selectedFile = vehicleImages[0];
    }
    if (vehicleImages != null && vehicleImages.length > 1) {
      request.selectedFile2 = vehicleImages[1];
    }
    if (vehicleImages != null && vehicleImages.length > 2) {
      request.selectedFile3 = vehicleImages[2];
    }
    if (vehicleImages != null && vehicleImages.length > 3) {
      request.selectedFile4 = vehicleImages[3];
    }

    if (licenceFrontFile != null) {
      request.licenceFront = licenceFrontFile;
    }
    if (licenceBackFile != null) {
      request.licenceBack = licenceBackFile;
    }

    if (registration != null) {
      request.registration = registration;
    }
    if (insurance != null) {
      request.insurance = insurance;
    }

    AddVehicleInfoResponse response = await repository.addVehicleApi(params: request);
    _addVehicleOptionSubject.sink.add(response);
  }

  Tuple2<bool, String> isValidForm() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.year, this._year.value ?? ''));
    arrList.add(Tuple2(ValidationType.make, this._make.value ?? ''));
    arrList.add(Tuple2(ValidationType.model, this._model.value ?? ''));
    arrList.add(Tuple2(ValidationType.licence, this._licenceNumber.value ?? ''));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    if (validationResult.item1) {
      if (this.licenceFrontFile == null) {
        return Tuple2(false, 'Please attach licence front image.');
      } else if (this.licenceBackFile == null) {
        return Tuple2(false, 'Please attach licence back image.');
      } else if (this.vehicleImages == null) {
        return Tuple2(false, 'Please attach vehicle images.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 0 && this.vehicleImages[0] == null) {
        return Tuple2(false, 'Please attach vehicle front image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 1 && this.vehicleImages[1] == null) {
        return Tuple2(false, 'Please attach vehicle back image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 2 && this.vehicleImages[2] == null) {
        return Tuple2(false, 'Please attach vehicle side 1 image.');
      } else if (this.vehicleImages != null && this.vehicleImages.length > 3 && this.vehicleImages[3] == null) {
        return Tuple2(false, 'Please attach vehicle side 2 image.');
      } else if (this.registration == null) {
        return Tuple2(false, 'Please attach vehicle registration document.');
      } else if (this.insurance == null) {
        return Tuple2(false, 'Please attach vehicle insurance document.');
      }
    }

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  final _addW9FormOptionSubject = PublishSubject<BaseResponse>();

  Observable<BaseResponse> get addW9FormOptionStream => _addW9FormOptionSubject.stream;
  TextEditingController w9FormController = new TextEditingController();
  File w9Form;

  void callAddW9FormApi() async {
    AddW9FormRequest request = AddW9FormRequest();

    if (w9Form != null) {
      request.selectedFile = w9Form;
    }

    BaseResponse response = await repository.addW9FormApi(params: request);
    _addW9FormOptionSubject.sink.add(response);
  }

  @override
  dispose() {
    super.dispose();
    _year.close();
    _model.close();
    _make.close();
    _licenceNumber.close();

    _addVehicleOptionSubject.close();
    _addW9FormOptionSubject.close();
  }
}
