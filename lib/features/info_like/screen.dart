import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/post/info_like.dart';
import 'cubit/info_like_cubit.dart';

class InfoLikeScreen extends StatelessWidget {
  final String postId;

  const InfoLikeScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InfoLikeCubit()..infoLike(context, postId: postId),
      child: BlocConsumer<InfoLikeCubit, InfoLikeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = InfoLikeCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: state is InfoLikeLoading
                ? const Center(child: CircularProgressIndicator())
                : InfoLike(cubit: cubit, postId: postId),
          );
        },
      ),
    );
  }
}
