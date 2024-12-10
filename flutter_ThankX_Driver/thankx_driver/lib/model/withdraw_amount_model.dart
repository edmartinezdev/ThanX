class WithdrawAmountModel {
  bool isBankAdded;

  WithdrawAmountModel({this.isBankAdded = false});

  WithdrawAmountModel.fromJson(Map<String, dynamic> json) {
    isBankAdded = json['isBankAdded'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isBankAdded'] = this.isBankAdded;
    return data;
  }
}
