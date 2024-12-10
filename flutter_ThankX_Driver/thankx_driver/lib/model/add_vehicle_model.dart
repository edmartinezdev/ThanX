class AddVehicleInfoModel {
  String updatedAt;
  String createdAt;
  String sId;
  String driverId;
  String make;
  String model;
  String year;
  String licenceNumber;
  String photo;
  String vehicleRegistration;
  String vehicleInsurance;
  String w9Form;

  AddVehicleInfoModel(
      {this.updatedAt,
      this.createdAt,
      this.sId,
      this.driverId,
      this.make,
      this.model,
      this.year,
      this.licenceNumber,
      this.photo,
      this.vehicleRegistration,
      this.vehicleInsurance,
      this.w9Form = ''});

  AddVehicleInfoModel.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    sId = json['_id'];
    driverId = json['driverId'];
    make = json['make'];
    model = json['model'];
    year = json['year'];
    licenceNumber = json['licenceNumber'];
    photo = json['photo'];
    vehicleRegistration = json['vehicleRegistration'];
    vehicleInsurance = json['vehicleInsurance'];
    w9Form = json['w9Form'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['_id'] = this.sId;
    data['driverId'] = this.driverId;
    data['make'] = this.make;
    data['model'] = this.model;
    data['year'] = this.year;
    data['licenceNumber'] = this.licenceNumber;
    data['photo'] = this.photo;
    data['vehicleRegistration'] = this.vehicleRegistration;
    data['vehicleInsurance'] = this.vehicleInsurance;
    data['w9Form'] = this.w9Form ?? '';
    return data;
  }
}
