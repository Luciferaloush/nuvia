import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/cubit/locale/locale_cubit.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/helper/dio_helper.dart';
import '../../../../core/network/status_code.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKeyLogin = GlobalKey<FormState>();

  static LoginCubit get(context) => BlocProvider.of(context);
  Future<void> login(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;

    print(languageCode);
    emit(LoginLoading());
    DioHelper.postData(
        url: "${EndpointConstants.login}$languageCode",
        data: {
          "email": email.text.trim(),
          "password": password.text.trim(),
        }).then((value) {
      print({
        "email": email.text.trim(),
        "password": password.text.trim(),
      });
      if (value == null) {
        emit(LoginError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
      }
      if (value.statusCode != StatusCode.ok) {
        if (kDebugMode) {
          print(value.data.runtimeType);
          print(value.data);
          print(value.statusCode);
        }

        emit(LoginError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        CacheHelper.saveData(key: "token", value: value.data['token']);
        emit(LoginSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(LoginError(error: error.toString()));
    }).catchError((error, stacktrace) {
      print("Error occurred: ${error.toString()}");
      print("Stacktrace: $stacktrace");
      emit(LoginError(error: error.toString()));
    });

  }

}
