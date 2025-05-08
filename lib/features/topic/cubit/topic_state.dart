part of 'topic_cubit.dart';

@immutable
abstract class TopicState {}

class TopicInitial extends TopicState {}

class TopicLoading extends TopicState {}

class TopicLoaded extends TopicState {}

class TopicError extends TopicState {
  final String error;

  TopicError({required this.error});
}

class TopicSelectionLoading extends TopicState {}

class TopicSelectionSuccess extends TopicState {}

class TopicSelectionError extends TopicState {
  final String error;

  TopicSelectionError({required this.error});
}
