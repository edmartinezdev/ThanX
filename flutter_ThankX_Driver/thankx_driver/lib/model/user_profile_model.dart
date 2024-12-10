class UserProfileModel {
  String sId;
  String firstname;
  String lastname;
  String userType;
  String contactNumber;
  String email;
//  Location location;
  String profilePicture;

  UserProfileModel(
      {this.sId = '',
        this.firstname = '',
        this.lastname = '',
        this.userType = '',
        this.contactNumber = '',
        this.email = '',
//        this.location,
        this.profilePicture = ''});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    firstname = json['firstname'];
    lastname = json['lastname'];
    userType = json['userType'];
    contactNumber = json['contactNumber'];
    email = json['email'] ?? '';
//    location = json['location'] != null
//        ? new Location.fromJson(json['location'])
//        : null;
    profilePicture = json['profilePicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['userType'] = this.userType;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
//    if (this.location != null) {
//      data['location'] = this.location.toJson();
//    }
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}

class Location {
  String type;
  String index;
  List<double> coordinates;

  Location({this.type, this.index, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    index = json['index'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['index'] = this.index;
    data['coordinates'] = this.coordinates;
    return data;
  }
}