// region signup Request
import 'dart:io';

import 'package:thankxdriver/model/user.dart';
import 'package:thankxdriver/utils/device_utils.dart';

import 'api_constant.dart';



// region login Request
class LoginRequest {
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;

    return data;
  }
}
//endregion

// region login Request
class FlagUserRequest {
  String userId = '';
  String flaggedUserId = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] =  User.currentUser.sId;
    data['flaggedUserId'] = this.flaggedUserId;

    return data;
  }
}
//endregion


// region login Request
class FlagAddressRequest {
  String userId = '';
  String address = '';
  double latitude ;
  double longitude ;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] =  User.currentUser.sId;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;

    return data;
  }
}
//endregion

// region signup Request
class SignupRequest {
  String firstname;
  String lastname;
  String contactNumber ;
  String email;
  String password;
  File selectedFile;

  List<AppMultiPartFile> get arrFiles {
    if (this.selectedFile== null) {
      return [];
    }
    List<AppMultiPartFile> _files = [];
    _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'profilePicture'));
    return _files;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    data['password'] = this.password;

    return data;
  }
}
//endregion

//region check email and phone number password
class CheckEmailAndPhoneNumberRequest {
  String userType;
  String email;
  String contactNumber;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;

    return data;
  }
}
//endregion

//region Forgot password
class ForgotPasswordRequest {
  String email = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;

    return data;
  }
}
//endregion

// region Add vehicle Request
class AddVehicleRequest {
  String make;
  String model;
  String year ;
  String licenceNumber;
  File selectedFile;
  File selectedFile2;
  File selectedFile3;
  File selectedFile4;
  File licenceFront;
  File licenceBack;
  File registration;
  File insurance;

  List<AppMultiPartFile> get arrFiles {
    if (this.selectedFile== null ) {
      return [];
    }
    List<AppMultiPartFile> _files = [];
    _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'photo'));
    _files.add(AppMultiPartFile(localFile: [selectedFile2], key: 'photo2'));
    _files.add(AppMultiPartFile(localFile: [selectedFile3], key: 'photo3'));
    _files.add(AppMultiPartFile(localFile: [selectedFile4], key: 'photo4'));
    _files.add(AppMultiPartFile(localFile: [licenceFront], key: 'licenceFront'));
    _files.add(AppMultiPartFile(localFile: [licenceBack], key: 'licenceBack'));
    _files.add(AppMultiPartFile(localFile: [registration], key: 'vehicleRegistration'));
    _files.add(AppMultiPartFile(localFile: [insurance], key: 'vehicleInsurance'));
    return _files;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['make'] = this.make;
    data['model'] = this.model;
    data['year'] = this.year;
    data['licenceNumber'] = this.licenceNumber;

    return data;
  }
}
//endregion

//region Order Detail Request
class  MyJodsOrderListRequest {
  String userId = '';
  String resultType = '';
  int limit;
  int offset;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['resultType'] = this.resultType;
    data['limit'] = this.limit;
    data['offset'] = this.offset;

    return data;
  }
}
//endregion

 //region Change Password Request
class ChangePasswordRequest {
  String userId = '';
  String currentPassword = '';
  String newPassword = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['currentPassword'] = this.currentPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
//endregionon


class OrderDetailsRequest {
  String orderId = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    return data;
  }
}

//region My current order Detail Request
class MyCurrentOrderListRequest {
  String userId = '';
  int limit;
  int offset;
  double lat;
  double long;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['limit'] = this.limit;
    data['offset'] = this.offset;

    return data;
  }
}
//endregion

class ClaimOrderRequest {
  String userId = '';
  String orderId = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['orderId'] = orderId;

    return data;
  }
}

class OrderDropOffRequest {
  String userId = '';
  String orderId = '';
  String confirmationCode = '';
  String dropMessage = "";
  File selectedFile;

  List<AppMultiPartFile> get arrFiles {
    if (this.selectedFile== null) {
      return [];
    }
    List<AppMultiPartFile> _files = [];
    _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'orderDropPicture'));
    return _files;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['orderId'] = orderId;
    data['confirmationCode'] = confirmationCode;
    data['dropMessage'] = dropMessage;
    return data;
  }
}

// region Add W9Form Request
class AddW9FormRequest {
  File selectedFile;

  List<AppMultiPartFile> get arrFiles {
    if (this.selectedFile== null ) {
      return [];
    }
    List<AppMultiPartFile> _files = [];
    _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'w9Form'));
    return _files;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }
}
//endregion

// region notificatio On And Off Request
class UpdateNotificationSettingRequest {
  bool confirm_order;
  bool order_status;
  bool new_order;
  bool new_review_received;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['confirm_order'] =this.confirm_order;
    data['order_status'] = this.order_status;
    data['new_order'] = this.new_order;
    data['new_review_received'] = this.new_review_received;
    return data;
  }
}
//endregion

// region Edit Profile Request
class EditProfileRequest {
  String firstname = '';
  String lastname = '';
  String contactNumber = '';
  String userType = '';
  String userId = '';
  File selectedFile;

  List<AppMultiPartFile> get arrFiles {
    if (this.selectedFile == null) {
      return [];
    }
    List<AppMultiPartFile> _files = [];
    _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'profilePicture'));
    return _files;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['contactNumber'] = this.contactNumber;
    data['userType'] = this.userType;

    return data;
  }
}
//endregion

//region review Request
class ReviewRequest {
  String userId = '';
  int limit;
  int offset;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['limit'] = this.limit;
    data['offset'] = this.offset;

    return data;
  }
}
//endregion

// region Update Driver Request
class EditDriverRequest {
  String make;
  String model;
  String year ;
  String licenceNumber;
  File selectedFile;
  File selectedFile2;
  File selectedFile3;
  File selectedFile4;
  File registration;
  File insurance;
  File licenceFront;
  File licenceBack;

  List<AppMultiPartFile> get arrFiles {
    List<AppMultiPartFile> _files = [];
    if (selectedFile != null) _files.add(AppMultiPartFile(localFile: [selectedFile], key: 'photo'));
    if (selectedFile2 != null) _files.add(AppMultiPartFile(localFile: [selectedFile2], key: 'photo2'));
    if (selectedFile3 != null) _files.add(AppMultiPartFile(localFile: [selectedFile3], key: 'photo3'));
    if (selectedFile4 != null) _files.add(AppMultiPartFile(localFile: [selectedFile4], key: 'photo4'));
    if (registration != null) _files.add(AppMultiPartFile(localFile: [registration], key: 'vehicleRegistration'));
    if (insurance != null) _files.add(AppMultiPartFile(localFile: [insurance], key: 'vehicleInsurance'));
    if (licenceFront != null) _files.add(AppMultiPartFile(localFile: [licenceFront], key: 'licenceFront'));
    if (licenceBack != null) _files.add(AppMultiPartFile(localFile: [licenceBack], key: 'licenceBack'));
    return _files;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['make'] = this.make;
    data['model'] = this.model;
    data['year'] = this.year;
    data['licenceNumber'] = this.licenceNumber;

    return data;
  }
}
//endregion

//region Notification list Request
class NotificationListRequest {
  String userId = '';
  int limit;
  int offset;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['limit'] = this.limit;
    data['offset'] = this.offset;

    return data;
  }
}
//endregion

//region delete Notification Request
class DeleteNotificationRequest {
  String notificationId = '';
//  String userId = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_Id'] = this.notificationId;

    return data;
  }
}
//endregion


// region Logout Request
class LogoutRequest {

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = DeviceUtil().deviceId;
    return data;
  }
}
//endregion


// region add bank details Request
class AddBankDetailRequest {
  String userId;
  String accHolderName;
  String bankName ;
  String accountNumber;
  String routingNumber;
  String ssnNumber;
  String address;
  String pincode;
  String city;
  String state;
  String day;
  String month;
  String year;
  String email;
  String phoneNumber;



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['accHolderName'] = this.accHolderName;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['routingNumber'] = this.routingNumber;
    data['ssn_last_4'] = this.ssnNumber;
    data['line1'] = this.address;
    data['postal_code'] = this.pincode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;


    return data;
  }
}
//endregion


//region Payment History Request
class PaymentHistoryRequest {
  String userId = '';
  int limit;
  int offset;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['limit'] = this.limit;
    data['offset'] = this.offset;

    return data;
  }
}
//endregion

//region withdraw amount Request
class WithDrawAmountRequest {
  String userId = '';
  double amount;
  String bankAccountId;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = User.currentUser.sId;
    data['amount'] = this.amount;
    data['bankAccountId'] = this.bankAccountId;

    return data;
  }
}
//endregion

//region stripe account Request
class CheckStripeAccountRequest {
  String userId = '';


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;

    return data;
  }
}
//endregion

//region Bank List Request
class BankListRequest {
  String userId = '';


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;

    return data;
  }
}
//endregion

//region DeleteBank Request
class DeleteBankRequest {
  String bankAccountId;
  String userId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankAccountId'] = this.bankAccountId;
    data['userId'] = User.currentUser.sId;
    return data;
  }
}
//endregion
