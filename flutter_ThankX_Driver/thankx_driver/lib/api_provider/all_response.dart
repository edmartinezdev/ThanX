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

class BaseResponse extends Object {
  bool status;
  String message;

  BaseResponse({this.status, this.message});
}

// login response
class LoginResponse {
  bool status;
  String message;
  User data;

  LoginResponse({this.status, this.message, this.data});
}
//endregion


//region SignUpResponse
class UserAuthenticationResponse extends Object {
  bool status;
  String message;
  User data;

  UserAuthenticationResponse({this.status, this.message, this.data});
}
//endregion


//vehicle Response
class AddVehicleInfoResponse {
  bool status;
  String message;
  AddVehicleInfoModel data;

  AddVehicleInfoResponse({this.status, this.message, this.data});

}


//Order list Response
class  MyJodsOrderListResponse {
  bool status;
  String message;
  MyJodsOrderModel  myJodsOrderList;

  MyJodsOrderListResponse({this.status, this.message, this.myJodsOrderList});
}
//endregion



//My current order
class MyCurrentOrderListResponse {
  bool status;
  String message;
  MyCurrentOrderModel myCurrentOrderList;

  MyCurrentOrderListResponse({this.status, this.message, this.myCurrentOrderList});
}
//endregion


class OrderDetailsResponse {
  bool status;
  String message;
  OrderDetailsData data;

  OrderDetailsResponse({this.status, this.message, this.data});

}

class CMSResponse {
  bool status;
  String message;
  CMSModel data;

  CMSResponse({this.status, this.message, this.data});

  CMSResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new CMSModel.fromJson(json['data']) : null;
  }
}


class NotificationSettingResponse {
  bool status;
  NotificationSettingModel data;

  NotificationSettingResponse({this.status, this.data});

}

class UpdateNotificationSettingResponse {
  bool status;
  String message;
  NotificationSettingModel data;

  UpdateNotificationSettingResponse({this.status,this.message, this.data});

}

//region User Profile Response
class UserProfileResponse {
  bool status;
  String message;
  UserProfileModel data;

  UserProfileResponse({this.status, this.message, this.data});

}
//endrgion


//region review response

class ReviewResponse {
  bool status;
  String message;
  ReviewModel data;

  ReviewResponse({this.status, this.message, this.data});
}
//endregion


//get driver model
class GetDriverResponse {
  bool status;
  String message;
  GetDriverModel data;

  GetDriverResponse({this.status, this.message, this.data});
}
//endregion

class NotificationListResponse {
  bool status;
  String message;
  NotificationListModel notificationListModel;

  NotificationListResponse({this.status, this.message, this.notificationListModel});

}


class AddBankDetailResponse {
  bool status;
  String message;
  AddBankDetailModel data;

  AddBankDetailResponse({this.status, this.message, this.data});

}

class PaymentHistoryResponse {
  bool status;
  String message;
  PaymentHistoryModel data;

  PaymentHistoryResponse({this.status, this.message, this.data});

}

class WithdrawAmountResponse {
  bool status;
  String message;
  WithdrawAmountModel data;

  WithdrawAmountResponse({this.status, this.message, this.data});
}


class CheckStripeAccountResponse {
  bool status;
  String message;
  CheckStripeAccountModel data;

  CheckStripeAccountResponse({this.status, this.message, this.data});

  CheckStripeAccountResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new CheckStripeAccountModel.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}


class BankListResponse {
  bool status;
  String message;
  List<BankListModel> data;

  BankListResponse({this.status, this.message, this.data});

  BankListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<BankListModel>();
      json['data'].forEach((v) { data.add(new BankListModel.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}