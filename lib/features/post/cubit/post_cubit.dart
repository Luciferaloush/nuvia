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

import '../../../modle/post/share.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);
  final List<Posts> posts = [];
  final List<Posts> userPosts = [];
  final List<Posts> recommendedPosts = [];
  final List<Posts> excellentPosts = [];
  final List<Posts> topPosts = [];
  final List<Posts> tPPosts = [];
  bool shareStatus = false;
  bool commentStatus = false;
  final String userId = AppConstants.userId;
  final TextEditingController commentC = TextEditingController();
  final List<SharedPosts> sharedPosts = [];
  Like? likes;
  List<bool> userLike = [false];
  postForYou(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(PostForYouLoading());
    DioHelper.getData(
        url: "${EndpointConstants.forYouPosts}$languageCode",
        query: {},
        headers: {"token": AppConstants.token}).then((value) {
      if (value == null) {
        emit(PostForYouError(error: "value is null"));
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
        emit(PostForYouError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (value.data["message"] == "TP") {
          final tPPost = value.data['post'] as List<dynamic>;
          tPPosts.addAll(tPPost
              .map((e) => Posts.fromJson(e as Map<String, dynamic>, userId))
              .toList());
          emit(TPPostLoaded());
        } else {
          final excellentPost = value.data['excellentReco'] as List<dynamic>;
          final topPost = value.data['topPost'] as List<dynamic>;
          excellentPosts.addAll(excellentPost
              .map((e) => Posts.fromJson(e as Map<String, dynamic>, userId))
              .toList());
          topPosts.addAll(topPost
              .map((e) => Posts.fromJson(e as Map<String, dynamic>, userId))
              .toList());
          userLike = List<bool>.filled(excellentPosts.length, false);
          userLike = List<bool>.filled(topPosts.length, false);
          if (kDebugMode) {
            print("excellentPost: $excellentPost");
            print("topPost: $topPost");
          }
          emit(PostForYouLoaded());
        }
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(PostForYouError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(PostForYouError(error: error.toString()));
    });
  }

  allPost(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    emit(PostLoading());
    DioHelper.getData(
        url: "${EndpointConstants.allPosts}$languageCode",
        query: {},
        headers: {"token": AppConstants.token}).then((value) {
      if (value == null) {
        emit(PostError(error: "value is null"));
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
        emit(PostError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        final userPost = value.data['userPosts'] as List<dynamic>;
        final recommendedPost = value.data['recommendedPosts'] as List<dynamic>;
        userPosts.addAll(userPost
            .map((e) =>
                Posts.fromJson(e as Map<String, dynamic>, AppConstants.userId))
            .toList());
        recommendedPosts.addAll(recommendedPost
            .map((e) =>
                Posts.fromJson(e as Map<String, dynamic>, AppConstants.userId))
            .toList());
        userLike = List<bool>.filled(userPosts.length, false);
        userLike = List<bool>.filled(recommendedPosts.length, false);
        if (kDebugMode) {
          print("userPost: $userPost");
          print("recommendedPost: $recommendedPost");
        }
        emit(PostLoaded());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(PostError(error: error.toString()));
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("Error occurred: ${error.toString()}");
        print("Stacktrace: $stacktrace");
      }
      emit(PostError(error: error.toString()));
    });
  }

  Future<void> addLike(BuildContext context,
      {required String postId, required int index}) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    final postIndex = posts.indexWhere((post) => post.sId == postId);
    if (postIndex != -1) {
      posts[postIndex].likeStatus = true;
    }
    while (userLike.length <= index) {
      userLike.add(false);
    }
    userLike[index] = true;

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
        userLike[index] = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${value.data["message"]}'),
            duration: const Duration(seconds: 3),
          ),
        );
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
      {required String postId, required TextEditingController comment}) async {
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
