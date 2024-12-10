import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:thankx_user/localization/localization.dart';
import 'package:thankx_user/utils/enum.dart';


// Network files
import 'all_request.dart';
import 'all_response.dart';
import 'api_constant.dart';
import 'reachability.dart';

import '../utils/logger.dart';
import 'package:path/path.dart';


//endregion


class ApiProvider {

  CancelToken lastRequestToken;

  factory ApiProvider() {
    return _singleton;
  }
  final Dio dio = new Dio();
  LogoutCallBack logoutCallBack;
  static final ApiProvider _singleton = ApiProvider._internal();

  ApiProvider._internal() {
    Logger().v("Instance created ApiProvider");
    dio.options.receiveTimeout = 9000;
  }


  void performLogoutOperation() async {
    if (this.logoutCallBack != null) {
      this.logoutCallBack();
    }
  }

  HttpResponse _handleDioNetworkError({DioError error}) {
    Logger().v("Error Details :: ${error.message}");

    if ((error.response == null) || (error.response.data == null)) {
      String errMessage = AppTranslations.globalTranslations.msgSomethingWrong;
      return HttpResponse(status: false, errMessage:  errMessage, json: null);
    }
    else {
      Logger().v("Error Details :: ${error.response.data}");
      dynamic jsonResponse = error.response.data;
      final status = jsonResponse[ResonseKeys.kStatus] ?? 400;
      if (status == 418 || status == 401) { // Need To Log Out
        Future.delayed(Duration(milliseconds: 1000), () => this.performLogoutOperation());
      }
      String errMessage = jsonResponse["message"] ?? AppTranslations.globalTranslations.msgSomethingWrong;
      return HttpResponse(status: false, errMessage:  errMessage, json: null);
    }

  }

  HttpResponse _handleNetworkSuccess({Response<dynamic> response}) {
    dynamic jsonResponse = response.data;

    Logger().v("Response Status code:: ${response.statusCode}");
    Logger().v("response body :: $jsonResponse");

    final message = jsonResponse[ResonseKeys.kMessage] ?? '';
    final status = jsonResponse[ResonseKeys.kStatus] ?? 400;
    final data = jsonResponse[ResonseKeys.kData];
    if (response.statusCode >= 200 && response.statusCode < 299) {
      return HttpResponse(status: status == 200, errMessage: message, json: data);

    }
    else {
      var errMessage = jsonResponse[ResonseKeys.kMessage];
      return HttpResponse(status: false, errMessage: errMessage, json: jsonResponse);
    }
  }

  Future<HttpResponse> getRequest(ApiType apiUrl, {Map<String, String> params, String urlParam}) async {

    if (!Reachability().isInterNetAvaialble()) {
      return HttpResponse(status: false, errMessage: AppTranslations.globalTranslations.msgInternetMessage, json: null);
    }

    final requestFinal = ApiConstant.requestParamsForSync(apiUrl, params: params,urlParams: urlParam);

    final option = Options(headers: requestFinal.item2);
    try {
      final response = await this.dio.get(requestFinal.item1, queryParameters: requestFinal.item3, options: option);
      return _handleNetworkSuccess(response: response);
    }
    on DioError catch(error) {
      return this._handleDioNetworkError(error: error);
    }
  }

  Future<HttpResponse> postRequest(ApiType url, {Map<String, dynamic> params,}) async {

    if (!Reachability().isInterNetAvaialble()) {
      return HttpResponse(status: false, errMessage: AppTranslations.globalTranslations.msgInternetMessage, json: null);
    }

    final requestFinal = ApiConstant.requestParamsForSync(url, params: params);
    final option = Options(headers: requestFinal.item2);

    try {
      final response =  await this.dio.post(requestFinal.item1, data: json.encode(requestFinal.item3),options: option);
      return this._handleNetworkSuccess(response: response);
    }
    on DioError catch(error) {
      return this._handleDioNetworkError(error: error);
    }

  }

//  Future<HttpResponse> uploadRequest(ApiType url, {Map<String, dynamic> params, List<AppMultiPartFile> arrFile}) async {
//
//    if (!Reachability().isInterNetAvaialble()) {
//      final httpResonse = HttpResponse(status: false, errMessage: AppTranslations.globalTranslations.msgInternetMessage, json: null);
//      return httpResonse;
//    }
//
//    final requestFinal = ApiConstant.requestParamsForSync(url, params: params, arrFile: arrFile);
//
//    Map<String, dynamic> other = Map<String, dynamic>();
//    other.addAll(requestFinal.item3);
//
//    /* Adding File Content */
//    final context = ContentType('image/*', 'image/*');
//    for(AppMultiPartFile mfile in requestFinal.item4) {
//      List<UploadFileInfo> uEiles = mfile.localFile.map((o) => UploadFileInfo(o, basename(o.path), contentType: context)).toList();
//      if (uEiles.length > 0) {
//        other[mfile.key] = (uEiles.length == 1) ? uEiles.first : uEiles;
//      }
//
//    }
//
//    FormData formData = new FormData.from(other);
//    final option = Options(headers: requestFinal.item2);
//
//    try {
//      final response = await this.dio.post(requestFinal.item1, data:formData, options: option,
//          onSendProgress: (sent, total) =>  Logger().v("uploadFile ${sent / total}") );
//
//      return this._handleNetworkSuccess(response: response);
//    }
//    on DioError catch(error) {
//      return this._handleDioNetworkError(error: error);
//    }
//  }

  Future<HttpResponse> uploadRequest(ApiType url, {Map<String, dynamic> params, List<AppMultiPartFile> arrFile,String urlParam} ) async {

    if (!Reachability().isInterNetAvaialble()) {
      final httpResonse = HttpResponse(status: false, errMessage: AppTranslations.globalTranslations.msgInternetMessage, json: null);
      return httpResonse;
    }

    final requestFinal = ApiConstant.requestParamsForSync(url, params: params, arrFile: arrFile);

    Map<String, dynamic> other = Map<String, dynamic>();
    other.addAll(requestFinal.item3);

    /* Adding File Content */
    for(AppMultiPartFile mfile in requestFinal.item4) {

      List<MultipartFile> uEiles = [];
      for(File file in mfile.localFile) {
        MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: basename(file.path),);
        uEiles.add(mFile);
      }

      if (uEiles.length > 0) {
        other[mfile.key] = (uEiles.length == 1) ? uEiles.first : uEiles;
      }

    }

    FormData formData = new FormData.fromMap(other);
    final option = Options(headers: requestFinal.item2);

    try {
      final response = await this.dio.post(requestFinal.item1, data:formData, options: option,
          onSendProgress: (sent, total) =>  Logger().v("uploadFile ${sent / total}") );

      return this._handleNetworkSuccess(response: response);
    }
    on DioError catch(error) {
      return this._handleDioNetworkError(error: error);
    }
  }

//  Future<UserAuthenticationResponse> loginApi({LoginRequest params}) async {
//    final HttpResponse response = await this.postRequest(ApiType.login, params: params.toJson());
//    User user;
//    if (response.status) {
//      user = User.currentUser;
//      user.updateUserDetails(response.json);
//    }
//    return UserAuthenticationResponse(status: response.status, message: response.errMessage, user: user);
//  }


}