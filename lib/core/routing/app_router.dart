import 'package:flutter/material.dart';
import '../../features/app/home_brovider.dart';
import '../../features/auth/profile/screen.dart';
import '../../features/auth/register/screen.dart';
import '../../features/no_internet/screen.dart';
import '../../features/settings/screen.dart';
import '../../features/topic/screen.dart';
import '../routing/routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());
      case Routes.splashScreen:
        return _createRoute(const SplashScreen());
      case Routes.onBoardingScreen:
        return _createRoute(const OnboardingScreen());
      case Routes.signupScreen:
        return _createRoute(const RegisterScreen());
      case Routes.profileScreen:
        return _createRoute(const ProfileScreen());
      case Routes.noInternetScreen:
        return _createRoute(const NoInternetScreen());
      case Routes.topicsSelectionScreen:
        return _createRoute(const TopicsSelectionScreen());
      case Routes.homeScreen:
        return _createRoute(const AppProvider());
      case Routes.settingScreen:
        return _createRoute(const SettingsScreen());
      default:
        return null;
    }
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
