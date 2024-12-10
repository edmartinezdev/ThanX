import 'dart:core';


extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String convertToUSAPhoneNumber() {

    if (this.length == 0) { return this; }

    if (this.length > 0 && this.contains('(')) {
        return this;
    }

    String updatedStr = this.replaceAll("(", "");
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

    return newText.toString();
  }

  String convertToPhoneNumber() {

    String updatedStr = this.replaceAll("(", "");
    updatedStr = updatedStr.replaceAll(")", "");
    updatedStr = updatedStr.replaceAll("-", "");
    updatedStr = updatedStr.replaceAll(" ", "");
    return updatedStr;
  }
}