import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color.dart';
import 'app_font.dart';
import 'logger.dart';

class UIUtills {
  factory UIUtills() {
    return _singleton;
  }

  static final UIUtills _singleton = UIUtills._internal();

  UIUtills._internal() {
    Logger().v("Instance created UIUtills");
  }

  //region Screen Size and Proportional according to device
  double _screenHeight;
  double _screenWidth;

  double get screenHeight => _screenHeight ?? _refrenceScreenHeight;

  double get screenWidth => _screenWidth ?? _refrenceScreenWidth;

  final double _refrenceScreenHeight = 736;
  final double _refrenceScreenWidth = 414;

  void updateScreenDimesion({double width, double height}) {
    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }

  double getProportionalHeight(double height) {
    if (_screenHeight == null) return height;
    final h = _screenHeight * height / _refrenceScreenHeight;
    return h.floorToDouble();
  }

  double getProportionalWidth(double width) {
    if (_screenWidth == null) return width;
    final w = _screenWidth * width / _refrenceScreenWidth;
    return w.floorToDouble();

  }
  //endregion

  static void showSnakBar(BuildContext context, String message) {
    final textStyle = UIUtills().getTextStyleRegular(
        fontName: AppFont.montserratMedium,
        fontSize: 14,
        color: AppColor.whiteColor);

    final text = Text(
      message,
      style: textStyle,
    );

    final snackBar = SnackBar(
      content: text,
      duration: Duration(seconds: 1),
    );

    // Remove Current sanckbar if viewed
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(snackBar);
  }


  static void showSnackBarWithKey(GlobalKey<ScaffoldState> _key, String message) {
    final textStyle = UIUtills().getTextStyleRegular(
        fontName: AppFont.montserratMedium,
        fontSize: 14,
        color: AppColor.whiteColor);

    final text = Text(
      message,
      style: textStyle,
    );

    final snackBar = SnackBar(
      content: text,
      duration: Duration(seconds: 1),
    );

    // Remove Current sanckbar if viewed
    _key.currentState.removeCurrentSnackBar();
    _key.currentState.showSnackBar(snackBar);
  }


  //region SharedPreferences setup
  SharedPreferences _sharedPref;

  Future<SharedPreferences> get sharedPref async {
    if (_sharedPref != null) return _sharedPref; // if _sharedPref is null we instantiate it
    _sharedPref = await _setupSharedPreference();
    return _sharedPref;
  }

  Future<SharedPreferences> _setupSharedPreference() async {
    return await SharedPreferences.getInstance();
  }
  //endregion





  TextStyle getTextStyle({String fontName = 'Nunito-Light', int fontsize = 12, Color color, bool isChangeAccordingToDeviceSize = true, double characterSpacing, double lineSpacing}) {
    double finalFontsize = fontsize.toDouble();

    if (isChangeAccordingToDeviceSize && this._screenWidth != null) {
      finalFontsize = (finalFontsize * _screenWidth) / _refrenceScreenWidth;
    }

    if (characterSpacing != null) {
      return TextStyle(fontSize: finalFontsize, fontFamily: fontName, color: color, letterSpacing: characterSpacing);
    }
    else if (lineSpacing != null) {
      return TextStyle(fontSize: finalFontsize, fontFamily: fontName, color: color, height: lineSpacing);
    }
    return TextStyle(fontSize: finalFontsize, fontFamily: fontName, color: color);

  }


//region TextStyle
  TextStyle getTextStyleRegular({
    String fontName = "MontserratRegular",
    int fontSize = 14,
    Color color,
    bool isChangeAccordingToDeviceSize = true,
    double characterSpacing,
    double lineSpacing,
    FontWeight weight = FontWeight.normal
  }) {
    double finalFontsize = fontSize.toDouble();
    if (isChangeAccordingToDeviceSize && this._screenWidth != null) {
      finalFontsize = (finalFontsize * _screenWidth) / _refrenceScreenWidth;
    }

    if (characterSpacing != null) {
      return TextStyle(
        fontWeight: weight,
        fontSize: finalFontsize,
        fontFamily: fontName,
        color: color,
        letterSpacing: characterSpacing,
      );
    } else if (lineSpacing != null) {
      return TextStyle(
        fontWeight: weight,
        fontSize: finalFontsize,
        fontFamily: fontName,
        color: color,
        height: lineSpacing,
        letterSpacing: characterSpacing,
      );
    }
    return TextStyle(
      fontWeight: weight,
      fontSize: finalFontsize,
      fontFamily: fontName,
      color: color,
      letterSpacing: characterSpacing,);
  }
}
