import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/cache_helper.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../modle/topic/topics.dart';

part 'topic_state.dart';

class TopicCubit extends Cubit<TopicState> {
  TopicCubit() : super(TopicInitial());

  static TopicCubit get(context) => BlocProvider.of(context);

  late Topics topics;

  getTopic(BuildContext context) {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;

    if (kDebugMode) {
      print(languageCode);
    }
    emit(TopicLoading());
    DioHelper.getData(
        url: "${EndpointConstants.getAllTopic}$languageCode",
        query: {},
        headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
      if (value == null) {
        if (kDebugMode) {
          print("value is null");
        }
        emit(TopicError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
        print(value.data);
      }
      if (value.statusCode != StatusCode.ok) {
        if (kDebugMode) {
          print(value.data.runtimeType);
          print(value.data);
          print(value.statusCode);
        }

        emit(TopicError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.notFound) {
        emit(TopicError(error: value.data['message']));
      }
      if (value.statusCode == StatusCode.ok) {
        final topic = value.data;
        topics = Topics.fromJson(topic);
        if (kDebugMode) {
          print("Status Code ${StatusCode.ok} and date $topics");
        }
        emit(TopicLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(TopicError(error: error.toString()));
    }).catchError((error, stacktrace) {
      print("Error occurred: ${error.toString()}");
      print("Stacktrace: $stacktrace");
      emit(TopicError(error: error.toString()));
    });
  }

  Future<void> selectTopics(
      List<String> selectedTopics, BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;

    if (kDebugMode) {
      print(languageCode);
    }
    if (selectedTopics.length > 5) {
      emit(TopicError(error: "You can't select more than 5 topics"));
      return;
    }
    try {
      emit(TopicSelectionLoading());
      DioHelper.postData(
          url: "${EndpointConstants.selectTopics}$languageCode",
          data: {"selectedTopics": selectedTopics},
          headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
        if (value == null) {
          if (kDebugMode) {
            print("value is null");
          }
          emit(TopicSelectionError(error: "value is null"));
          return;
        }
        if (kDebugMode) {
          print(value.statusCode);
          print(value.data);
        }
        if (value.statusCode != StatusCode.ok) {
          if (kDebugMode) {
            print(value.data.runtimeType);
            print(value.data);
            print(value.statusCode);
          }

          emit(TopicSelectionError(error: value.data.toString()));
          return;
        }
        if (value.statusCode == StatusCode.notFound) {
          emit(TopicSelectionError(error: value.data['message']));
        }
        if (value.statusCode == StatusCode.ok) {
          if (kDebugMode) {
            print(value.data);
          }
          emit(TopicSelectionSuccess());
        }
      }).catchError((error, stacktrace) {
        if (kDebugMode) {
          print("error: $error\nstacktrace: $stacktrace,\n");
        }
        emit(TopicSelectionError(error: error.toString()));
      }).catchError((error, stacktrace) {
        if (kDebugMode) {
          print("Error occurred: ${error.toString()}");
          print("Stacktrace: $stacktrace");
        }
        emit(TopicSelectionError(error: error.toString()));
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(TopicSelectionError(error: e.toString()));
    }
  }
}
