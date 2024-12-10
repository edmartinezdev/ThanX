import 'dart:core';
import 'package:intl/intl.dart';

import 'logger.dart';
import 'app_dateformat.dart';
export 'app_dateformat.dart';


class DateUtilss {

  //region Date Comversation
  static String dateToString(DateTime date, {String format}) {

    DateFormat formatter = DateFormat(format);
    if (date != null) {
      try {
        return formatter.format(date);
      } catch (e) {
        Logger().v('Error formatting date: $e');
      }
    }
    return '';
  }
  //endregion

  static DateTime stringToDate(String string, {String format = "", bool isUTCtime = false, bool isReuireNullIfDateNotParse = false}) {

    List<String> arrServerDateFormat = List<String>();
    if (format.length > 0) {
      arrServerDateFormat.add(format);
    } else {
      arrServerDateFormat.add(AppDataFormat.serverDateTimeFormat1);
      arrServerDateFormat.add(AppDataFormat.serverDateTimeFormat2);
      arrServerDateFormat.add(AppDataFormat.serverDateTimeFormat3);
    }

    DateTime convertedDateTime;
    for (String str in arrServerDateFormat) {
      convertedDateTime = DateUtilss._stringToDate(string, format: str, isUTCtime: isUTCtime);
      if (convertedDateTime != null) {
        return convertedDateTime;
      }
    }

    if (convertedDateTime == null) {
      Logger().v('Error parsing date: $string for Foramt: $arrServerDateFormat');
    }

    if (isReuireNullIfDateNotParse) {
      return null;
    }
    return DateTime.now();
  }

  static DateTime _stringToDate(String string, {String format, bool isUTCtime = false}) {
    DateFormat formatter = DateFormat(format);
    if (string?.isNotEmpty ?? false) {
      try {

        var convertedDate = formatter.parse(string);
        if (isUTCtime) {
          convertedDate = convertedDate.add(DateTime.now().timeZoneOffset);
        }
        return convertedDate;
      } catch (e) { }
    }
    return null;
  }

}