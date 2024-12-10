class BankListModel {
  String id;
  String object;
  String account;
  String accountHolderName;
  String accountHolderType;
  String bankName;
  String country;
  String currency;
  bool defaultForCurrency;
  String fingerprint;
  String last4;
  Metadata metadata;
  String routingNumber;
  String status;

  BankListModel({this.id, this.object, this.account, this.accountHolderName, this.accountHolderType, this.bankName, this.country, this.currency, this.defaultForCurrency, this.fingerprint, this.last4, this.metadata, this.routingNumber, this.status});

  BankListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    account = json['account'];
    accountHolderName = json['account_holder_name'];
    accountHolderType = json['account_holder_type'];
    bankName = json['bank_name'];
    country = json['country'];
    currency = json['currency'];
    defaultForCurrency = json['default_for_currency'];
    fingerprint = json['fingerprint'];
    last4 = json['last4'];
    metadata = json['metadata'] != null ? new Metadata.fromJson(json['metadata']) : null;
    routingNumber = json['routing_number'];
    status = json['status'];
  }

  static List<BankListModel> getListData(List<dynamic> json){
    if (json != null) {
      List<BankListModel> data = new List<BankListModel>();
      json.forEach((v) {data.add(new BankListModel.fromJson(v));});
      return data;
    }else return [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['object'] = this.object;
    data['account'] = this.account;
    data['account_holder_name'] = this.accountHolderName;
    data['account_holder_type'] = this.accountHolderType;
    data['bank_name'] = this.bankName;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['default_for_currency'] = this.defaultForCurrency;
    data['fingerprint'] = this.fingerprint;
    data['last4'] = this.last4;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['routing_number'] = this.routingNumber;
    data['status'] = this.status;
    return data;
  }
}

class Metadata {


//  Metadata({});

Metadata.fromJson(Map<String, dynamic> json) {
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}
}
