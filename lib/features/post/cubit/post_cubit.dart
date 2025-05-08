import 'package:eventsource/eventsource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/cache_helper.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';
import '../../../modle/post/like.dart';
import '../../../modle/post/post.dart';
import 'dart:convert';

import '../../../modle/post/share.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);
  final List<Posts> posts = [];
  bool shareStatus = false;
  bool commentStatus = false;
  final TextEditingController comment = TextEditingController();
  final List<SharedPosts> sharedPosts = [];
   Like? likes;

  allPost(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;

    emit(PostLoading());
    final url =
        "https://nuvia-server-1.onrender.com${EndpointConstants.allPosts}$languageCode";

    try {
      final eventSource = await EventSource.connect(url, headers: {
        "token": AppConstants.token,
      });

      eventSource.listen((Event event) {
        if (kDebugMode) {
          print('Received event: ${event.data}');
        }
        final List<dynamic> post = json.decode(event.data.toString());
        if (kDebugMode) {
          print(post);
        }
        posts.addAll(post
            .map((e) => Posts.fromJson(e as Map<String, dynamic>))
            .toList());
        emit(PostLoaded());
      }, onError: (error) {
        if (kDebugMode) {
          print('Error: $error');
        }
        emit(PostError(error: error.toString()));
      }, onDone: () {
        if (kDebugMode) {
          print('Connection closed');
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error occurred: $error");
      }
      emit(PostError(error: error.toString()));
    }
  }

  Future<void> addLike(BuildContext context, {required String postId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    final postIndex = posts.indexWhere((post) => post.sId == postId);
    if (postIndex != -1) {
      posts[postIndex].likeStatus = true;
    }
    emit(AddLikeLoading());
    DioHelper.postData(
        url: "${EndpointConstants.addLike}$languageCode",
        data: {"postId": postId},
        headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
      if (value == null) {
        emit(AddLikeError(error: "value is null"));
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
        final postIndex = posts.indexWhere((post) => post.sId == postId);
        if (postIndex != -1) {
          posts[postIndex].likeStatus = false;
        }
        emit(AddLikeError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        final postIndex = posts.indexWhere((post) => post.sId == postId);
        if (postIndex != -1) {
          posts[postIndex].likeStatus = true;
        }
        emit(AddLikeSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(AddLikeError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(AddLikeError(error: error.toString()));
    });
  }

  Future<void> addComments(BuildContext context,
      {required String postId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(AddCommentsLoading());

    DioHelper.postData(
        url:
            "${EndpointConstants.interaction}$postId/comments?language=$languageCode",
        data: {"comment": comment.text.trim()},
        headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
      if (value == null) {
        emit(AddCommentsError(error: "value is null"));
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
        emit(AddCommentsError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        commentStatus = true;

        comment.clear();
        emit(AddCommentsSuccess());
        Future.delayed(const Duration(seconds: 2), () async {
          emit(PostLoaded());
        });
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(AddCommentsError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(AddCommentsError(error: error.toString()));
    });
  }

  Future<void> sharePost(BuildContext context, {required String postId}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(AddCommentsLoading());

    DioHelper.postData(
        url:
            "${EndpointConstants.interaction}$postId/share-post?language=$languageCode",
        headers: {"token": CacheHelper.getData(key: "token")},
        data: {}).then((value) {
      if (value == null) {
        emit(SharePostError(error: "value is null"));
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
        emit(SharePostError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        shareStatus = true;
        Fluttertoast.showToast(
          msg: "تم مشاركة المنشور بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        emit(SharePostSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(SharePostError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(SharePostError(error: error.toString()));
    });
  }

  Future<void> mySharedPosts(
    BuildContext context,
  ) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(AddCommentsLoading());

    DioHelper.getData(
        url: "${EndpointConstants.mySharedPosts}$languageCode",
        headers: {"token": CacheHelper.getData(key: "token")},
        query: {}).then((value) {
      if (value == null) {
        emit(MySharePostError(error: "value is null"));
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
        emit(MySharePostError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        final share = value.data['sharedPosts'] as List<dynamic>;
        sharedPosts.addAll(share
            .map((e) => SharedPosts.fromJson(e as Map<String, dynamic>))
            .toList());
        emit(MySharePostLoaded(sharedPosts: sharedPosts));
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(MySharePostError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(MySharePostError(error: error.toString()));
    });
  }

}
