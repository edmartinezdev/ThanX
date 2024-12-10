import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTranslations {
  Locale locale;
  static AppTranslations globalTranslations;

  AppTranslations(Locale local) {
    this.locale = local;
    AppTranslations.globalTranslations = this;
  }

  // Helper method to keep the code in the widgets concise Localizations are accessed using an InheritedWidget "of" syntax
  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppTranslations> delegate =
  _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder

    String jsonString =
    await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }

  /*  Application Strings  */
//  String get strBedrooms => this.translate("strBedrooms");

  /*  Intro silder Text */
  String get alreadyLoginText => "Already Have an Account? Login";
  String get buttonGetStarted => "Get Started";

  String get page1Text1 => "Be a part of the";
  String get page1Text2 => "Solution.";
  String get page1Text3 => "Be part of the solution with a one of a kind peer to peer service. It is simple to claim and fulfill orders!";
  String get page2Text1 => "Claim an";
  String get page2Text2 =>  "Order.";
  String get page2Text3 => "To claim an order, simply explore the available orders in your area and claim the one you want. It is that simple!";
  String get page3Text1 => "Head to the";
  String get page3Text2 => "Pick Up.";
  String get page3Text3 => "Once you’ve picked up the item, be sure to confirm the pick up to update all the sender and receiver.";
  String get page4Text1 => "The item is";
  String get page4Text2 => "Delivered.";
  String get page4Text3 => "On delivery of the item, provide the receiver your device in order to entire in their 4-digit confirmation code. Once entered your order will be completed!";

  /*  Login Option Page */
  String get msgSomethingWrong => "Something went Wrong";
  String get msgInternetMessage => "Please check your Network Connection";
//  String get buttonLoginWithEmail => "Login with Email";
  String get strOr => "OR";
  String get appName => "Thankx";
  String get strEnterEmailOrPhone => "Please enter email or Phone Number";
  String get strTermsAndConditions => "By clicking Create Account, you agree to our\nPrivacy Policy and Terms & Conditions.";
  String get deleteText => "Delete";


  String get strClear => "Clear";
  /*  Login Page */
  String get emailText => "Email";
  String get password => "Password";
  String get buttonLogin => "Login";
  String get termsAndConditionText => "By clicking Login, you agree to our Privacy Policy \nand Terms & Conditions.";
  String get getStartText => "Don’t Have an Account? Get Started Now";
  String get forgotPassword => "Forgot Password?";
  String get newPasswordValidation => "Please enter new password.";
  String get msgValidNewPassword => "New password must be between 6 to 16 characters.";

  String get currentPasswordValidation => "Please enter old password.";
  String get currentPasswordLengthValidation => "Old password must be between 6 to 16 characters.";
  String get newConfirmPasswordValidation => "Please enter confirm password.";
  String get newConfirmPasswordLengthValidation => "New Confirm password must be between 6 to 16 characters.";

  String get msgPhotoWarningMessage => "The picture you are uploading has to be clear and of complete face.";

  String get btnOK => "Ok";
/*forget password page*/
  String get buttonSubmit => "Submit";
  String get screenTitleForgotPassword => "Forgot Password";

  /*  personal info  Page */
  String get screenTitlePersonalInfo => "Personal Info";
  String get firstNameText => "First Name";
  String get lastNameText =>  "Last Name";
  String get phoneNumberText => "Phone Number";
  String get reEnterPassword => "Re-enter Password";
  String get confirmEmailText => "Confirm Email";
  String get buttonNext => "Next";

  String get addressText => "Address Line";
  String get ssnNumberText => "Last 4 digits of SSN Number";
  String get dateOfBirthText => "Date Of Birth";

  String get cityText => "City";
  String get stateText => "State";
  String get zipCodeText => "Zip Code";

  String get screenTitleW9Form => "W9 Form";

  String get txtPlaceHolderConfirmNewPassword => "Confirm New Password";
  String get paymentHistory => "Payment History";
  /*vehicle page*/
  String get screenTitleVehicle => "Vehicle";
  String get yearText => "Year";
  String get modelText => "Model";
  String get makeText => "Make";
  String get licensePlateText => "License Plate #";
  String get licenceImageText => "Licence Image";
  String get frontImageText => "Front";
  String get backImageText => "Back";
  String get side1ImageText => "Side 1";
  String get side2ImageText => "Side 2";
  String get vehicleImageText => "Vehicle Image";
  String get vehicleRegistrationText => "Vehicle Registration";
  String get selectfileText => "Select file";
  String get vehicleInsuranceText => "Vehicle Insurance";
  String get downloadText => "Download";
  String get newAndConfirmPassword => "New password and confirm password must be same.";

  /*submit dialog text*/
  String get detailsSubmittedText => "Details Submitted";
  String get submitDialogText => "You will receive an email within 48 hours to confirm your account.";
  String get btnDone =>"Done";
  String get saveAndComeBackLaterText =>"Save & Come Back Later";

  String get msgLoginFromOtherDevice => 'Session has expired! Please login again.';
  /*Tabs*/
  String get personalTab =>"Personal";
  String get driverTab =>"Driver";

  /*Me Tabs*/

  String get Profile =>"Profile";
  String get Wallet =>"Wallet";
  String get TaxInformation =>"Tax Information";
  String get Reviews =>"Reviews";
  String get ChangePassword =>"Change Password";
  String get Notifications =>"Notifications";
  String get AboutUs =>"About Us";
  String get PrivacyPolicy =>"Privacy Policy";
  String get TermsofUse =>"Terms of Use";
  String get ContactUs =>"Contact Us";
  String get LogOut =>"Log Out";
  String get meTitle =>"Me";
  String get depositAccount =>"Deposit Account";

  /*claimed order details Page*/
  String get Route =>"Route";
  String get Distance =>"Distance";
  String get ItemInformation =>"Item Information";
  String get ItemTitle =>"Item Title";
  String get ItemType =>"Item Type";
  String get Weight =>"Weight";
  String get Fragile =>"Fragile";
  String get Yes =>"Yes";
  String get No =>"No";
  String get ItemSize =>"Item Size";
  String get Quantity =>"Quantity";
  String get Notes =>"Notes";
  String get DeliveryMethod =>"Delivery Method";
  String get PaymentMethod =>"Payment Method";
  String get Small =>"Small";
  String get Medium =>"Medium";
  String get Large =>"Large";
  String get InRoutetoPickUp =>"In-Route to Pick Up";
  String get InRoutetoDropOff =>"In-Route to Drop Off";
  String get Delivered =>"Delivered";
  String get arrival =>"arrival";
  String get Arrived =>"Arrived";
  String get InputDeliveryCode =>"Input Delivery Code";
  String get dropOffDetails =>"Drop-Off Details";
  String get ConfirmDelivery =>"Confirm Delivery";
  String get send =>"Send";
  String get ConfirmPickUp =>"Confirm Pick Up";
  String get ConfirmDropOff =>"Confirm Drop Off";
  String get current =>"current";
  String get paymentInfo =>"Payment Info";
  String get youWillReceive =>"You will receive";
  String get youReceived =>"You received";
  String get totalPayment  =>"Total Payment";
  String get Visa =>"Visa";



  String get OrderClaimed =>"Order Claimed";
  String get ConfirmationCode =>"Confirmation Code";
  String get AwaitingRecieverConfirmation =>"Awaiting Reciever Confirmation";
  String get Arrivalby => "Arrival by ";


  String get Notificationstitle =>"Notifications";
//  String get deleteText =>"Delete";
  String get OrdersTitle => "Orders";



  /*Profile Picture page*/
  String get buttonCreateAccount => "Create Account";
  String get screenTitleProfilePicture => "Profile Picture";

  String get aboutUsTitle => "About Us";

  String get termsTitle => "Terms Of Use";

  String get privacyAndpolicyTitle => "Privacy Policy";

  String get walletTitle => "Wallet";
  String get emptySavedAddressScreenText => "Add Addresses for Quicker Order Creation";
  String get reviewTitle => "Reviews";
  String get addressTypeText => "Address Type";
  String get buttonSaveAddress => 'Save Address';
//
  String get contactTitle => "Contacts";

  String get confirmOrder =>  "Confirm Order";
  String get orderStatus =>  "Order Status";
  String get newOrder =>  "New Order";
  String get notificationSettingTitle =>  "Notifications";
  String get locationPermissionAlert =>  "Application needs Location permission to use this feature. You are redirect to setting.";
  String get newReviewReceived =>  "New Review Received";


  String get confirmOrderMessage =>  "You will receive notification when sender or receiver confirm your order.";
  String get orderStatuMessage =>  "You will receive notification when order status changed.";
  String get newReviewReceivedMessage =>  "You will receive notification when any user gives new review on your order.";
  String get newOrderMessage =>  "You will receive notification when any new order comes near by.";

  String get paymentMethodTitle => "Payment Method";
  String get addPaymentMethodText => "Add Payment Method";
  String get profileTitle => "Profile";
  String get addBankDetailsText => "Add Bank";
  String get changeDepositAccountText => "Change Deposit Account";
  String get addDepositAccountText => "Add Deposit Account";

  String get personalTitle => "Personal";
  String get driverTitle => "Driver";
  String get taxInformationTitle => "Tax Information";

  String get changePasswordTitle => "Change Password";

  String get strSignupTab => "Sign Up";
  String get strLoginTab => "Login";

  //Add Order
  String get strCancel => "Cancel";
  String get strNewOrder => "New Order";
  String get strPickUp => "Pick Up";
  String get strDropOff => "Drop Off";
  String get strItemInformation => "Item Information";
  String get strOrderSummary => "Order Summary";

  /*Profile*/
  String get txtSave => "SAVE";
  String get txtEdit => "EDIT";

  String get txtAddress => "Address";

  String get buttonDeposit => "Deposit";

  String get txtCardNo => "**** **** **** ****";
  String get txtExp => "MM/YY";
  String get txtCvc => "CVC";
  String get txtZipCodes => "Zip Code";
  String get buttonAddPaymentMethod => "Add Payment Method";

  //claimOrder
  String get claimOrder => "Claim Order";
  String get claimSuccessMsg => "Your Have Successfully Claimed this Order";
  String get headToOrder => "Head to Order";
  String get getDirections => "Get Directions";

  /*media selector*/
  String get msgProfilePhotoSelection => "ThankX needs to access your Camera/Gallery to select your profile picture";
  String get msgVehiclePhotoSelection => "ThankX needs to access your Camera/Gallery to select your vehicle picture";

  String get msgCameraPermissionProfile => "Thankx wants camera permission for upload your profile picture, please go to settings and allow access";
  String get msgPhotoPermissionProfile => "Thankx wants photo permission for upload your profile picture, please go to settings and allow access";
  String get buttonOk => "OK";
  String get strCamera => "Camera";
  String get strGallary => "Gallery";

  String get  confirmNewPasswordText => "Confirm New Password";
  String get  newPasswordText => "New Password";
  String get  oldPasswordText => "Old Password";

  String get aboutUs => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  /*general text*/

  String get msgCameraPermission => "App needs camera permission to capture photo, go to settings and allow access";
  String get msgPhotoPermission => "App needs photo permission to take photo from your library, go to settings and allow access";
  String get msgFlagUserMessage => "Are you sure want to flag this user?";
  String get buttonCancel => "Cancel";
  String get msgUnableToSendMail => "You can’t send mail.\nPlease configure mail account and Try again.";



  /* validation message */
  String get msgEmptyEmail => "Please enter your email address.";
  String get msgValidEmail => "Please enter valid email address.";
  String get msgEmptyConfirmEmail => "Please enter your confirm email address.";
  String get msgValidConfirmEmail => "Please enter valid confirm email address.";
  String get msgEmptyPassword => "Please enter password.";
  String get msgValidPassword => "Password must be between 6 to 16 characters.";
//  String get msgEmptyUsername => "Please enter full name.";
//  String get msgValidUsername => "First name should contain at least 2 characters.";
//  String get msgAgreeTerms => "Please agree terms & conditions.";
//  String get msgEmptyOldPassword => "Please enter old password.";
  String get msgEmptyNewPassword => "Please enter new password.";
  String get msgEmptyConfirmNewPassword => "Please enter confirm password.";
//  String get msgValidConfirmNewPassword => "Confirm new password must be between 6 to 12 characters.";
//  String get msgNewAndConfirmPassword => "New Password and Confirm New Password must match.";
//  String get msgOldAndNewPasswordSame => "Your New Password must be different from your Old Password.";
  String get msgLogOutMessage => "Are you sure want to logout?";
  String get msgselectLocation => "Please select location.";
  String get msgValidCard => "Please enter valid Card number";
  String get msgvalidMonthYear => "Please enter valid Expirey Month and Year";
  String get msgValidCvc => "CVV must be 3 numbers";
  String get msgvalidZipCode => "Zipcode must be 6 numbers";

  // Flag User and Address
  String get flagTitle => "What would you like to flag?";
  String get user => "User";
  String get address => "Address";
  String get both => "Both";




  String get msgEmptyFirstName => "Please enter first name.";
  String get msgValidFirstName => "Please enter valid first name.";

  String get msgEmptyLastName => "Please enter last name.";
  String get msgValidLastName => "Please enter valid last name.";

  String get msgEmptyloginPassword => "Please enter password.";
  String get msgValidloginPassword => "Please enter valid password.";

  String get msgEmptyConfirmPassword => "Please enter confirm password.";
  String get msgValidConfirmPassword => "Password and confirm password must be same.";

  String get msgAddUserAddress => "Please enter address.";


  String get msgEmptyCityName => "Please enter city.";
  String get msgEmptyStateName => "Please enter state.";

  String get msgEmptyZipCode => "Please enter zipcode.";
  String get msgValidZipCode => "Please enter valid zipcode.";

  String get msgEmptyGender => "Please enter gender.";
  String get msgValidGender => "Please enter valid gender.";

  String get msgEmptyMobileNumber => "Please enter phone number.";
  String get msgValidMobileNumber => "Please enter valid phone number.";

  String get msgPasswordConfirmPasswordMatch => "Password and confirm password must be same.";
  String get msgPasswordConfirmEmailMatch => "Email and confirm email must be same.";

  String get msgEmptyOccupation => "Please enter occupation.";
  String get msgValidOccupation => "Please enter valid occupation.";

  String get msgEmptyHandicap => "Please enter handicap.";
  String get msgValidHandicap => "Please enter valid handicap.";

  String get msgEmptyHandedness => "Please enter handedness.";
  String get msgValidHandedness => "Please enter valid handedness.";

  String get msgEmptySkillLevel => "Please enter skillLevel.";
  String get msgValidSkillLevel => "Please enter valid skillLevel.";

  String get msgEmptyDriverBrand => "Please enter driverBrand.";
  String get msgValidDriverBrand => "Please enter valid driverBrand.";

  String get msgEmptyIronBrand => "Please enter ironBrand.";
  String get msgValidIronBrand => "Please enter valid ironBrand.";

  String get msgEmptyBall => "Please enter ball.";
  String get msgValidBall => "Please enter valid ball.";

  String get msgEmptyShirtSize => "Please enter shirt size.";
  String get msgValidShirtSize => "Please enter valid shirt size.";

  String get msgEmptyAccountNumber => "Please enter account number.";
  String get msgValidAccountNumber => "Please enter valid account number.";

  String get msgEmptyAccountNameHolder => "Please enter account name holder.";
  String get msgValidAccountNameHolder => "Please enter account name holder.";

  String get msgEmptyRoutingNumber => "Please enter routing number.";
  String get msgValidRoutingNumber => "Please enter valid routing number.";

  String get msgEmptySSNNumber => "Please enter ssn number.";
  String get msgValidSSNNumber => "Please enter last 4 digit of ssn number.";

  String get msgEmptyYear => "Please enter year.";
  String get msgEmptyMake => "Please enter make.";
  String get msgEmptyModel => "Please enter model.";
  String get msgEmptyLicence => "Please enter licence number.";

  String get msgEmptyBankName => "Please enter bank name.";
  String get msgValidBankName => "Please enter valid bank name.";
//
  String get accHolderName => "Account Holder Name";

  String get bankName => "Bank Name";
  String get accountNumber => "Account Number";
  String get routingNumber => "Routing Number";

  String get awaitingConfirmationStatus => "Awaiting confirmation";
  String get awaitingClaimStatus => "Awaiting claim";
  String get claimedStatus => "Claimed";
  String get pickedupStatus => "Pickedup";
  String get deliveredStatus => "Delivered";
  String get canceledStatus => "Canceled";
  String get arrivedStatus => "Arrived";
  String get rejectedStatus => "Rejected";
  String get msgRemovePhoto => "Are you sure want to remove this photo?";
  String get msgEmptyBirthDate => "Please select birthdate.";


}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppTranslations localizations = new AppTranslations(locale);
//    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
