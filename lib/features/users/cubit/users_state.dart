part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {}

class UsersError extends UsersState {
  final String error;

  UsersError({required this.error});
}

class FollowLoading extends UsersState {}

class FollowSuccess extends UsersState {}

class FollowError extends UsersState {
  final String error;

  FollowError({required this.error});
}

class UnFollowLoading extends UsersState {}

class UnFollowSuccess extends UsersState {}

class UnFollowError extends UsersState {
  final String error;

  UnFollowError({required this.error});
}
