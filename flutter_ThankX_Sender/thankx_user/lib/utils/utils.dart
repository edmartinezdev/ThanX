import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thankx_user/control/alert_widget.dart';
import 'package:thankx_user/utils/ui_utils.dart';

import 'app_color.dart';
import 'app_font.dart';
import 'logger.dart';

class Utils{

  factory Utils() {
    return _singleton;
  }

  static final Utils _singleton = Utils._internal();

  Utils._internal() {
    Logger().v("Instance created Utils");
  }
  //region Convert Map
  static Map<String, dynamic> convertMap(dynamic map) {

    Map<dynamic, dynamic> mapDynamic;
    if (map is String) {
      var obj = json.decode(map);
      mapDynamic = obj;
    } else if (map is Map<dynamic, dynamic>) {
      mapDynamic = map;
    } else {
      return Map<String, dynamic>();
    }

    Map<String, dynamic> convertedMap = Map<String, dynamic>();
    for (dynamic key in mapDynamic.keys) {
      if (key is String) {
        convertedMap[key] = mapDynamic[key];
      }
    }
    return convertedMap;
  }
//endregion

  //region Alert Cotrol
  static showAlert(BuildContext _context,
      {String title,
        String message,
        List<String> arrButton,
        AlertWidgetButtonActionCallback callback}) {
    var alertDialog = AlertWidget(
        title: title,
        message: message,
        buttonOption: arrButton,
        onCompletion: callback);

    // flutter defined function
    showDialog(
        barrierDismissible: true,
        context: _context,
        builder: (BuildContext context1) {
          return alertDialog;
        });
  }

//endregion

//region show snakbar
  static void showSnakBar(BuildContext context, String message) {
    if (message.length == 0) { return; }

    // Remove Current sanckbar if viewed
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: UIUtills().getTextStyle(
            fontName: AppFont.montserratBold,
            fontsize: 14,
            color: AppColor.whiteColor),
      ),
      duration: Duration(seconds: 1),
      backgroundColor: AppColor.priceTextColor,
    ));
  }

//endregio  n

  //region show snakbar
  static void showSnakBarwithKey(GlobalKey<ScaffoldState> key, String message) {
    final textStyle = UIUtills().getTextStyleRegular(
        fontName: AppFont.montserratMedium,
        fontSize: 14,
        color: AppColor.whiteColor);
    if (message.length == 0) { return; }

    // Remove Current sanckbar if viewed
    key.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: textStyle,
      ),
      duration: Duration(seconds: 1),
      backgroundColor: AppColor.textColor,
    ));
  }

//endregion


  //region Bottom sheet in IOs
  static showBottomSheet(BuildContext _context,
      {String title = '',
        String message = '',
        List<String> arrButton,
        AlertWidgetButtonActionCallback callback}) {
    final titlewidget = (title.length > 0)
        ? Text(
      title,
      style: UIUtills().getTextStyle(
          fontName: AppFont.montserratMedium,
          fontsize: 14,
          color: AppColor.textColor),
    )
        : null;
    final messsagewidget = (message.length > 0)
        ? Text(
      message,
      style: UIUtills().getTextStyle(
          fontName: AppFont.montserratRegular,
          fontsize: 14,
          color: AppColor.textColor),
    )
        : null;

    void onButtonPressed(String btnTitle) {
      int index = arrButton.indexOf(btnTitle) ?? -1;
      //dismiss Diloag
      Navigator.of(_context).pop();

      // Provide callback
      if (callback != null) {
        callback(index);
      }
    }

    List<Widget> actions = [];

    for (String str in arrButton) {
      bool isDistructive =
          (str.toLowerCase() == "delete") || (str.toLowerCase() == "no");
      actions.add(CupertinoDialogAction(
        child: Container(
          child: Text(
            str,
            style: UIUtills().getTextStyle(
                fontName: AppFont.montserratRegular,
                fontsize: 20,
                color: AppColor.primaryColor1),
          ),
          alignment: Alignment.center,
          height: UIUtills().getProportionalWidth(44.0),
        ),
        onPressed: () => onButtonPressed(str),
        isDestructiveAction: isDistructive,
      ));
    }

    final cancelAciton = CupertinoActionSheetAction(
      onPressed: () => onButtonPressed('Cancel'),
      child: Text(
        'Cancel',
        style: UIUtills().getTextStyle(
            fontName: AppFont.montserratMedium,
            fontsize: 20,
            color: AppColor.primaryColor1),
      ),
    );
    final actionSheet = CupertinoActionSheet(
      title: titlewidget,
      message: messsagewidget,
      actions: actions,
      cancelButton: cancelAciton,
    );

    showCupertinoModalPopup(
        context: _context,
        builder: (BuildContext context) => actionSheet).then((result) {
      print("Result :: $result");
    });
  }
//endregion


  static String dateToString(String date,{bool isdateandtime = false}) {

    //DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
    DateFormat formatter1 = isdateandtime ?DateFormat("MM/dd/yyyy hh:mm a"):DateFormat("MM/dd/yyyy");

    if (date != null) {
      try {
        print("Utc "+ date);
        var d1= formatter.parse(date).add(DateTime.now().timeZoneOffset);
        print("local "+formatter1.format(d1));
      return  formatter1.format(d1);
      } catch (e) {
        print('Error formatting date: $e');
      }
    }
    return '';
  }

  static String convertDateTimeToUtc(DateTime date) {
    try{
      DateFormat formatter = DateFormat("dd-MM-yyyy hh:mm a");
      return formatter.parse(formatter.format(date)).toUtc().toString();
    }
    catch(e){
      print('Error formatting date: $e');
    }
    return '';
  }

  static DateTime stringToDate(String string, {String format, bool isUTCtime = false, bool isReuireNullIfDateNotParse = false }) {

    DateFormat formatter = DateFormat(format);
    if (string?.isNotEmpty ?? false) {
      try {
        DateTime convertedDate = formatter.parse(string);
        if (isUTCtime) {
          convertedDate = convertedDate.add(DateTime.now().timeZoneOffset);
        }
        return convertedDate;
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    return isReuireNullIfDateNotParse ? null : DateTime.now();
  }


//endregion

}