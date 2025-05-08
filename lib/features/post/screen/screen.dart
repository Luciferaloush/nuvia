import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/post/post_item.dart';
import '../../comments/screen.dart';
import '../../info_like/screen.dart';
import '../cubit/post_cubit.dart';

class AllPostScreen extends StatelessWidget {
  const AllPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        final cubit = PostCubit.get(context);
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostError) {
          return Center(child: Text(state.error));
        }
        return ListView.builder(
          itemCount: cubit.posts.length,
          itemBuilder: (context, index) {
            return PostItem(
              post: cubit.posts[index],
              onPressed: () {
                cubit.addLike(context,
                    postId: cubit.posts[index].sId.toString());
              },
              comment: cubit.comment,
              onPressedSendComments: () {
                cubit.addComments(context,
                    postId: cubit.posts[index].sId.toString());
              },
              onPressedSharePosts: () {
                cubit.sharePost(context,
                    postId: cubit.posts[index].sId.toString());
              },
              onTapLikes: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoLikeScreen(
                          postId: cubit.posts[index].sId.toString()),
                    ));
              },
              onTapComments: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                          postId: cubit.posts[index].sId.toString()),
                    ));
              },
              statusComment: cubit.commentStatus,
              state: state,
            );
          },
        );
      },
      listener: (context, state) {
        if (state is AddLikeSuccess) {
          if (kDebugMode) {
            print("Add Like Success");
          }
        }
      },
    );
  }
}
