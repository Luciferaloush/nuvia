part of 'following_cubit.dart';

@immutable
abstract class FollowingState {}

class FollowingInitial extends FollowingState {}

class FollowingLoading extends FollowingState {}

class FollowingLoaded extends FollowingState {}

class FollowingFiltered extends FollowingState {}

class FollowingError extends FollowingState {
  final String error;

  FollowingError({required this.error});
}
