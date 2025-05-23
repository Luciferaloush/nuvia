part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({required this.error});
}

class MyPostsLoading extends ProfileState {}

class MyPostsLoaded extends ProfileState {
  final List<Posts> post;
  MyPostsLoaded({required this.post});
}

class MyPostsError extends ProfileState {
  final String error;

  MyPostsError({required this.error});
}


class NoInternet extends ProfileState {}


