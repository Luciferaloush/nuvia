part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeTabState extends HomeState {
  final int currentTabIndex;

  HomeTabState(this.currentTabIndex);
}

class AddPostLoading extends HomeState {}

class PostAddedSuccessfully extends HomeState {}

class AddPostError extends HomeState {}

class PickImages extends HomeState {
  final List<File>images;
  PickImages({required this.images});
}

