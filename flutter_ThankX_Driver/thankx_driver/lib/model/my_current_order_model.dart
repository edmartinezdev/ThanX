class MyCurrentOrderModel {
  int totalRecord;
  int count;
  List<MyOrders> myOrders;

  MyCurrentOrderModel({this.totalRecord, this.myOrders, this.count});

  MyCurrentOrderModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    count = json['count'];
    if (json['myOrders'] != null) {
      myOrders = new List<MyOrders>();
      json['myOrders'].forEach((v) {
        myOrders.add(new MyOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    data['count'] = this.count;
    if (this.myOrders != null) {
      data['myOrders'] = this.myOrders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyOrders {
  String sId;
  String orderNumber;
  int orderStatus;
  String orderName;
  PickupLocation pickupLocation;
  int pickupCMType;
  String pickupUserName;
  String pickupUserPhoneNumber;
  PickupLocation dropoffLocation;
  int dropoffCMType;
  String dropoffUserName;
  String dropoffUserPhoneNumber;
  String distance;
  String itemTitle;
  String itemType;
  int itemSize;
  int weight;
  int itemQuantity;
  bool fragile;
  String notes;
  DeliveryType deliveryType;
  String createdAt;

  MyOrders(
      {this.sId,
        this.orderNumber,
        this.orderStatus,
        this.orderName,
        this.pickupLocation,
        this.pickupCMType,
        this.pickupUserName,
        this.pickupUserPhoneNumber,
        this.dropoffLocation,
        this.dropoffCMType,
        this.dropoffUserName,
        this.dropoffUserPhoneNumber,
        this.distance,
        this.itemTitle,
        this.itemType,
        this.itemSize,
        this.weight,
        this.itemQuantity,
        this.fragile,
        this.notes,
        this.deliveryType,
        this.createdAt});

  MyOrders.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderNumber = json['orderNumber'];
    orderStatus = json['orderStatus'];
    orderName = json['orderName'];
    pickupLocation = json['pickupLocation'] != null
        ? new PickupLocation.fromJson(json['pickupLocation'])
        : null;
    pickupCMType = json['pickupCMType'];
    pickupUserName = json['pickup_user_name'];
    pickupUserPhoneNumber = json['pickup_user_phoneNumber'];
    dropoffLocation = json['dropoffLocation'] != null
        ? new PickupLocation.fromJson(json['dropoffLocation'])
        : null;
    dropoffCMType = json['dropoffCMType'];
    dropoffUserName = json['dropoff_user_name'];
    dropoffUserPhoneNumber = json['dropoff_user_phoneNumber'];
    distance = json['distance'];
    itemTitle = json['itemTitle'];
    itemType = json['itemType'];
    itemSize = json['itemSize'];
    weight = json['weight'];
    itemQuantity = json['itemQuantity'];
    fragile = json['fragile'];
    notes = json['notes'];
    deliveryType = json['deliveryType'] != null
        ? new DeliveryType.fromJson(json['deliveryType'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderNumber'] = this.orderNumber;
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
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class PickupLocation {
  String address;
  double latitude;
  double longitude;

  PickupLocation({this.address, this.latitude, this.longitude});

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

  DeliveryType({this.sId, this.name, this.description, this.time, this.amount});

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