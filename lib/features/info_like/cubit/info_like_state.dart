part of 'info_like_cubit.dart';

@immutable
abstract class InfoLikeState {}

class InfoLikeInitial extends InfoLikeState {}

class InfoLikeLoading extends InfoLikeState {}

class InfoLikeLoaded extends InfoLikeState {}

class InfoLikeError extends InfoLikeState {
  final String error;

  InfoLikeError({required this.error});
}
