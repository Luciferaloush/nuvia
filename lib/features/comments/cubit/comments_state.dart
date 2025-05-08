part of 'comments_cubit.dart';

@immutable
abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {}

class CommentsError extends CommentsState {
  final String error;

  CommentsError({required this.error});
}
