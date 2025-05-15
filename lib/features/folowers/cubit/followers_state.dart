part of 'followers_cubit.dart';

@immutable
abstract class FollowersState {}

class FollowersInitial extends FollowersState {}

class FollowersLoading extends FollowersState {}

class FollowersLoaded extends FollowersState {}

class FollowersError extends FollowersState {
  final String error;

  FollowersError({required this.error});
}
