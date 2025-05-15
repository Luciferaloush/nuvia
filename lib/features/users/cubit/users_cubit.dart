import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../modle/auth/user.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());

  static UsersCubit get(context) => BlocProvider.of(context);

  final String token = AppConstants.token;

  final List<User> users = [];
  final List<User> userFollowing = [];
  final List<User> userFollowers = [];

  User? user;
  final TextEditingController controller = TextEditingController();
  List<bool> userFollow = [false];

  getUsers(BuildContext context) async {
    emit(UsersLoading());

    DioHelper.getData(url: EndpointConstants.getUsers, query: {}, headers: {
      "token": token,
    }).then((value) {
      if (value == null) {
        emit(UsersError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      final user = value.data['users'] as List<dynamic>;
      if (value.statusCode == StatusCode.notFound) {
        emit(UsersError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        users.addAll(
            user.map((e) => User.fromJson(e as Map<String, dynamic>)).toList());
        userFollow = List<bool>.filled(users.length, false);
        emit(UsersLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(UsersError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(UsersError(error: error.toString()));
    });
  }

  usersProfile(BuildContext context, {required String userId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(UserProfileLoading());

    DioHelper.getData(
        url: "${EndpointConstants.userProfile}$userId?language=$languageCode",
        query: {},
        headers: {
          "token": token,
        }).then((value) {
      if (value == null) {
        emit(UserProfileError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      final users = value.data;
      if (value.statusCode == StatusCode.notFound) {
        emit(UserProfileError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        user = User.fromJson(users);
        emit(UserProfileLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(UserProfileError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(UserProfileError(error: error.toString()));
    });
  }

  late String status;

  followingStatus() {
    if (user != null) {
      if (user!.followingStatus == 1 || user!.followingStatus == 2) {
        status = "Following";
      } else if (user!.followingStatus == 0) {
        status = "Follow back";
      } else if (user!.followingStatus == 3) {
        status = "Follow";
      }
    } else {
      status = "Unknown";
    }
  }

  Future<void> follow(BuildContext context,
      {required String userId, required int index}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    userFollow[index] = true;
    if (kDebugMode) {
      print(languageCode);
    }
    emit(FollowLoading());
    DioHelper.postData(
        url: "${EndpointConstants.follow}$userId?language=$languageCode",
        data: {},
        headers: {"token": token}).then((value) {
      if (value == null) {
        userFollow[index] = false;
        emit(FollowError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
      }
      if (value.statusCode != StatusCode.ok) {
        userFollow[index] = false;
        if (kDebugMode) {
          print(value.data.runtimeType);
          print(value.data);
          print(value.statusCode);
        }

        emit(FollowError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        emit(FollowSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(FollowError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
      }
      if (kDebugMode) {
        print("Stacktrace: $stacktrace");
      }
      emit(FollowError(error: error.toString()));
    });
  }

  Future<void> unfollow(BuildContext context,
      {required String userId, required int index}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    userFollow[index] = false;
    if (kDebugMode) {
      print(languageCode);
    }
    emit(UnFollowLoading());
    DioHelper.postData(
        url: "${EndpointConstants.unfollow}$userId?language=$languageCode",
        data: {},
        headers: {"token": token}).then((value) {
      if (value == null) {
        userFollow[index] = true;
        emit(UnFollowError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
      }
      if (value.statusCode != StatusCode.ok) {
        userFollow[index] = true;
        if (kDebugMode) {
          print(value.data.runtimeType);
          print(value.data);
          print(value.statusCode);
        }

        emit(UnFollowError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        emit(UnFollowSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(UnFollowError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(UnFollowError(error: error.toString()));
    });
  }

}
