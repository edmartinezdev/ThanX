import 'all_request.dart';
import 'all_response.dart';
import 'api_provider.dart';

class AppRepository {

  final apiApiProvider = ApiProvider();



  Future<UserAuthenticationResponse> signupApi({SignupRequest params}) => apiApiProvider.signupApi(params: params);

  Future<LoginResponse> loginApi({LoginRequest params}) => apiApiProvider.loginApi(params: params);

  Future<BaseResponse> checkEmailAndPhoneNumberApi({CheckEmailAndPhoneNumberRequest params}) => apiApiProvider.checkEmailAndPhoneNumberApi(params: params);

  Future<BaseResponse> forgotPasswordApi({ForgotPasswordRequest params}) => apiApiProvider.forgotPasswordApi(params: params);

  Future<AddVehicleInfoResponse> addVehicleApi({AddVehicleRequest params}) => apiApiProvider.addVehicleApi(params: params);

  Future<BaseResponse> addW9FormApi({AddW9FormRequest params}) => apiApiProvider.addW9FormApi(params: params);

  Future<MyJodsOrderListResponse> getAllMyJodsOrderListApi({MyJodsOrderListRequest params}) => apiApiProvider.getAllMyJodsOrderListApi(params: params);

  Future<BaseResponse> changePasswordApi({ChangePasswordRequest params}) => apiApiProvider.changePasswordApi(params: params);

  Future<OrderDetailsResponse> getOrderDetails({OrderDetailsRequest params}) => apiApiProvider.getOrderDetails(params: params);

  Future<BaseResponse> confirmOrderPickUp({ClaimOrderRequest params}) => apiApiProvider.confirmOrderPickUp(params: params);

  Future<BaseResponse> confirmDropOff({OrderDropOffRequest params}) => apiApiProvider.confirmOrderDropOff(params: params);

  Future<BaseResponse> claimOrder({ClaimOrderRequest params}) => apiApiProvider.claimOrder(params: params);

  Future<BaseResponse> flagUser({FlagUserRequest params}) => apiApiProvider.flagUser(params: params);

  Future<BaseResponse> flagAddress({FlagAddressRequest params}) => apiApiProvider.flagAddress(params: params);

  Future<MyCurrentOrderListResponse> getAllMyCurrentOrderListApi({MyCurrentOrderListRequest params}) => apiApiProvider.getAllMyCurrentOrderListApi(params: params);

  Future<CMSResponse> getCMSDetails() => apiApiProvider.getCMSDetails();

  Future<NotificationSettingResponse> getNotificationSettingApi() => apiApiProvider.getNotificationSettingApi();

  Future<UpdateNotificationSettingResponse> updateNotificationSettingApi({UpdateNotificationSettingRequest params}) => apiApiProvider.updateNotificationSettingApi(params: params);

  Future<UserProfileResponse> getUserProfileApi() => apiApiProvider.getUserProfileApi();

  Future<UserAuthenticationResponse> updateUserProfileApi({EditProfileRequest params}) => apiApiProvider.updateUserProfileApi(params: params);

  Future<GetDriverResponse> getGetDriverApi() => apiApiProvider.getGetDriverApi();

  Future<GetDriverResponse> editDriverApi({EditDriverRequest params}) => apiApiProvider.editDriverApi(params: params);

  Future<ReviewResponse> getAllReviewListApi({ReviewRequest params}) => apiApiProvider.getAllReviewListApi(params: params);

  Future<BaseResponse> logoutUser({LogoutRequest params}) => apiApiProvider.logoutUser(params: params);

  Future<NotificationListResponse> notificationListTypeApi({NotificationListRequest params}) => apiApiProvider.notificationListTypeApi(params: params);

  Future<BaseResponse> deleteNotification({DeleteNotificationRequest request}) => apiApiProvider.deleteNotification(params: request);

  Future<AddBankDetailResponse> addBankDetailsApi({AddBankDetailRequest params}) => apiApiProvider.addBankDetailsApi(params: params);

  Future<PaymentHistoryResponse> getAllPaymentHistorytApi({PaymentHistoryRequest params}) => apiApiProvider.getAllPaymentHistorytApi(params: params);

  Future<WithdrawAmountResponse> withdrawAmountApi({WithDrawAmountRequest params}) => apiApiProvider.withdrawAmountApi(params: params);

  Future<CheckStripeAccountResponse> checkStripeAccountApi({CheckStripeAccountRequest params}) => apiApiProvider.checkStripeAccountApi(params: params);

  Future<BaseResponse> clearAllNotification() => apiApiProvider.clearAllNotification();

  Future<BankListResponse> getAllBankList({BankListRequest params}) => apiApiProvider.getAllBankList(params: params);

  Future<BaseResponse> deleteBank({DeleteBankRequest params}) => apiApiProvider.deleteBank(params: params);

}