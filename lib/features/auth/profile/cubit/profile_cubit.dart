import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/cubit/locale/locale_cubit.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/helper/dio_helper.dart';
import '../../../../core/network/status_code.dart';
import '../../../../modle/auth/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  late User user;

  profile(BuildContext context) async {
    final cachedUser = CacheHelper.getData(key: 'user_data');

    if (cachedUser != null) {
      user = User.fromJson(json.decode(cachedUser));
      emit(ProfileLoaded(user: user));
      return;
    }
    emit(ProfileLoading());
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    DioHelper.getData(
      url: "${EndpointConstants.profile}$languageCode",
      query: {},
      headers: {
        "token": CacheHelper.getData(key: "token")
      }
    ).then((value) {
      if (value == null) {
        emit(ProfileError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      final profile = value.data['user'];
      if (value.statusCode == StatusCode.notFound) {
        emit(ProfileError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        user = User.fromJson(profile);
        CacheHelper.saveData(key: "user_data", value: json.encode(user.toJson()));
        emit(ProfileLoaded(user: user));
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(ProfileError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(ProfileError(error: error.toString()));
    });
  }
}
