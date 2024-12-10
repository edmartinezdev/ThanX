import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thankxdriver/model/user_profile_model.dart';
import 'package:thankxdriver/utils/ui_utils.dart';

import '../api_provider/api_constant.dart';
import '../utils/logger.dart';

class User {
  String sId;
  String firstname;
  String lastname;
  String email;
  String userType;
  String profilePicture;
  String countryCode;
  String contactNumber;
  String socketId;
  String resetToken;
  Location location;
  String stripeCustomerId;
  bool vechicleInfoDone;
  bool isw9FormDone;
  bool isActive;
  bool isDriverActive;
  String accessToken;
  double totalAvgRating;
  String w9Form;

  static User currentUser = User();

  static Future<bool> isUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUserDetails = prefs.getString(PreferenceKey.storeUser);
    return (storeUserDetails != null);
  }

  static Future<void> removeUser() async {
    SharedPreferences prefs = await UIUtills().sharedPref;
    prefs.remove(PreferenceKey.storeUser);
    print("Logout");
  }

  User(
      {this.sId = '',
        this.firstname = '',
        this.lastname = '',
        this.email = '',
        this.userType = '',
        this.profilePicture = '',
        this.contactNumber = '',
        this.countryCode = '',
        this.socketId = '',
        this.resetToken = '',
        this.location,
        this.stripeCustomerId = '',
        this.vechicleInfoDone = false,
        this.isw9FormDone = false,
        this.isActive = false,
        this.isDriverActive = false,
        this.accessToken = '',
        this.w9Form = ''});

  Future<void> updateUserDetails(Map<String, dynamic> json,
      {bool isNeedToSaveDetails = true}) async {
    sId = json['_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    userType = json['userType'];
    profilePicture = json['profilePicture'];
    countryCode = json['countryCode'];
    contactNumber = json['contactNumber'];
    socketId = json['socketId'];
    resetToken = json['resetToken'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    stripeCustomerId = json['stripeCustomerId'];
    vechicleInfoDone = json['vechicleInfoDone'];
    isw9FormDone = json['isw9FormDone'];
    isActive = json['isActive'];
    isDriverActive = json['isDriverActive'];
    accessToken = json['accessToken'] ?? this.accessToken;
    w9Form = json['w9Form'];
    totalAvgRating = double.parse((json['totalAvgRating'] ?? 0).toString());

    if (isNeedToSaveDetails && this == User.currentUser) {
      this.saveUser();
    }
  }
  UserProfileModel model;
  UserProfileModel convertToUserProfile() {
    return UserProfileModel(
        firstname: this.firstname,
        lastname: this.lastname,
        contactNumber: this.contactNumber,
        email: this.email,
        profilePicture: this.profilePicture,
        sId: this.sId,
//        location: this.model.location,
        userType: this.userType);
  }

  Future<void> saveUser() async {
    final userMap = this.toJson();
    String jsonString = json.encode(userMap);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PreferenceKey.storeUser, jsonString);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['userType'] = this.userType;
    data['profilePicture'] = this.profilePicture;
    data['countryCode'] = this.countryCode;
    data['contactNumber'] = this.contactNumber;
    data['socketId'] = this.socketId;
    data['resetToken'] = this.resetToken;
//    if (this.location != null) {
//      data['location'] = this.location.toJson();
//    }
    data['stripeCustomerId'] = this.stripeCustomerId;
    data['vechicleInfoDone'] = this.vechicleInfoDone;
    data['isw9FormDone'] = this.isw9FormDone;
    data['isActive'] = this.isActive;
    data['totalAvgRating'] = this.totalAvgRating;
    data['isDriverActive'] = this.isDriverActive;
    data['accessToken'] = this.accessToken;
    data['w9Form'] = this.w9Form;
    return data;
  }

  Future<void> loadPastUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = prefs.getString(PreferenceKey.storeUser);

    if (storeUser != null) {
      // Load store user
      Map<String, dynamic> jsonValue = json.decode(storeUser);
      Logger().v('User Details $storeUser');
      await this.updateUserDetails(jsonValue, isNeedToSaveDetails: false);
    }
  }

  Future<void> resetUserDetails() async {
    // Reset UserDetails
    this.updateUserDetails(Map<String, dynamic>());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKey.storeUser);

    // ResetFilter for login user
    await prefs.remove(PreferenceKey.currentFilter);
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