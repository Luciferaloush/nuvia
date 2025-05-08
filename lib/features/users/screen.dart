import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/custom_users.dart';
import 'cubit/users_cubit.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = UsersCubit();
        cubit.getUsers(context);
        return cubit;
      },
      child: BlocConsumer<UsersCubit, UsersState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = UsersCubit.get(context);
          return CustomUsers(
            showProfile: () {},
            cubit: cubit,
            profile: "Show Profile",
            controller: cubit.controller,
          );
        },
      ),
    );
  }
}
