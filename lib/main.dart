import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/features/auth/profile/cubit/profile_cubit.dart';
import 'core/constants/app_constants.dart';
import 'core/cubit/locale/locale_cubit.dart';
import 'core/cubit/theme/theme_cubit.dart';
import 'core/helper/cache_helper.dart';
import 'core/helper/dio_helper.dart';
import 'core/services/theme_service.dart';
import 'core/utils/app_shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'app.dart';
import 'app_bloc_observer.dart';
import 'features/post/cubit/post_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  runApp(EasyLocalization(
    supportedLocales: AppConstants.supportedLocales,
    path: 'assets/lang',
    fallbackLocale: const Locale('en'),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
            create: (context) => ProfileCubit()
              ..profile(context)
              ..myPosts(context)),
      ],
      child: Builder(
        builder: (context) {
          ScreenUtil.init(
            context,
            designSize: const Size(375, 812),
          );
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state.themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: MyApp(appRouter: AppRouter()),
              );
            },
          );
        },
      ),
    ),
  ));
}
