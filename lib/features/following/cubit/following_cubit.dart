import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../modle/auth/user.dart';

part 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  FollowingCubit() : super(FollowingInitial());

  static FollowingCubit get(context) => BlocProvider.of(context);
  final String token = AppConstants.token;

  final List<User> userFollowing = [];

  following(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(FollowingLoading());

    DioHelper.getData(
        url: "${EndpointConstants.following}$languageCode",
        query: {},
        headers: {
          "token": token,
        }).then((value) {
      if (value == null) {
        emit(FollowingError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      if (value.statusCode == StatusCode.notFound) {
        emit(FollowingError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        final userFollo = value.data['following'] as List<dynamic>;
        userFollowing.addAll(userFollo
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList());
        emit(FollowingLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(FollowingError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(FollowingError(error: error.toString()));
    });
  }


}
