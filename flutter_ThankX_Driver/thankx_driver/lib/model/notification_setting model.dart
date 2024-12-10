//class NotificationSettingModel {
//  bool chatNotification;
//  bool resourceNotification;
//
//  NotificationSettingModel({this.chatNotification = true, this.resourceNotification = true});
//
//  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
//    chatNotification = json['chatNotification'];
//    resourceNotification = json['resourceNotification'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['chatNotification'] = this.chatNotification;
//    data['resourceNotification'] = this.resourceNotification;
//    return data;
//  }
//}


class NotificationSettingModel {
  String sId;
  String userId;
  bool confirmOrder;
  bool orderStatus ;
  bool newOrder;
  bool newReviewReceived ;

  NotificationSettingModel(
      {this.sId,
        this.userId,
        this.confirmOrder = true ,
        this.orderStatus = true,
        this.newOrder = true,
        this.newReviewReceived = true});

  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    confirmOrder = json['confirm_order'];
    orderStatus = json['order_status'];
    newOrder = json['new_order'];
    newReviewReceived = json['new_review_received'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['confirm_order'] = this.confirmOrder;
    data['order_status'] = this.orderStatus;
    data['new_order'] = this.newOrder;
    data['new_review_received'] = this.newReviewReceived;
    return data;
  }
}
