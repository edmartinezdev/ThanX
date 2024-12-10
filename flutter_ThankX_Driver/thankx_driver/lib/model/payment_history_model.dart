import 'package:thankxdriver/utils/app_dateformat.dart';
import 'package:thankxdriver/utils/date_utils.dart';

class PaymentHistoryModel {
  String accountNumber;
  int totalRecord;
  double totalAmount = 0;
  List<PaymentHistory> paymentHistory;


  PaymentHistoryModel({this.accountNumber,this.totalRecord, this.totalAmount = 0 , this.paymentHistory});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    totalRecord = json['totalRecord'];
    totalAmount = double.parse((json['totalAmount']?? 0.00 ).toString()) ?? 0.0 ;
    if (json['paymentHistory'] != null) {
      paymentHistory = new List<PaymentHistory>();
      json['paymentHistory'].forEach((v) {
        paymentHistory.add(new PaymentHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountNumber'] = this.accountNumber;
    data['totalRecord'] = this.totalRecord;
    data['totalAmount'] = this.totalAmount;
    if (this.paymentHistory != null) {
      data['paymentHistory'] =
          this.paymentHistory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentHistory {
  String sId;
  String driverId;
  String orderId;
  double amount;
  String commissionAmount;
  int paymentType;
  bool isPaymentClaimed;
  String createdAt;

  String get convertedDateForEdit {
    DateTime dateTime = DateUtilss.stringToDate(this.createdAt, format: AppDataFormat.serverDateTimeFormat1);
    return DateUtilss.dateToString(dateTime, format: AppDataFormat.showDateFormatForApp);
  }

  PaymentHistory(
      {this.sId,
        this.driverId,
        this.orderId,
        this.amount,
        this.commissionAmount,
        this.paymentType,
        this.isPaymentClaimed,
        this.createdAt});

      PaymentHistory.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        driverId = json['driverId'];
        orderId = json['orderId'];
        amount =double.parse((json['amount']?? 0.00 ).toString());
        commissionAmount = json['commissionAmount'];
        paymentType = json['paymentType'];
        isPaymentClaimed = json['isPaymentClaimed'];
        createdAt = json['createdAt'];
      }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driverId'] = this.driverId;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['commissionAmount'] = this.commissionAmount;
    data['paymentType'] = this.paymentType;
    data['isPaymentClaimed'] = this.isPaymentClaimed;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
