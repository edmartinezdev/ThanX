class AddBankDetailModel {
  String userId;
  String country;
  String currency;
  String accHolderName;
  String bankName;
  String routingNumber;
  String accountNumber;
  String email;


  AddBankDetailModel(
      {this.userId,
      this.country,
      this.currency,
      this.accHolderName,
      this.bankName,
      this.routingNumber,
      this.accountNumber,
      this.email});

  AddBankDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    country = json['country'];
    currency = json['currency'];
    accHolderName = json['accHolderName'];
    bankName = json['bankName'];
    routingNumber = json['routingNumber'];
    accountNumber = json['accountNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['accHolderName'] = this.accHolderName;
    data['bankName'] = this.bankName;
    data['routingNumber'] = this.routingNumber;
    data['accountNumber'] = this.accountNumber;
    data['email'] = this.email;
    return data;
  }
}
