class GetDriverModel {
  String sId;
  String driverId;
  String make;
  String model;
  String year;
  String licenceNumber;
  String photo;
  String photo2;
  String photo3;
  String photo4;
  String licenceFront;
  String licenceBack;
  String vehicleRegistration;
  String vehicleInsurance;
  String w9Form;

  GetDriverModel(
      {this.sId,
        this.driverId,
        this.make,
        this.model,
        this.year,
        this.licenceNumber,
        this.photo,
        this.photo2,
        this.photo3,
        this.photo4,
        this.licenceFront,
        this.licenceBack,
        this.vehicleRegistration,
        this.vehicleInsurance,
        this.w9Form});

  GetDriverModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    driverId = json['driverId'];
    make = json['make'];
    model = json['model'];
    year = json['year'];
    licenceNumber = json['licenceNumber'];
    photo = json['photo'];
    photo2 = json['photo2'];
    photo3 = json['photo3'];
    photo4 = json['photo4'];
    licenceFront = json['licenceFront'];
    licenceBack = json['licenceBack'];
    vehicleRegistration = json['vehicleRegistration'];
    vehicleInsurance = json['vehicleInsurance'];
    w9Form = json['w9Form'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['driverId'] = this.driverId;
    data['make'] = this.make;
    data['model'] = this.model;
    data['year'] = this.year;
    data['licenceNumber'] = this.licenceNumber;
    data['photo'] = this.photo;
    data['photo2'] = this.photo2;
    data['photo3'] = this.photo3;
    data['photo4'] = this.photo4;
    data['licenceFront'] = this.licenceFront;
    data['licenceBack'] = this.licenceBack;
    data['vehicleRegistration'] = this.vehicleRegistration;
    data['vehicleInsurance'] = this.vehicleInsurance;
    data['w9Form'] = this.w9Form;
    return data;
  }
}
