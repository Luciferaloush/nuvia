import 'package:flutter/foundation.dart';

import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/cache_helper.dart';
import '../../../core/helper/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/status_code.dart';
import '../../../modle/post/like.dart';

part 'info_like_state.dart';

class InfoLikeCubit extends Cubit<InfoLikeState> {
  InfoLikeCubit() : super(InfoLikeInitial());

  static InfoLikeCubit get(context) => BlocProvider.of(context);

  Like? likes;

  infoLike(BuildContext context, {required String postId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(InfoLikeLoading());

    DioHelper.getData(
        url:
            "${EndpointConstants.interaction}$postId/likes?language=$languageCode",
        query: {},
        headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
      if (value == null) {
        emit(InfoLikeError(error: "value is null"));
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
        emit(InfoLikeError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        final like = value.data;
        print("like: $like");
        likes = Like.fromJson(like);
        emit(InfoLikeLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(InfoLikeError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(InfoLikeError(error: error.toString()));
    });
  }
}
