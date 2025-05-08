part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String error;

  RegisterError({required this.error});
}

class PickImagesLoading extends RegisterState {}

class PickImages extends RegisterState {
  final String images;

  PickImages({required this.images});
}

class RegisterUpdate extends RegisterState {}

class NoInternet extends RegisterState {}
