import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'no_internet_state.dart';

class NoInternetCubit extends Cubit<NoInternetState> {
  NoInternetCubit() : super(NoInternetInitial());
}
