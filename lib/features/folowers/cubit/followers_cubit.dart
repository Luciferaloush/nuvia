import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../modle/auth/user.dart';

part 'followers_state.dart';

class FollowersCubit extends Cubit<FollowersState> {
  FollowersCubit() : super(FollowersInitial());

  static FollowersCubit get(context) => BlocProvider.of(context);
  final String token = AppConstants.token;

  final List<User> userFollowers = [];

  following(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(FollowersLoading());

    DioHelper.getData(
        url: "${EndpointConstants.followers}$languageCode",
        query: {},
        headers: {
          "token": token,
        }).then((value) {
      if (value == null) {
        emit(FollowersError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      if (value.statusCode == StatusCode.notFound) {
        emit(FollowersError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        final userFollower = value.data['followers'] as List<dynamic>;
        userFollowers.addAll(userFollower
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList());
        emit(FollowersLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(FollowersError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(FollowersError(error: error.toString()));
    });
  }
}
