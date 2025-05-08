import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/post/comments.dart';
import 'cubit/comments_cubit.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentsCubit()..allComments(context, postId: postId),
      child: BlocConsumer<CommentsCubit, CommentsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = CommentsCubit.get(context);
          return Scaffold(
              appBar: AppBar(

              ),
              body: state is CommentsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Comments(
                      cubit: cubit,
                      postId: postId,
                    ));
        },
      ),
    );
  }
}
