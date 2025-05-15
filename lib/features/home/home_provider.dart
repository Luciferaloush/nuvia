import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../post/cubit/post_cubit.dart';
import '../topic/cubit/topic_cubit.dart';
import 'cubit/home_cubit.dart';
import 'screen.dart';

class HomeProvider extends StatelessWidget {
  const HomeProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => HomeCubit(),
      ),
      BlocProvider(
        create: (context) {
          final cubit = PostCubit();
          cubit.postForYou(context);
          cubit.allPost(context);
          return cubit;
        },
      ),
    ], child: const HomeScreen());
  }
}
