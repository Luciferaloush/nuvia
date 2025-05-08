import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';

import 'cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SplashCubit()..checkUserLoggedIn(),
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is SplashNavigateToHome) {
              context.pushNamedAndRemoveUntil("/homeScreen");
            }
           else if (state is SplashNavigateToLogin) {
              context.pushNamedAndRemoveUntil("/onBoardingScreen");
            }
          },
          builder: (context, state) {

            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(size: 100),
                  SizedBox(height: 20),
                  Text("Splash Screen", style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
