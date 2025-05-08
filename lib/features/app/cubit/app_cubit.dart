import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'app_state.dart';

class AppCubit extends Cubit<int> {
  AppCubit() : super(0);

  void updateIndex(int index) => emit(index);
}
