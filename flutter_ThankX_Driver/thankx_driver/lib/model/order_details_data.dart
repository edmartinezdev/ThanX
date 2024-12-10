import 'package:thankxdriver/utils/app_dateformat.dart';
import 'package:thankxdriver/utils/date_utils.dart';

class OrderDetailsData {
  String sId;
  String orderNumber;
  String orderId;
  String stripeCustomerId;
  int orderStatus;
  String orderName;
  PickupLocation pickupLocation;
  int pickupCMType;
  String pickupUserName;
  String pickupUserPhoneNumber;
  UserDetails pickUpUser;
  String amount;
  UserDetails dropOffuser;
  PickupLocation dropoffLocation;
  int dropoffCMType;
  String dropoffUserName;
  String dropoffUserPhoneNumber;
  String distance;
  String itemTitle;
  String itemType;
  int itemSize;
  int weight;
  String itemQuantity;
  bool fragile;
  String notes;
  DeliveryType deliveryType;
  String paymentCardId;
  String createdAt;
  CardDetails cardDetails;
  String userId ;
  DriverDetails driverDetails;
  VehicleDetails vehicleDetails;
  double driverAmount;
  String overviewPolyline = "";
  String confirmationCode;
  bool atHome;


  String get convertedDateForEdit {
    DateTime dateTime = DateUtilss.stringToDate(this.createdAt, format: AppDataFormat.serverDateTimeFormat3);
    return DateUtilss.dateToString(dateTime, format: AppDataFormat.showDateFormatForApp);
  }

  static final PickupLocation location =  PickupLocation();

  OrderDetailsData(
      {this.sId ="",
        this.orderNumber = "",
        this.orderId= " ",
        this.stripeCustomerId= "",
        this.orderStatus=1,
        this.orderName= "",
        this.pickupLocation ,
        this.pickupCMType = 1,
        this.pickupUserName ="",
        this.pickupUserPhoneNumber= "",
        this.dropoffLocation,
        this.dropoffCMType=1,
        this.dropoffUserName="",
        this.dropoffUserPhoneNumber='',
        this.distance= "0 mi",
        this.itemTitle = "",
        this.itemType = "",
        this.amount = "1",
        this.itemSize= 1,
        this.weight = 0,
        this.itemQuantity= "",
        this.fragile = false,
        this.notes= "",
        this.deliveryType,
        this.paymentCardId = "",
        this.createdAt = " ",
        this.cardDetails,
        this.userId = "",
        this.driverAmount = 0.0,
        this.confirmationCode = "0000",
        this.overviewPolyline = "",
        this.atHome = true
      });

  OrderDetailsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? "";
    orderId = json['orderId']?? " ";
    orderNumber = json['orderNumber']?? " ";
    stripeCustomerId = json['stripeCustomerId']?? "";
    orderStatus = json['orderStatus'] ?? 0;
    orderName = json['orderName'] ?? "";
    pickupLocation = json['pickupLocation'] != null
        ? new PickupLocation.fromJson(json['pickupLocation'])
        : PickupLocation();
    pickUpUser = json['pickupUserDetails'] != null ? new UserDetails.fromJson(json['pickupUserDetails']) : UserDetails();
    dropOffuser = json['dropOffUserDetails'] != null ? new UserDetails.fromJson(json['dropOffUserDetails']) : UserDetails();
    pickupCMType = json['pickupCMType'] ?? 1;
    pickupUserName = json['pickup_user_name']?? "";
    pickupUserPhoneNumber = json['pickup_user_phoneNumber']??" ";
    dropoffLocation = json['dropoffLocation'] != null
        ? new PickupLocation.fromJson(json['dropoffLocation'])
        : PickupLocation();
    dropoffCMType = json['dropoffCMType']?? 1;
    dropoffUserName = json['dropoff_user_name'] ?? "";
    dropoffUserPhoneNumber = json['dropoff_user_phoneNumber']?? "" ;
    distance = json['distance'].toString() ?? " ";
    itemTitle = json['itemTitle'] ?? '';
    itemType = json['itemType']?? "";
    amount = json['amount'] ?? "1";
    itemSize = json['itemSize'] ?? "";
    weight = json['weight'] ?? 0;
    itemQuantity = json['itemQuantity'].toString() ?? '';
    fragile = json['fragile']?? false;
    notes = json['notes'] ?? "";
    deliveryType = json['deliveryType'] != null
        ? new DeliveryType.fromJson(json['deliveryType'])
        : DeliveryType();
    paymentCardId = json['paymentCardId'] ?? "";
    createdAt = json['createdAt'] ?? "";
    userId = json['userId'] ?? "";
    cardDetails = json['cardDetails'] != null
        ? new CardDetails.fromJson(json['cardDetails'])
        : CardDetails();
    driverDetails = json['driverDetails'] != null
        ? new DriverDetails.fromJson(json['driverDetails'])
        : null;
    vehicleDetails = json['vehicleDetails'] != null
        ? new VehicleDetails.fromJson(json['vehicleDetails'])
        : null;
    driverAmount = double.parse((json['driverAmount'] ?? 0.0).toString()) ?? 0.0;
    overviewPolyline = json['overview_polyline'] ?? '';
    confirmationCode = (json['confirmationCode']??"0000").toString();
    atHome = json['atHome'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderNumber'] = this.orderNumber;
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['orderStatus'] = this.orderStatus;
    data['orderName'] = this.orderName;
    if (this.pickupLocation != null) {
      data['pickupLocation'] = this.pickupLocation.toJson();
    }
    data['pickupCMType'] = this.pickupCMType;
    data['pickup_user_name'] = this.pickupUserName;
    data['pickup_user_phoneNumber'] = this.pickupUserPhoneNumber;
    if (this.dropoffLocation != null) {
      data['dropoffLocation'] = this.dropoffLocation.toJson();
    }
    data['dropoffCMType'] = this.dropoffCMType;
    data['dropoff_user_name'] = this.dropoffUserName;
    data['dropoff_user_phoneNumber'] = this.dropoffUserPhoneNumber;
    data['distance'] = this.distance;
    data['itemTitle'] = this.itemTitle;
    data['itemType'] = this.itemType;
    data['itemSize'] = this.itemSize;
    data['weight'] = this.weight;
    data['itemQuantity'] = this.itemQuantity;
    data['fragile'] = this.fragile;
    data['notes'] = this.notes;
    if (this.deliveryType != null) {
      data['deliveryType'] = this.deliveryType.toJson();
    }
    data['paymentCardId'] = this.paymentCardId;
    data['createdAt'] = this.createdAt;
    if (this.cardDetails != null) {
      data['cardDetails'] = this.cardDetails.toJson();
    }
    return data;
  }
}

class VehicleDetails {
  String model;
  String year;
  String make;
  String licenceNumber;

  VehicleDetails({this.model, this.year, this.make, this.licenceNumber});

  VehicleDetails.fromJson(Map<String, dynamic> json) {
    model = json['model'] ?? " ";
    year = json['year'] ?? " ";
    make = json['make'] ?? " ";
    licenceNumber = json['licenceNumber'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['year'] = this.year;
    data['make'] = this.make;
    data['licenceNumber'] = this.licenceNumber;
    return data;
  }
}

class DriverDetails {
  String sId;
  String firstname;
  String lastname;
  String contactNumber;
  String countryCode;
  String profilePicture;
  int totalAvgRating;

  DriverDetails(
      {this.sId= "",
        this.firstname= " ",
        this.lastname= " ",
        this.contactNumber= " "  ,
        this.countryCode= " ",
        this.profilePicture= " ",
        this.totalAvgRating = 0
      });

  DriverDetails.fromJson(Map<String, dynamic> json) {

    sId = json['_id'] ?? " ";
    firstname = json['firstname'] ?? " ";
    lastname = json['lastname'] ??  " ";
    contactNumber = json['contactNumber'] ?? " ";
    countryCode = json['countryCode'] ?? " ";
    profilePicture = json['profilePicture'] ?? " ";
    totalAvgRating = double.parse((json['totalAvgRating'] ?? 0.0).toString()).round();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['contactNumber'] = this.contactNumber;
    data['countryCode'] = this.countryCode;
    data['profilePicture'] = this.profilePicture;
    data['totalAvgRating'] = this.totalAvgRating;
    return data;
  }
}

class PickupLocation {
  String address;
  double latitude;
  double longitude;

  PickupLocation({this.address = "", this.latitude= 0.00, this.longitude= 0.00});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class DeliveryType {
  String sId;
  String name;
  String description;
  String time;
  String amount;

  DeliveryType({this.sId =  "", this.name = "", this.description = "", this.time = " ", this.amount= ""});

  DeliveryType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    time = json['time'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['time'] = this.time;
    data['amount'] = this.amount;
    return data;
  }
}

class CardDetails {
  String brand;
  String addressZip;
  String last4;

  CardDetails({this.brand = "", this.addressZip = " ", this.last4 = ""});

  CardDetails.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    addressZip = json['address_zip'];
    last4 = json['last4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand'] = this.brand;
    data['address_zip'] = this.addressZip;
    data['last4'] = this.last4;
    return data;
  }
}
class UserDetails {
  String firstname;
  String lastname;
  String contactNumber;
  String countryCode;
  String profilePicture;

  UserDetails(
      {this.firstname= "",
        this.lastname = "",
        this.contactNumber= "",
        this.countryCode= " ",
        this.profilePicture= ""});

  UserDetails.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'] ?? "";
    lastname = json['lastname'] ?? "";
    contactNumber = json['contactNumber']?? " ";
    countryCode = json['countryCode']?? "";
    profilePicture = json['profilePicture']?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['contactNumber'] = this.contactNumber;
    data['countryCode'] = this.countryCode;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}