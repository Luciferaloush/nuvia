import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/no_internet_cubit.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => NoInternetCubit(),
        child: BlocConsumer<NoInternetCubit, NoInternetState>(
          listener: (context, state) {

          },
          builder: (context, state) {
            return Container();
          },
        ),
      ),
    );
  }
}
