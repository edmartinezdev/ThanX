
import 'package:tuple/tuple.dart';

import '../localization/localization.dart';
import '../utils/logger.dart';

enum ValidationType {
  firstName,
  lastName,
  email,
  confirmEmail,
  passWord,
  loginpassword,
  confirmPassWord,
  currentPassword,
  newPassword,
  confirmNewPassword,
  phoneNumber,
  userAddress,
  projectName,
  city,
  state,
  zipCode,
  longitude,
  latitude,
  status,
  gender,
  occupation,
  handicap,
  handedness,
  skillLevel,
  driverBrand,
  ironBrand,
  ball,
  shirtSize,
  accountNumber,
  accountNameHolder,
  bankName,
  routingNumber,
  birthDate,
  ssnNumber,
  year,
  make,
  model,
  licence,
  none
}

class Validation {
  factory Validation() {
    return _singleton;
  }

  static final Validation _singleton = Validation._internal();

  Validation._internal() {
    Logger().v("Instance created Validation");
  }

  /* length check */

  static const int _zero = 0;
  static const int _two = 2;
  static const int _five = 5;
  static const int _six = 6;
  static const int _eight = 8;
  static const int _twelve = 12;
  static const int _sixteen = 16;

  static const int minwidth = 0;
  static const int minheight = 0;
  static const int minLength = 0;
  static const int maxwidth = 640;
  static const int maxheight = 640;
  static const int maxlength = 640;

  static const int minWall = 1;
  static const int maxWall = 50;

  Tuple2<bool, String> validateFirstName(String value) {
    String pattern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyFirstName;
    }
//    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidFirstName;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

//  Tuple2<bool, String> validateState(String value) {
//
//    String _errorMessage = StringConstant.selectStateType;
//
//    if (value.length == Validation._zero) {
//      _errorMessage = StringConstant.msgEmptyFirstName;
//    }
//    return Tuple2(_errorMessage.length == 0, _errorMessage);
//  }

  Tuple2<bool, String> validateLastName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyLastName;
    }
//    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidLastName;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateEmail(String value) {
    String pattern1 = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))' ;
    String pattern2 = pattern1;
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyEmail;
    } else if (!regExp1.hasMatch(value) || !regExp2.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidEmail;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateConfirmEmail(String value) {
    String pattern1 = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))' ;
    String pattern2 = pattern1;
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyConfirmEmail;
    } else if (!regExp1.hasMatch(value) || !regExp2.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidConfirmEmail;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validatePassword(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyPassword;
    } else if (value.length < Validation._six || value.length > Validation._sixteen) {
      _errorMessage = AppTranslations.globalTranslations.msgValidPassword;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateloginPassword(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyloginPassword;
    } else if (value.length < Validation._six) {
      _errorMessage = AppTranslations.globalTranslations.msgValidloginPassword;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateConfirmPassword(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage =
          AppTranslations.globalTranslations.msgEmptyConfirmPassword;
    } else if (value.length < Validation._six || value.length > Validation._sixteen) {
      _errorMessage = AppTranslations.globalTranslations.msgValidConfirmPassword;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateUser(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
//      _errorMessage = StringConstant.msgEmptyUser;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateUserAddress(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgAddUserAddress;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateProjectName(String value) {
    String pattern = r'(^[a-z0-9A-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
//      _errorMessage = StringConstant.msgEmptyProjectName;
    } else if (value.length < Validation._two || !regExp.hasMatch(value)) {
//      _errorMessage = StringConstant.msgValidProjectName;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateCity(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyCityName;
    } else if (value.length < Validation._two || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyCityName;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateState(String value) {
    String pattern = '';
    // ignore: unused_local_variable
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

//    if (value == AppTranslations.globalTranslations.state) {

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyStateName;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateZipcode(String value) {
    String pattern = r'^[0-9]';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyZipCode;
    } else if (value.length < Validation._five || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidZipCode;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateCurrentPassword(String value) {

    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.currentPasswordValidation;
    } else if (value.length < Validation._six) {
      _errorMessage = AppTranslations.globalTranslations.currentPasswordLengthValidation;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);

  }

  Tuple2<bool, String> validateNewPassword(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.newPasswordValidation;

    } else if (value.length < Validation._six || value.length > Validation._sixteen) {
      _errorMessage = AppTranslations.globalTranslations.msgValidNewPassword;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);

  }

  Tuple2<bool, String> validateConfirmNewPassword(String value) {
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.newConfirmPasswordValidation;

    } else if (value.length < Validation._six) {
      _errorMessage = AppTranslations.globalTranslations.newConfirmPasswordLengthValidation;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validatePhoneNumber(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyMobileNumber;
    } else if (value.length < 10) {
      _errorMessage = AppTranslations.globalTranslations.msgValidMobileNumber;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateOccupation(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyOccupation;
    } else if (value.length < Validation._two || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidOccupation;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
//    if (value.length == Validation._zero) {
//           _errorMessage = AppTranslations.globalTranslations.msgEmptyOccupation;
//    }
////    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
////           _errorMessage = AppTranslations.globalTranslations.msgValidOccupation;
////    }
//    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateHandicap(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyHandicap;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidHandicap;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateHandedness(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyHandedness;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidHandedness;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateSkillLevel(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptySkillLevel;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidSkillLevel;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateDriverBrand(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyDriverBrand;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidDriverBrand;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateIronBrand(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyIronBrand;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidIronBrand;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateBall(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyBall;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidBall;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateShirtSize(String value) {
    String pattern = '';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptySkillLevel;
    }
    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidSkillLevel;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateGender(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyGender;
    } else if (value.length < Validation._two || !regExp.hasMatch(value)) {
      _errorMessage = AppTranslations.globalTranslations.msgValidGender;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateAccountNameHolder(String value) {
    String pattern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyAccountNameHolder;
    }
//    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidFirstName;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }
  Tuple2<bool, String> validateBankName(String value) {
    String pattern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(pattern);
    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyBankName;
    }
//    else if (value.length < Validation._zero || !regExp.hasMatch(value)) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidFirstName;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateAccountNumber(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyAccountNumber;
    } else if (value.length < 12) {
      _errorMessage = AppTranslations.globalTranslations.msgValidAccountNumber;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateRoutingNumber(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyRoutingNumber;
    } else if (value.length < 9 ) {
      _errorMessage = AppTranslations.globalTranslations.msgValidRoutingNumber;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }
  Tuple2<bool, String> validateSSNNumber(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptySSNNumber;
    } else if (value.length < 4 ) {
      _errorMessage = AppTranslations.globalTranslations.msgValidSSNNumber;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }



  Tuple2<bool, String> validateYear(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyYear;
    }
//    else if (value.length < 4) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidTYear;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }
  Tuple2<bool, String> validateMake(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyMake;
    }
//    else if (value.length < 12) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidMake;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateModel(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyModel;
    }
//    else if (value.length < 12) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidAccountNumber;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }

  Tuple2<bool, String> validateLicence(String value) {
    String _errorMessage = '';
    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyLicence;
    }
//    else if (value.length < 12) {
//      _errorMessage = AppTranslations.globalTranslations.msgValidAccountNumber;
//    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }
  Tuple2<bool, String> validateBirthDate(String value) {

    String _errorMessage = '';

    if (value.length == Validation._zero) {
      _errorMessage = AppTranslations.globalTranslations.msgEmptyBirthDate;
    }
    return Tuple2(_errorMessage.length == 0, _errorMessage);
  }



  Tuple3<bool, String, ValidationType> checkValidationForTextFieldWithType(
      {List<Tuple2<ValidationType, String>> list}) {
    Tuple3<bool, String, ValidationType> isValid =
    Tuple3(true, '', ValidationType.none);

    for (Tuple2<ValidationType, String> textOption in list) {
      if (textOption.item1 == ValidationType.firstName) {
        final res = this.validateFirstName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.firstName);
      }
      else if (textOption.item1 == ValidationType.lastName) {
        final res = this.validateLastName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.lastName);
      }
      else if (textOption.item1 == ValidationType.email) {
        final res = this.validateEmail(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.email);
      }
      else if (textOption.item1 == ValidationType.confirmEmail) {
        final res = this.validateConfirmEmail(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.confirmEmail);
      }
      else if (textOption.item1 == ValidationType.passWord) {
        final res = this.validatePassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.passWord);
      }
      else if (textOption.item1 == ValidationType.loginpassword) {
        final res = this.validateloginPassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.loginpassword);
      }
      else if (textOption.item1 == ValidationType.confirmPassWord) {
        final res = this.validateConfirmPassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.confirmPassWord);
      }
      else if (textOption.item1 == ValidationType.currentPassword) {
        final res = this.validateCurrentPassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.currentPassword);
      }
      else if (textOption.item1 == ValidationType.newPassword) {
        final res = this.validateNewPassword(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.newPassword);
      }
      else if (textOption.item1 == ValidationType.projectName) {
        final res = this.validateProjectName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.projectName);
      }
      else if (textOption.item1 == ValidationType.confirmNewPassword) {
        final res = this.validateConfirmNewPassword(textOption.item2);
        isValid =
            Tuple3(res.item1, res.item2, ValidationType.confirmNewPassword);
      }
      else if (textOption.item1 == ValidationType.phoneNumber) {
        final res = this.validatePhoneNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.phoneNumber);
      }
      else if (textOption.item1 == ValidationType.userAddress) {
        final res = this.validateUserAddress(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.userAddress);
      }
      else if (textOption.item1 == ValidationType.city) {
        final res = this.validateCity(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.city);
      }
      else if (textOption.item1 == ValidationType.state) {
        final res = this.validateState(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.state);
      }
      else if (textOption.item1 == ValidationType.zipCode) {
        final res = this.validateZipcode(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.zipCode);
      }
//      else if (textOption.item1 == ValidationType.zipCode) {
//        final res = this.validateZipcode(textOption.item2);
//        isValid = Tuple3(res.item1, res.item2, ValidationType.zipCode);
//      }
      else if (textOption.item1 == ValidationType.occupation) {
        final res = this.validateOccupation(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.occupation);
      }
      else if (textOption.item1 == ValidationType.handicap) {
        final res = this.validateHandicap(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.handicap);
      }
      else if (textOption.item1 == ValidationType.handedness) {
        final res = this.validateHandedness(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.handedness);
      }
      else if (textOption.item1 == ValidationType.skillLevel) {
        final res = this.validateSkillLevel(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.skillLevel);
      }
      else if (textOption.item1 == ValidationType.driverBrand) {
        final res = this.validateDriverBrand(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.driverBrand);
      }
      else if (textOption.item1 == ValidationType.ironBrand) {
        final res = this.validateIronBrand(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.ironBrand);
      }
      else if (textOption.item1 == ValidationType.ball) {
        final res = this.validateBall(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.ball);
      }
      else if (textOption.item1 == ValidationType.birthDate) {
        final res = this.validateBirthDate(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.shirtSize);
      }
      else if (textOption.item1 == ValidationType.shirtSize) {
        final res = this.validateShirtSize(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.shirtSize);
      }
      else if (textOption.item1 == ValidationType.gender) {
        final res = this.validateGender(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.gender);
      }
      if (textOption.item1 == ValidationType.accountNumber) {
        final res = this.validateAccountNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.accountNumber);
      }
      if (textOption.item1 == ValidationType.accountNameHolder) {
        final res = this.validateAccountNameHolder(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.accountNameHolder);
      }
      if (textOption.item1 == ValidationType.routingNumber) {
        final res = this.validateRoutingNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.routingNumber);
      }
      if (textOption.item1 == ValidationType.ssnNumber) {
        final res = this.validateSSNNumber(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.ssnNumber);
      }
      if (textOption.item1 == ValidationType.bankName) {
        final res = this.validateBankName(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.bankName);
      }
      if (textOption.item1 == ValidationType.year) {
        final res = this.validateYear(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.year);
      }
      if (textOption.item1 == ValidationType.make) {
        final res = this.validateMake(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.make);
      }
      if (textOption.item1 == ValidationType.model) {
        final res = this.validateModel(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.model);
      }
      if (textOption.item1 == ValidationType.licence) {
        final res = this.validateLicence(textOption.item2);
        isValid = Tuple3(res.item1, res.item2, ValidationType.licence);
      }
      if (!isValid.item1) {
        break;
      }
    }
    return isValid;
  }
}
