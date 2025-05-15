import 'dart:ui';

import '../helper/cache_helper.dart';


class AppConstants {
 static const String appName = 'My App';
 static const List<Locale> supportedLocales = [Locale('en'), Locale('ar')];
 static const String localeKey = 'app_locale';
 static const String themeKey = 'app_theme';
 static  String token = CacheHelper.getData(key: "token");
 static  String userId = CacheHelper.getData(key: "userId");


}
