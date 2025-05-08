import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../core/utils/constant.dart';
import '../../../modle/replies/my_replies.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> {
  RepliesCubit() : super(RepliesInitial());

  static RepliesCubit get(context) => BlocProvider.of(context);
  late MyReplies myReply;

  myReplies() async {
    emit(RepliesLoading());
    DioHelper.getData(
        url: EndpointConstants.myReplies,
        query: {},
        headers: {"token": AppConstants.token}).then((value) {
      if (value == null) {
        emit(RepliesError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      if (value.statusCode == StatusCode.notFound) {
        emit(RepliesError(error: value.data["message"]));
      }
      if (value.statusCode == StatusCode.ok) {
        final replies = value.data;
        // myReply.addAll(replies
        //     .map((e) => MyReplies.fromJson(e as Map<String, dynamic>))
        //     .toList());
        myReply = MyReplies.fromJson(replies);
        emit(RepliesLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(RepliesError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(RepliesError(error: error.toString()));
    });
  }
}
