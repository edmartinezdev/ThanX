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

  //SortByFilter
  String get filterRecentTitle => 'SORT BY';
  String get strUpcoming => 'Upcoming';
  String get strHotEvents  => 'Hot Events (Almost Full)';
  String get strAtoZ => 'A to Z';
  String get strZtoA => 'Z to A';


  //PriceFilter
  String get strPrice => 'Price';
  String get strClear => 'Clear';
  String get strHighToLow => 'High to Low';
  String get strLowToHigh => 'Low to High ';


  // dateFilter
  String get strDate => 'Date';
  String get strSelectDateHeader => "Select date range to filter results";


  //LocationFilter
  String get strLocation => "Location";
  String get strSelectLocation => "city, state or zip code or current location";
  String get strMetersShort => "mi";
  String get strDistance => "Distance";

  //Browse Events
  String get strCancel => "Cancel";
  String get strSearchTerm => "Search term";
  String get strSearch => "Search";
  String get strSearchEvents => "Search Events";
  String get strRecent => "Recent";
  String get strNoResults => "No Results";
  String get strNoSearchResult => "Your Search returned no Matching tournaments. Please modify your Filters or search in a different area";
  String get strNoDataFound => "No Data Found";
  String get strNoDataMessage => "No Events are available currently";

  //Event Details
  String get strScramble => "Scramble";
  String get strFormat => "Format";
  String get strBeneficiary => "Beneficiary";
  String get strCYONaples => "CYO Naples";
  String get strAddress => "Address";
  String get strRegistration => "Registration";
  String get strShotgunStartTime => "Shotgun Start Time";
  String get strIncluded => "Included";
  String get strAvailableForPurchase => "Available for Purchase";
  String get strDetails => "Details";
  String get strTournamentFlyer => "Tournament Flyer";
  String get strPDF => "PDF";
  String get strRegister => "Register";

  // Register events
  String get strGolferRegister => "Golfer Registration";
  String get strSelectBeneficiary => "Select Beneficiary";
  String get strBeneficiaryMessage => "Glide Golf tournaments allow you to select a charity that your purchase benefits.";

  String get strContinueToCart => 'Continue to Cart';
  String get strAddToCart => "Add to Cart";
  String get appName => 'Glide Golf';
  String get buttonCancel => 'Cancel';
  String get buttonContinue => 'Continue';
  String get titleSearchText => "search";
  String get checkOutText => "Checkout";
  String get totalText => "Total";
  String get continueShopping => "Continue Shopping";

  //My Events
  String get strMyEvents => "My Events";
  String get strInfo => 'Info';
  String get strGolfers => 'Golfers';
  String get strPast => 'Past';
  String get strGolfersAvailable  => 'Golfers Available | 1';
  String get strGolferManagementDes => 'All members of your foursome are required to accept their invitations within 24 hours of the tournament.';


  // Manage Golfers
  String get strContacts => 'Contacts';
  String get strNext => 'Next';
  String get strInvitationAccepted => "Invitation Accepted";
  String get strInvitationPending => "Invitation Pending";
  String get strGroupLeader => "Group Leader";
  String get strAddGolferInvitation => "Add Golfer Invitation";
//  String get strNext => 'Next';
//  String get strNext => 'Next';
//  String get strNext => 'Next';



  //Cart
    String get strCart => 'Cart';
    String get strSave => 'Save';
    String get strPaymentDetails => 'Payment Details';
    String get strOrderConfirmation => 'Order Confirmation';
    String get strPurchase => 'Purchase';
    String get strCongratulations => 'Congratulations';
    String get strPurchaseSuccessFul => 'Your purchase was Successful.';
    String get strViewSilentAuctions => 'View Silent Auctions';
    String get strViewRaffleItems => 'View Raffle Items';
    String get strViewMyEvents => 'View My Events';


  // Settings
    String get strSettings => 'Settings';
    String get strPaymentMethods => 'Payment Methods';
    String get strNotifications => 'Notifications';
    String get strPrivacyPolicy => 'Privacy Policy';
    String get strTermsOfUse => 'Terms of Use';
    String get strContactUs => 'Contact Us';
  //  String get strGolfers => 'Golfers';
  //  String get strGolfers => 'Golfers';
  //  String get strGolfers => 'Golfers';
  //  String get strGolfers => 'Golfers';
  //  String get strGolfers => 'Golfers';

  /*  Login Option Page */
  String get msgSomethingWrong => "Something went Wrong";
  String get msgInternetMessage => "Please check your Network Connection";
  String get buttonLoginWithEmail => "Login with Email";
  String get strOr => "OR";
  String get buttonSignup => "Signup";
  String get strEnterEmailOrPhone => "Please enter email or Phone Number";

  /*  Login Page */
  String get screenTitleLogin => "Login";


/*forget password page*/
  String get buttonSubmit => "Submit";
  String get forgetPasswordTitle => "FORGOT PASSWORD";

  /*  Register Page */
  String get screenTitleSignup => "New Account";
  String get buttonSignUp => "Sign Up";
  String get confirmPassword => "Confirm Password";
  String get buttonLogin => "Login";

  /* Reset Password */
  String get newPassword => "New Password";
  String get password => "Password";
  String get reEnterPassword => "Re-Enter Password";
  String get resetPasswordTitle => "RESET PASSWORD";


  String get forgotPassword => "Forgot Password?";

  String get hintEmail => "Email";


  String get strSignupTab => "Sign Up";
  String get strLoginTab => "Login";


  /* Change Password */
  String get screenTitleChangePassword => "Change Password";
  String get txtPlaceHolderOldPassword => "Old Password";
  String get txtPlaceHolderNewPassword => "New Password";
  String get txtPlaceHolderConfirmNewPassword => "Confirm New Password";

/* Create Account*/
  String get createAcconntTitle => "CREATE ACCOUNT";
  String get txtFirstName => "First Name";
  String get txtLastName => "Last Name";
  String get txtGender => "Gender";
  String get txtBirthdate => "Birthdate";
  String get txtPhoneNumber => "Phone Number";
  String get txtAddressLine1 => "Address Line 1";
  String get txtAddressLine2 => "Address Line 2";
  String get txtCity => "City";
  String get txtState => "State";
  String get txtZipCode => "Zip Code";
  String get personalDetails => "Personal Details";

  String get txtEmail => "Email";

  String get buttonNext => "Next";

  String get golferDetails => "Golfer Details";
  String get txtOccupation => "Occupation";
  String get txtHandicap => "Handicap";
  String get txtHandedness => "Handedness";
  String get txtSkillLevel => "Skill Level";
  String get txtFavoriteDriverBrand => "Favorite Driver Brand";
  String get txtFavoriteIronBrand => "Favorite Iron Brand";
  String get txtFavoriteBall => "Favorite Ball";
  String get txtShirtSize => "Shirt Size";
  String get txtback => "I’ll come back to this  ";


  /*Add card*/
  String get addCardScreenTitle => "ADD CARD";
  String get cardDetails => "Card Details";
  String get txtCardNo => "**** **** **** ****";
  String get txtExp => "MM/YY";
  String get txtCvc => "CVV/CVC";
  String get txtZipCodes => "Zip Code";

  String get buttonAddCard => "Add Card";
  String get txtbackto => "I’ll come back to this, Create my Account  ";

  /*Payment Method*/
  String get paymentMethodScreenTitle => "PAYMENT METHOD";
  String get txtAddPaymentMethod => "Add Payment Method";
  String get buttonCreateAccount => "Create Account";

  /*Silent Auction*/
  String get searchTxtSilentAuctions => "Search Silent Auctions";
  /*Silent Auction Organization */
  String get searchTxtSilentAuctionsDetails => "Search CYO Naples";
  String get currentBidTxt => "Current Bid";
  String get searchTxtSilentAuctionsProduct => "Search Auctions Product";

  /*Silent Auction Organization Product */
  String get searchTxtSilentAuctionsOrganizationProduct => "Search CYO Naples";
  String get currentlyNotWinningTxt => "You’re Currently Not Winning";
  String get currentlyWinningTxt => "You’re Currently Winning";

  String get incrementTxt => "Bid Increment";
  String get buttonSubmitBid => "Submit Bid";
  String get buttonSetupAutomaticBidding => "Setup Automatic Bidding";
  String get buttonBuy => "Buy It Now for";
  String get buttonSetAutomaticBid => "Set Automatic Bid";
  String get hintAutomaticBid => "\$500";
  String get automaticBidText => "Setting up an automatic max bid will allow the system to outbid new bids automatically up to your preset max amount.";


  /*My purchases*/
  String get myPurchasesTitle => "MY PURCHASES";
  String get paymentMethodTxt => "Payment Method";
  String get billingAddressTxt => "Billing Address";

  /*Notification*/
  String get notificationsTitle => "NOTIFICATIONS";
  String get acceptButton => "Accept";
  String get declineButton => "Decline";

  /*Settings*/
  String get addContactTitle => "ADD CONTACT";
  String get firstName => "firstname";
  String get lastName => "lastname";
  String get email => "email";
  String get phoneNumber => "Phone Number";
  String get requiredText => "required";
  String get sendInvitationButton => "Send Invitation";
  String get addContactButton => "Add Contact";

  String get notificationTitle => "NOTIFICATIONS";

  /*Profile*/
  String get profileTitle => "PROFILE";
  String get txtSave => "Save";
  String get txtEdit => "Edit";


  /* Push Notication Setting */

  /* general message */
//
//  String get msgInternetMessage => this.translate("msgInternetMessage");
//  String get msgSomethingWrong => this.translate("msgSomethingWrong");
  String get msgCameraPermission => "App needs camera permission to capture photo, go to settings and allow access";
  String get msgPhotoPermission => "App needs photo permission to take photo from your library, go to settings and allow access";
  String get msgFlagUserMessage => "Are you sure want to flag this user?";

  /* validation message */
  String get msgEmptyEmail => "Please enter your email address.";
  String get msgValidEmail => "Please enter valid email address.";
  String get msgEmptyPassword => "Please enter password.";
  String get msgValidPassword => "Password must be between 6 to 12 characters.";
//  String get msgEmptyUsername => "Please enter full name.";
//  String get msgValidUsername => "First name should contain at least 2 characters.";
//  String get msgAgreeTerms => "Please agree terms & conditions.";
//  String get msgEmptyOldPassword => "Please enter old password.";
//  String get msgEmptyNewPassword => "Please enter new password.";
//  String get msgValidNewPassword => "New password must contain one capital letter, one number and minimum of 8 characters.";
//  String get msgEmptyConfirmNewPassword => "Please enter confirm password.";
//  String get msgValidConfirmNewPassword => "Confirm new password must be between 6 to 12 characters.";
//  String get msgNewAndConfirmPassword => "New Password and Confirm New Password must match.";
//  String get msgOldAndNewPasswordSame => "Your New Password must be different from your Old Password.";
  String get msgLogOutMessage => "Are you sure want to logout?";
  String get msgselectLocation => "Please select location.";
  String get msgValidCard => "Please enter valid Card number";
  String get msgvalidMonthYear => "Please enter valid expiry month and year";
  String get msgValidCvc => "CVV/CVC must be 3 numbers";

  String get msgvalidZipCode => "Please enter valid Zipcode";


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

  String get msgPasswordConfirmPasswordMatch => "Password and Confirm Password must be the same.";


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

//media selector
  String get msgProfilePhotoSelection => "Glide golf needs to access your camera or gallery to set your profile picture";
  String get msgCameraPermissionProfile => "Glide golf wants camera permission for upload your profile picture, please go to settings and allow access";
  String get msgPhotoPermissionProfile => "Glide golf wants photo permission for upload your profile picture, please go to settings and allow access";
  String get buttonOk => "OK";
  String get strTakePhoto => "Take Photo";
  String get strChooseFromExisting => "Choose Existing Photo";


  String get msgForceLogout => "Something went wrong. Try login again!";
  String get strMaxBidFor => "Set Max Bid For:";
  String get strAutoMaticBidPriceMustHigher => "Automatic bid price must be higher than latest bid price.";
  String get strBilling => 'Billing';
  String get strSignUpTermsPage => 'By clicking Sign Up, you agree to our Privacy Policy and Terms & Conditions.';

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
