import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:thankxdriver/localization/localization.dart';
import 'package:thankxdriver/model/CMS_model.dart';
import 'package:thankxdriver/model/add_bank_details_model.dart';
import 'package:thankxdriver/model/add_vehicle_model.dart';
import 'package:thankxdriver/model/bank_list_model.dart';
import 'package:thankxdriver/model/check_stripe_account_model.dart';
import 'package:thankxdriver/model/get_driver_model.dart';
import 'package:thankxdriver/model/my_current_order_model.dart';
import 'package:thankxdriver/model/notification_list_model.dart';
import 'package:thankxdriver/model/notification_setting%20model.dart';
import 'package:thankxdriver/model/order_detail_list_model.dart';
import 'package:thankxdriver/model/payment_history_model.dart';
import 'package:thankxdriver/model/review_model.dart';
import 'package:thankxdriver/model/order_details_data.dart';
import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/model/user_profile_model.dart';
import 'package:thankxdriver/model/withdraw_amount_model.dart';
import 'package:thankxdriver/utils/enum.dart';

import '../utils/logger.dart';
import 'all_request.dart';
import 'all_response.dart';
import 'api_constant.dart';
import 'reachability.dart';
import 'package:path/path.dart';



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
    dio.options.receiveTimeout = 30000;
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
      if (jsonResponse is Map) {
        final status = jsonResponse[ResonseKeys.kStatus] ?? 400;
        if (status == 401) { // Need To Log Out
          Future.delayed(Duration(milliseconds: 1000), () => this.performLogoutOperation());
        }
        String errMessage = jsonResponse["message"] ?? AppTranslations.globalTranslations.msgSomethingWrong;
        return HttpResponse(status: false, errMessage:  errMessage, json: null);
      } else {
        return HttpResponse(status: false, errMessage:  AppTranslations.globalTranslations.msgSomethingWrong, json: null);
      }
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
        String filename = basename(file.path);
        if (filename.toLowerCase().contains(".pdf")) {
          MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename,);
          uEiles.add(mFile);
        } else {
          MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('image', filename.split(".").last));
          uEiles.add(mFile);
        }

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

  Future<LoginResponse> loginApi({LoginRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.login, params: params.toJson());
    User user;
    if (response.status) {
      user = User.currentUser;
      user.updateUserDetails(response.json);
      user.saveUser();
    }
    return LoginResponse(status: response.status, message: response.errMessage, data: user);
  }

  Future<UserAuthenticationResponse> signupApi({SignupRequest params}) async {
    final HttpResponse response = await this.uploadRequest(ApiType.signUp, params: params.toJson(), arrFile: params.arrFiles);
    User user;
    if (response.status) {
      user = User.currentUser;
      user.updateUserDetails(response.json);
      user.saveUser();
    }
    return UserAuthenticationResponse(status: response.status, message: response.errMessage, data:user);
  }

  Future<BaseResponse> checkEmailAndPhoneNumberApi({CheckEmailAndPhoneNumberRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.checkEmailAndPhoneNumber, params: params.toJson());
    return BaseResponse(status: response.status,message: response.errMessage);
  }

  Future<BaseResponse> forgotPasswordApi({ForgotPasswordRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.forgotPassword, params: params.toJson());
    return BaseResponse(status: response.status,message: response.errMessage);
  }

  Future<AddVehicleInfoResponse> addVehicleApi({AddVehicleRequest params}) async {
    final HttpResponse response = await this.uploadRequest(ApiType.addVehicleInfo, params: params.toJson(), arrFile: params.arrFiles);
    AddVehicleInfoModel vehicleInfoModel;
      if (response.status) {
        vehicleInfoModel = AddVehicleInfoModel.fromJson(response.json);
      }
    return AddVehicleInfoResponse(status: response.status, message: response.errMessage, data: vehicleInfoModel);
  }

  Future<BaseResponse> addW9FormApi({AddW9FormRequest params}) async {
    final HttpResponse response = await this.uploadRequest(ApiType.addW9Form, params: params.toJson(), arrFile: params.arrFiles);
    return BaseResponse(status: response.status, message: response.errMessage);
  }

  Future< MyJodsOrderListResponse> getAllMyJodsOrderListApi({ MyJodsOrderListRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.myJodsOrderList, params: params.toJson());
    MyJodsOrderModel myJodsOrderModel;
    if (response.status) {
      myJodsOrderModel =  MyJodsOrderModel.fromJson(response.json);
    }
    return  MyJodsOrderListResponse(status: response.status, message: response.errMessage, myJodsOrderList: myJodsOrderModel);
  }

  Future<BaseResponse> changePasswordApi({ChangePasswordRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.changeUserPassword, params: params.toJson());
//    await this.postRequest(ApiType.changeUserPassword, params.toJson());
    return BaseResponse(status: response.status, message: response.errMessage);
  }

  Future<MyCurrentOrderListResponse> getAllMyCurrentOrderListApi({MyCurrentOrderListRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.currentOrderList, params: params.toJson());
    MyCurrentOrderModel myCurrentOrdersModel;
    if (response.status) {
      myCurrentOrdersModel = MyCurrentOrderModel.fromJson(response.json);
    }
    return MyCurrentOrderListResponse(status: response.status, message: response.errMessage, myCurrentOrderList: myCurrentOrdersModel);
  }

  Future<UserProfileResponse> getUserProfileApi() async {
    final HttpResponse response = await this.postRequest(ApiType.profileDetail, params: Map<String, dynamic>());
    UserProfileModel userProfile;
    if (response.status) {
      userProfile = UserProfileModel.fromJson(response.json);
    }
    return UserProfileResponse(status: response.status, message: response.errMessage, data: userProfile);
  }

  Future<UserAuthenticationResponse> updateUserProfileApi({EditProfileRequest params}) async {
    final HttpResponse response = await this.uploadRequest(ApiType.userProfileUpdate, params: params.toJson(), arrFile: params.arrFiles);
    User user;
    if (response.status) {
      user = User.currentUser;
      user.updateUserDetails(response.json, isNeedToSaveDetails: true);
    }
    return UserAuthenticationResponse(status: response.status, message: response.errMessage, data: user);
  }

//  Future<GetDriverResponse> getGetDriverApi() async {
//    final HttpResponse response = await this.postRequest(ApiType.driverDetail);
//    GetDriverModel getDriverModel;
//    if (response.status) {
//      getDriverModel = GetDriverModel.fromJson(response.json);
//    }
//    return GetDriverResponse(status: response.status, message: response.errMessage, data: getDriverModel);
//  }

  Future<GetDriverResponse> getGetDriverApi() async {
    final HttpResponse response = await this.postRequest(ApiType.driverDetail);
    GetDriverModel getDriverModel;
    if (response.status) {
      getDriverModel = GetDriverModel.fromJson(response.json);
    }
    return GetDriverResponse(status: response.status, message: response.errMessage, data: getDriverModel);
  }

  Future<GetDriverResponse> editDriverApi({EditDriverRequest params}) async {

    final HttpResponse response = await this.uploadRequest(ApiType.driverUpdate, params: params.toJson(), arrFile: params.arrFiles);
    GetDriverModel getDriverModel;
    if (response.status) {
      getDriverModel = GetDriverModel.fromJson(response.json);
    }

    return GetDriverResponse(status: response.status, message: response.errMessage, data: getDriverModel);

  }

  Future<CMSResponse> getCMSDetails() async {
    final HttpResponse response = await this.postRequest(ApiType.getCMSDetail);
    CMSModel cmsModel;
    if (response.status) {
      cmsModel = CMSModel.fromJson(response.json);
    }
    return CMSResponse(status: response.status, message: response.errMessage, data: cmsModel);
  }

  Future<BaseResponse> claimOrder({ClaimOrderRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.claimOrder, params: params.toJson());

    return BaseResponse(status: response.status, message: response.errMessage,);
  }

  Future<BaseResponse> flagUser({FlagUserRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.flagUser, params: params.toJson());

    return BaseResponse(status: response.status, message: response.errMessage,);
  }

  Future<BaseResponse> flagAddress({FlagAddressRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.flagAddress, params: params.toJson());

    return BaseResponse(status: response.status, message: response.errMessage,);
  }

  Future<OrderDetailsResponse> getOrderDetails({OrderDetailsRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.orderDetails, params: params.toJson());

    if (response.status) {
      return OrderDetailsResponse(status: response.status, message: response.errMessage,data: OrderDetailsData.fromJson(response.json));
    }
    return OrderDetailsResponse(status: response.status, message: response.errMessage,);
  }



  Future<BaseResponse> confirmOrderPickUp({ClaimOrderRequest params}) async {

    final HttpResponse response = await this.postRequest(ApiType.confirmOrderPickUp, params: params.toJson());

    return BaseResponse(status: response.status, message: response.errMessage,);
  }

  Future<BaseResponse> confirmOrderDropOff({OrderDropOffRequest params}) async {

    final HttpResponse response = await this.uploadRequest(ApiType.dropOffOrder,arrFile: params.arrFiles, params: params.toJson());

    return BaseResponse(status: response.status, message: response.errMessage,);
  }


  Future<NotificationSettingResponse> getNotificationSettingApi() async {
      final HttpResponse response = await this.getRequest(ApiType.getNotificationSetting,);
    NotificationSettingModel notificationSettingModel;
    if(response.status){
      notificationSettingModel = NotificationSettingModel.fromJson(response.json);
    }
    return NotificationSettingResponse(status: response.status,data: notificationSettingModel );
  }

  Future<UpdateNotificationSettingResponse> updateNotificationSettingApi({UpdateNotificationSettingRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.updateNotificationSetting, params: params.toJson());
    return UpdateNotificationSettingResponse(status: response.status, message: response.errMessage);
  }

  Future<ReviewResponse> getAllReviewListApi({ReviewRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.reviewList, params: params.toJson());
    ReviewModel reviewModel;
    if (response.status) {
      reviewModel = ReviewModel.fromJson(response.json);
    }
    return ReviewResponse(status: response.status, message: response.errMessage, data: reviewModel);
  }

  Future<NotificationListResponse> notificationListTypeApi({NotificationListRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.getNotificationList,params: params.toJson());
    NotificationListModel notificationListModel;
    if(response.status) {
      notificationListModel = NotificationListModel.fromJson(response.json);
    }
    return NotificationListResponse(status: response.status, message: response.errMessage, notificationListModel: notificationListModel);
  }

  Future<BaseResponse> deleteNotification({DeleteNotificationRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.deleteNotification, params: params.toJson());
    return BaseResponse(status: response.status, message: response.errMessage);
  }

  Future<AddBankDetailResponse> addBankDetailsApi({AddBankDetailRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.addBankDetails, params: params.toJson());
    AddBankDetailModel addBankDetailModel;
    if (response.status) {
      addBankDetailModel = AddBankDetailModel.fromJson(response.json);
    }
    else{
      addBankDetailModel = AddBankDetailModel.fromJson(response.json);
    }
    return AddBankDetailResponse(status: response.status, message: response.errMessage, data: addBankDetailModel);
  }

  Future<PaymentHistoryResponse> getAllPaymentHistorytApi({PaymentHistoryRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.paymentHistory, params: params.toJson());
    PaymentHistoryModel paymentHistoryModel;
    if (response.status) {
      paymentHistoryModel = PaymentHistoryModel.fromJson(response.json);
    }
    return PaymentHistoryResponse(status: response.status, message: response.errMessage, data: paymentHistoryModel);
  }

  Future<WithdrawAmountResponse> withdrawAmountApi({WithDrawAmountRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.withdrawAmount, params: params.toJson());
    WithdrawAmountModel withdrawAmountModel;
    if (response.status) {
      withdrawAmountModel = WithdrawAmountModel.fromJson(response.json);
    }else
      {
        withdrawAmountModel = WithdrawAmountModel.fromJson(response.json);
      }
    return WithdrawAmountResponse(status: response.status, message: response.errMessage, data: withdrawAmountModel);
  }

  Future<BaseResponse> logoutUser({LogoutRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.logout,params:params.toJson() );
    return BaseResponse(status: response.status, message: response.errMessage);
  }

  Future<BaseResponse> clearAllNotification() async {
    final HttpResponse response = await this.postRequest(ApiType.clearAllNtification );
    return BaseResponse(status: response.status, message: response.errMessage);
  }

  Future<CheckStripeAccountResponse> checkStripeAccountApi({CheckStripeAccountRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.checkStripeAccount, params: params.toJson());
    CheckStripeAccountModel checkStripeAccountModel;
    if (response.status) {
      checkStripeAccountModel = CheckStripeAccountModel.fromJson(response.json);
    }else
    {
      if(response.json!=null){
        checkStripeAccountModel = CheckStripeAccountModel.fromJson(response.json);
      }else
      checkStripeAccountModel = null;
    }
    return CheckStripeAccountResponse(status: response.status, message: response.errMessage, data: checkStripeAccountModel);
  }

  Future<BankListResponse> getAllBankList({BankListRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.getAllBankList,params: params.toJson());
    List<BankListModel> arr = List<BankListModel>();
    if (response.status) {
      if (response.json is List<dynamic>) {
        arr = BankListModel.getListData(response.json);
      }
//      return BankListResponse(status: response.status,message: response.errMessage, data: BankListModel.fromData(response.json));
    }
    return BankListResponse(status: response.status,message: response.errMessage,data: arr);
  }

  Future<BaseResponse> deleteBank({DeleteBankRequest params}) async {
    final HttpResponse response = await this.postRequest(ApiType.deleteBank, params: params.toJson());
    return BaseResponse(status: response.status, message: response.errMessage);
  }
}