part of 'replies_cubit.dart';

@immutable
abstract class RepliesState {}

class RepliesInitial extends RepliesState {}

class RepliesLoading extends RepliesState {}

class RepliesLoaded extends RepliesState {}

class RepliesError extends RepliesState {
  final String error;

  RepliesError({required this.error});
}
