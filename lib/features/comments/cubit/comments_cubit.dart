import 'dart:convert';

import 'package:eventsource/eventsource.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modle/post/comments.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit() : super(CommentsInitial());

  static CommentsCubit get(context) => BlocProvider.of(context);

  final List<Comments> comments = [];

  allComments(BuildContext context, {required String postId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(CommentsLoading());

    final url =
        "${EndpointConstants.baseUrl}${EndpointConstants.interaction}$postId/comments?language=$languageCode";

    try {
      final eventSource = await EventSource.connect(url, headers: {
        "token": AppConstants.token,
      });

      eventSource.listen((Event event) {
        if (kDebugMode) {
          print('Received event: ${event.data}');
        }
        final data = json.decode(event.data.toString());
        final List<dynamic> comment = data['comments'];
        if (kDebugMode) {
          print(comment);
        }
        comments.addAll(comment
            .map((e) => Comments.fromJson(e as Map<String, dynamic>))
            .toList());
        emit(CommentsLoaded());
      }, onError: (error) {
        if (kDebugMode) {
          print('Error: $error');
        }
        emit(CommentsError(error: error.toString()));
      }, onDone: () {
        if (kDebugMode) {
          print('Connection closed');
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error occurred: $error");
      }
      emit(CommentsError(error: error.toString()));
    }
  }
}
