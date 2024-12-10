class NotificationListModel {
  int totalRecord;
  List<MyNotification> myNotification;

  NotificationListModel({this.totalRecord, this.myNotification});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    if (json['myNotification'] != null) {
      myNotification = new List<MyNotification>();
      json['myNotification'].forEach((v) {
        myNotification.add(new MyNotification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalRecord'] = this.totalRecord;
    if (this.myNotification != null) {
      data['myNotification'] =
          this.myNotification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyNotification {
  String sId;
  String senderId;
  String receiverId;
  int notificationType;
  String orderId;
  int orderStatus;
  Data data;
  bool isView;

  MyNotification(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.notificationType,
      this.orderId,
      this.data,
      this.orderStatus,
      this.isView});

  MyNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    notificationType = json['notificationType'];
    orderId = json['orderId'] ?? "";
    data = json['data'] != null
        ? new Data.fromJson(json['data'])
        : null;
    isView = json['isView'];
    orderStatus = int.parse((json['orderStatus'] ?? 0).toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['notificationType'] = this.notificationType;
    data['orderId'] = this.orderId;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['isView'] = this.isView;
    return data;
  }
}

class Data {
  String title;
  String message;
  String type;
  Data({this.title, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}
