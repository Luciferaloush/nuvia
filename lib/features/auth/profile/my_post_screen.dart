import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/profile/my_posts.dart';
import 'cubit/profile_cubit.dart';

class MyPostScreen extends StatelessWidget {
  const MyPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = ProfileCubit.get(context);
        if (state is MyPostsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MyPostsLoaded) {
          return ListView.builder(
            itemCount: cubit.posts.length,
            itemBuilder: (context, index) {
              final post = cubit.posts[index];
              return MyPostItem(
                post: post,
                comment: cubit.comment,
                index: index,
                user: cubit.user,
                onPressedSharePosts: () {},
                onTapLikes: () {},
                onTapComments: () {},
                onPressedSendComments: () {},
                onPressed: () {},
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
