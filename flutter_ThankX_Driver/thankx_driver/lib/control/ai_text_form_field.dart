import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType{
  email,
  password,
  phoneNumber,
  usaPhoneNumber,
  name,
  userName,
  numericOnly,
  numericWithSpace,
  numericNoZero,
  floatValue,
  charactersOnly,
  charactersWithSpace,
  charactersWithNumbers,
  charactersNumbersWithSpace,
  charactersWithSpecialCharacter,
  charactersSpecialCharacterWithSpace,
  price,
  card,
  none,
  noneNoSpace,
  nameWithSpace,
  cardExpiry,
}

class AITextFormField extends FormField<String> {

  TextFieldType textType;
  TextInputType keyboardType;
  TextInputAction action;
  TextEditingController controller;

  FocusNode focusNode;
  VoidCallback onEditingComplete;
  ValueChanged<String> onChanged;
  ValueChanged<String> onSubmitted;
  InputDecoration decoration;
  int minLength;
  int maxLength;
  int maxLenghtwithidicator;
  bool autofocus;
  bool autocorrect;
  bool obscureText;
  TextStyle style;
  final TextAlign textAlign;
  TextCapitalization textCapitalization;
  final int maxLines;
  final Color cursorColor;
  bool enabled;
  GestureTapCallback gestureTapCallback;

  AITextFormField({
    Key key,
    @required this.textType,
    this.keyboardType,
    this.action = TextInputAction.next,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmitted,
    this.decoration,
    this.minLength = 0,
    this.maxLength,
    this.maxLenghtwithidicator,
    this.autofocus = false,
    this.autocorrect = false,
    this.obscureText = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.cursorColor,
    this.enabled=true,
    this.gestureTapCallback

  }) : super(
      key: key,
      builder: (FormFieldState<String> field) {});

  @override
  _AITextFormFieldState createState() => _AITextFormFieldState();
}

class _AITextFormFieldState extends FormFieldState<String> {

  @override
  AITextFormField get widget => super.widget;
  int max, min;

  @override
  void initState() {
    super.initState();
    max = (this.widget.maxLength != null) ? this.widget.maxLength : _getMaxLength(this.widget.textType);
    min = (this.widget.minLength != null) ? this.widget.minLength : _getMinLength(this.widget.textType);

  }

  @override
  Widget build(BuildContext context) {

    List<TextInputFormatter> arrInputFormatter = _getListOfForamtter(this.widget.textType, max);
    return TextField(

      onTap: this.widget.gestureTapCallback,
      enabled: this.widget.enabled,
      keyboardType: this.widget.keyboardType ?? _getKeyBoardType(this.widget.textType),
      textInputAction: this.widget.action,
      controller: this.widget.controller,
      focusNode: this.widget.focusNode,
      onEditingComplete: this.widget.onEditingComplete,
      onChanged: this.widget.onChanged,
      decoration: this.widget.decoration,
      autofocus: this.widget.autofocus,
      autocorrect: this.widget.autocorrect,
      textCapitalization: this.widget.textCapitalization,
      obscureText: (this.widget.textType == TextFieldType.password) ? true : this.widget.obscureText,
      style: this.widget.style,
      textAlign: this.widget.textAlign,
      inputFormatters: arrInputFormatter,
      maxLines: this.widget.maxLines,
      maxLength: this.widget.maxLenghtwithidicator,
      cursorColor: this.widget.cursorColor,
      onSubmitted: this.widget.onSubmitted,
    );
  }
}

class CharacterSetType {
  static final String emailRegx1 = "^([a-zA-Z0-9.’'@]+)*\$";

  //static final String passwordRegx = "^[a-z0-9A-Z]+([a-z0-9A-Z!@#%^&*()]+)*\$";
  static final String passwordRegx = "^[a-z0-9A-Z!@#\$%^&*(){}_+*/~`.?<>]*\$";
  //static final String passwordRegx = "^([a-z0-9A-Z!@#\$%^&*(){}[]_-+*/~`.?<>]+)*\$";

  static final String phoneNumberRegx = "^[0-9]*";
  static final String usaPhoneNumberRegex = r'^[0-9() -]*';

  //static final String nameRegx = "^[a-zA-Z]+([a-zA-Z’']+)*\$";
  static final String nameRegx = "^([a-zA-Z’']+)*\$";

  //static final String nameWithSpaceRegx = "^[a-zA-Z]+([a-zA-Z’' ]+)*\$";
  static final String nameWithSpaceRegx = "^([a-zA-Z’' ]+)*\$";

  //static final String userNameRegx = "^[a-zA-Z0-9]+([a-zA-Z0-9]+)*\$";
  static final String userNameRegx = "^([a-zA-Z0-9]+)*\$";

  static final String numberOnlyRegx = "^[0-9]*";

  //static final String numericWithSpaceRegx = "[0-9]+[0-9 ]*";
  static final String numericWithSpaceRegx = "[0-9 ]*";

  static final String numericNoZeroRegx = "^[1-9]*";

  static final String floatValueRegex = "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,2})?\$";

  static final String charactersOnlyRegex = "^[A-Za-z]*";

  //static final String charactersWithSpaceRegex = "^[a-zA-Z]+([a-zA-Z ]+)*\$";
  static final String charactersWithSpaceRegex = "^([a-zA-Z ]+)*\$";

  //static final String charactersWithNumbersRegex = "^[a-z0-9A-Z]+([a-z0-9A-Z]+)*\$";
  static final String charactersWithNumbersRegex = "^([a-z0-9A-Z]+)*\$";

  //static final String charactersNumbersWithSpaceRegex = "^[a-z0-9A-Z]+([a-z0-9A-Z ]+)*\$";
  static final String charactersNumbersWithSpaceRegex = "^([a-z0-9A-Z ]+)*\$";

  //static final String charactersWithSpecialCharacterRegex =  "^[a-z0-9A-Z]+([a-z0-9A-Z!@#%^&*()]+)*\$";   //"^[A-Za-Z!@#%^&*(){}[]_-+*/~`.?<>\$]*\$";
  static final String charactersWithSpecialCharacterRegex =  "^([a-z0-9A-Z!@#%^&*()]+)*\$";   //"^[A-Za-Z!@#%^&*(){}[]_-+*/~`.?<>\$]*\$";

  static final String charactersSpecialCharacterWithSpaceRegex =  '^([a-z0-9A-Z-/\'!@,#%*()\$ ]+)*';   //"^[A-Za-Z!@#%^&*(){}[]_-+*/~`.?<> \$]*\$";

  static final String noneOption = "^[A-Za-Z0-9!@#%^&*(){}[]_-+*/~`.?<> \$]*";

  static final String noneOptionWithOutSpace = "^[A-Za-Z0-9!@#%^&*(){}[]_-+*/~`.?<>\$]*";

  static final String cardExpiryRegex = r'^[0-9/]*';
}



TextInputType _getKeyBoardType(TextFieldType type) {

  TextInputType keyBoardType = TextInputType.text;
  if (type == TextFieldType.email) {
    keyBoardType = TextInputType.emailAddress;
  }
  else if ((type == TextFieldType.phoneNumber) || (type == TextFieldType.cardExpiry)) {
    keyBoardType = TextInputType.phone;
  }
  else if (type == TextFieldType.price) {
    keyBoardType = TextInputType.numberWithOptions(decimal: true);
  }
  return keyBoardType;

}



List<TextInputFormatter> _getListOfForamtter(TextFieldType type, int maxLength) {

  List<TextInputFormatter> arrInputFormatter = [];

  if (type == TextFieldType.email) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.emailRegx1), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.password) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.passwordRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.phoneNumber) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.phoneNumberRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.usaPhoneNumber) {
    arrInputFormatter.add(LengthLimitingTextInputFormatter(maxLength));
    arrInputFormatter.add(WhitelistingTextInputFormatter(new RegExp(CharacterSetType.usaPhoneNumberRegex)));
    arrInputFormatter.add(PhoneNumberTextInputFormatter());
  }
  else if (type == TextFieldType.name) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.nameRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.nameWithSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.nameWithSpaceRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.userName) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.userNameRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.numericOnly) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.numberOnlyRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.numericWithSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.numericWithSpaceRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.numericNoZero) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.numericNoZeroRegx), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.floatValue) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.floatValueRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersOnly) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersOnlyRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersWithSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersWithSpaceRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersWithNumbers) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersWithNumbersRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersNumbersWithSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersNumbersWithSpaceRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersWithSpecialCharacter) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersWithSpecialCharacterRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.charactersSpecialCharacterWithSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.charactersSpecialCharacterWithSpaceRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.price) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.floatValueRegex), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.none) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.noneOption), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.noneNoSpace) {
    arrInputFormatter.add(ValidatorWhitelistingInputFormatter(editingValidator: RegexValidator(regexSource: CharacterSetType.noneOptionWithOutSpace), textType: type, maxLength: maxLength));
  }
  else if (type == TextFieldType.cardExpiry) {
    arrInputFormatter.add(LengthLimitingTextInputFormatter(maxLength));
    arrInputFormatter.add(CardExpiryTextInputFormatter());
    arrInputFormatter.add(WhitelistingTextInputFormatter(new RegExp(CharacterSetType.cardExpiryRegex)));
  }
  return arrInputFormatter;
}




int _getMinLength(TextFieldType type) {
  var minLength = 0;
  if (type == TextFieldType.email) {
    minLength = 2;
  } else if (type == TextFieldType.password) {
    minLength = 6;
  } else if (type == TextFieldType.name) {
    minLength = 2;
  } else if (type == TextFieldType.userName) {
    minLength = 3;
  }  else if (type == TextFieldType.phoneNumber) {
    minLength = 8;
  } else if (type == TextFieldType.nameWithSpace) {
    minLength = 2;
  }
  return minLength;
}

int _getMaxLength(TextFieldType type) {
  var maxLength = 2000;
  if (type == TextFieldType.email) {
    maxLength = 50;
  } else if (type == TextFieldType.password) {
    maxLength = 16;
  } else if (type == TextFieldType.name) {
    maxLength = 50;
  } else if (type == TextFieldType.userName) {
    maxLength = 50;
  }  else if (type == TextFieldType.phoneNumber) {
    maxLength = 16;
  } else if (type == TextFieldType.usaPhoneNumber) {
    maxLength = 14;
  } else if (type == TextFieldType.price) {
    maxLength = 8;
  }
  return maxLength;
}



abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {

  final String regexSource;
  final String allowInputsequence;

  RegexValidator({this.regexSource, this.allowInputsequence});
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorWhitelistingInputFormatter implements TextInputFormatter {
  final StringValidator editingValidator;
  final TextFieldType textType;
  final int maxLength;

  ValidatorWhitelistingInputFormatter({this.editingValidator, this.textType, this.maxLength});

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if (newValue.text.startsWith(" ")) {
      return oldValue;
    }

    //debugPrint("New Text :: ${newValue.text} oldText :: ${oldValue.text} maxLenght :: $maxLength");
    if (newValue.text.length > maxLength) {
      return oldValue;
    }

    // if no validation then allow alll input
    if (this.textType == TextFieldType.none) return newValue;

    // Back space always allow
    if ((oldValue.text.length - newValue.text.length) > 0) {
      return newValue;
    }

    if (newValue.text.contains("  ")) {
      return oldValue;
    }

    // code For not allow conssecutive space using regex not possible
    if ((this.textType != TextFieldType.none) && (newValue.text.length > 0) && (oldValue.text.length > 0)) {
      if ((newValue.text[newValue.text.length - 1] == " ") && (oldValue.text[oldValue.text.length - 1] == " ")) {
        return oldValue;
      }
      else if ((oldValue.text.length == newValue.text.length) && (oldValue.text[oldValue.text.length - 1] == " " && newValue.text[oldValue.text.length - 1] == ".")) {
        return oldValue;
      }
    }

    // Only for textfield type price
    if (this.textType == TextFieldType.price) {
      if ((newValue.text.length > oldValue.text.length) && !(newValue.text.contains('.')) && (newValue.text.length > (maxLength-3))) {
        return TextEditingValue(
            text: '${oldValue.text}.${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            )
        );
      }
    }



    // Means user enter input one by one
    if (((newValue.text.length - oldValue.text.length) == 1)) {
      var updatedString = newValue.text.replaceFirst(oldValue.text, "", 0);
      if (newValue.text.length > 4 && !(textType == TextFieldType.email || textType == TextFieldType.password)) {
        updatedString = newValue.text.substring(newValue.text.length - 4, newValue.text.length);
      }
      final newValueValid = editingValidator.isValid(updatedString);
      if (newValueValid) {
        return newValue;
      }
      return oldValue;
    }

    //debugPrint("Validation check start");
    final newValueValid = editingValidator.isValid(newValue.text);
    final oldValueValid = editingValidator.isValid(oldValue.text);
    //debugPrint("oldValueValid :$oldValueValid  newValueValid :$newValueValid");


    if (!oldValueValid && !newValueValid) { return oldValue; }

    if (oldValueValid && !newValueValid) {
      if (newValue.text.length == 0) return newValue;
      return oldValue;
    }
    return newValue;
  }
}


//region Card Expiry Formatter
class CardExpiryTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    String updatedStr = newValue.text.replaceAll("/", "");

    int usedSubstringIndex = 0;

    final int newTextLength = updatedStr.length;

    final StringBuffer newText = StringBuffer();
    if (newTextLength > 2) {
      newText.write(updatedStr.substring(0, usedSubstringIndex = 2) + '/');
    }
    newText.write(updatedStr.substring(usedSubstringIndex));

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
//endregion


//region PhoneNumber Formatter
class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {


    String updatedStr = newValue.text.replaceAll("(", "");
    updatedStr = updatedStr.replaceAll(")", "");
    updatedStr = updatedStr.replaceAll("-", "");
    updatedStr = updatedStr.replaceAll(" ", "");


    int usedSubstringIndex = 0;

    final int newTextLength = updatedStr.length;

    final StringBuffer newText = StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
    }
    if (newTextLength >= 4) {
      newText.write(updatedStr.substring(0, usedSubstringIndex = 3) + ') ');
    }
    if (newTextLength >= 7) {
      newText.write(updatedStr.substring(3, usedSubstringIndex = 6) + '-');
    }
    if (newTextLength >= 11) {
      newText.write(updatedStr.substring(6, usedSubstringIndex = 10) + ' ');
    }
    if (newTextLength >= usedSubstringIndex) { // Dump the rest.
      newText.write(updatedStr.substring(usedSubstringIndex));
    }


    int selctionIndex = newValue.selection.start + (newValue.text.length - newText.length).abs();
    selctionIndex = min(selctionIndex, newText.length);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selctionIndex),
    );
  }
}
