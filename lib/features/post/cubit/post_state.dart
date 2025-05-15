part of 'post_cubit.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {}

class PostError extends PostState {
  final String error;

  PostError({required this.error});
}

class PostForYouLoading extends PostState {}

class PostForYouLoaded extends PostState {}

class PostForYouError extends PostState {
  final String error;

  PostForYouError({required this.error});
}

class TPPostLoaded extends PostState {}

class AddLikeLoading extends PostState {}

class AddLikeSuccess extends PostState {}

class AddLikeError extends PostState {
  final String error;

  AddLikeError({required this.error});
}

class AddCommentsLoading extends PostState {}

class AddCommentsSuccess extends PostState {}

class AddCommentsError extends PostState {
  final String error;

  AddCommentsError({required this.error});
}

class SharePostLoading extends PostState {}

class SharePostSuccess extends PostState {}

class SharePostError extends PostState {
  final String error;

  SharePostError({required this.error});
}

class MySharePostLoading extends PostState {}

class MySharePostLoaded extends PostState {
  final List<SharedPosts> sharedPosts;

  MySharePostLoaded({required this.sharedPosts});
}

class MySharePostError extends PostState {
  final String error;

  MySharePostError({required this.error});
}
