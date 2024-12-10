import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:thankxdriver/api_provider/all_request.dart';
import 'package:thankxdriver/api_provider/all_response.dart';
import 'package:thankxdriver/bloc/base_bloc.dart';
import 'package:thankxdriver/model/CMS_model.dart';

class CMSBLOC extends BaseBloc {

  final _cmsResponseSubject = PublishSubject<CMSResponse>();
  Observable<CMSResponse> get cmsResponseStream => _cmsResponseSubject.stream;

  CMSModel cmsModel;
  TextEditingController downloadW9Controller = new TextEditingController();
  TextEditingController taxInfoController = new TextEditingController();

  void getCMSDetails() async {
    CMSResponse response = await repository.getCMSDetails();
    if (response.status) {
      cmsModel = response.data;
      downloadW9Controller.text = basename(cmsModel.w9Form);
      taxInfoController.text = basename(cmsModel.taxInformation);
    }
    _cmsResponseSubject.sink.add(response);
  }

  //region CMS Fetch details
  final _logoutSubject = PublishSubject<BaseResponse>();
  Observable<BaseResponse> get logOutStream => _logoutSubject.stream;

  logOutUser() async {
    LogoutRequest request = LogoutRequest();

    BaseResponse response = await repository.logoutUser(params: request);
    _logoutSubject.sink.add(response);
  }
//endregion


  dispose() {
    if (_cmsResponseSubject != null) _cmsResponseSubject.close();
    if (_logoutSubject != null) _logoutSubject.close();
    print('------------------- CMSBLOC Dispose ------------------- ');
  }
}
