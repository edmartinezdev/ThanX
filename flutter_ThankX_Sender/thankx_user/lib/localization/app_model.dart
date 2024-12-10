import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thankx_user/utils/device_utils.dart';
import 'package:thankx_user/utils/logger.dart';

import 'localization.dart';

class AppModel extends Model {

  String pastLanguageOfApp;
  static AppModel globalAppModel;

  static const Locale enLocale = Locale('en');
  static const Locale arLocale = Locale('ar');

  Locale _appLocale;
  Locale get appLocal {
    if (_appLocale == null) return enLocale;
    return _appLocale;
  }

  AppModel(String appLanguge) {

    // Set to global app model
    if (appLanguge == 'en') { _appLocale = enLocale; }
    if (appLanguge == 'ar') { _appLocale = arLocale; }
    globalAppModel = this;
    DeviceUtil().currentLanguageCode = appLanguge;
  }


  List<Locale> get supportedLocales => [ enLocale, arLocale];

  void chagneLanguge({String languageCode}) async {
    Logger().i("Current Local changed with language code $languageCode");

    if (languageCode.toLowerCase() == 'en') { _appLocale = enLocale; }
    if (languageCode.toLowerCase() == 'ar') { _appLocale = arLocale; }
    else { _appLocale = enLocale; }

    // Load new language from locale
//    AppTranslations.globalTranslations.load();

    DeviceUtil().currentLanguageCode = _appLocale.languageCode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('CurrentDeviceLanguage', _appLocale.languageCode.toLowerCase());
    notifyListeners();
  }
}