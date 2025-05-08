import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helper/cache_helper.dart';
import '../../utils/app_shared_preferences.dart';
import '../../constants/app_constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(_getInitialTheme()));

  static ThemeMode _getInitialTheme() {
    final savedTheme = CacheHelper.getData(key: AppConstants.themeKey);
    if (savedTheme == 'dark') return ThemeMode.dark;
    if (savedTheme == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    await CacheHelper.saveData(
        key: AppConstants.themeKey, value: newTheme.name);
    emit(ThemeState(newTheme));
  }
}
