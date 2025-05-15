import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modle/auth/user.dart';
import '../../../widget/post/my_shared_posts.dart';
import '../cubit/post_cubit.dart';

class MySharedPostsScreen extends StatelessWidget {
  final User user;

  const MySharedPostsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        final cubit = PostCubit.get(context);
        if (state is MySharePostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MySharePostError) {
          return Center(child: Text(state.error));
        }
        return ListView.builder(
          itemCount: cubit.sharedPosts.length,
          itemBuilder: (context, index) {
            return MySharedPosts(
              index: index,
              sharedPosts: cubit.sharedPosts[index],
              // onPressed: () {
              //   cubit.addLike(context,
              //       postId: cubit.posts[index].sId.toString());
              // },
              comment: cubit.commentC,
              onPressedSendComments: () {
                cubit.addComments(context,
                    postId: cubit.sharedPosts[index].postId.toString(),
                    comment: cubit.commentC);
              },
              // onPressedSharePosts: () {
              //   cubit.sharePost(context,
              //       postId: cubit.posts[index].sId.toString());
              // },
              // statusComment: cubit.commentStatus,
              // state: state,
              user: user,
            );
          },
        );
      },
      listener: (context, state) {},
    );
  }
}
