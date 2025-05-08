import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constant.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) => BlocProvider.of(context);

  Future<void> checkUserLoggedIn() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 3));

    String? token = await Constant.getUserToken();
    if (token != null && token.isNotEmpty) {
      emit(SplashNavigateToHome());
    } else {
      emit(SplashNavigateToLogin());
    }
  }
}