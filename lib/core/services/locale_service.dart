import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';


import '../helper/cache_helper.dart';
import '../utils/app_shared_preferences.dart';


class LocaleService {


 LocaleService();


 static const _defaultLocale = Locale('en');


 /// Load saved locale or fallback
 Locale getCurrentLocale() {


   final localeCode = CacheHelper.getData(key: AppConstants.localeKey);
   if (localeCode != null) {
     return Locale(localeCode);
   }
   return _defaultLocale;
 }


 /// Save locale and update easy_localization
 Future<void> setLocale(BuildContext context, String languageCode) async {
   await CacheHelper.saveData(key: AppConstants.localeKey, value: languageCode);
   await context.setLocale(Locale(languageCode));
 }
}


