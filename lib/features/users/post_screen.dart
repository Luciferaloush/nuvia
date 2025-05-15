import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widget/post/post_item.dart';
import '../../core/theme/app_colors.dart';
import '../../widget/users/posts.dart';
import '../post/cubit/post_cubit.dart';
import 'cubit/users_cubit.dart';

class AllPostUserScreen extends StatelessWidget {
  final TextEditingController c = TextEditingController();

  AllPostUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersState>(
      builder: (context, state) {
        final cubit = UsersCubit.get(context);
        if (state is UnFollowLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserProfileError) {
          return Center(child: Text(state.error));
        }
        return ListView.builder(
          itemCount: cubit.user!.pots!.length,
          itemBuilder: (context, index) {
            final post = cubit.user!.pots![index];
            final postCubit = BlocProvider.of<PostCubit>(context);
            return UserPosts(
              icon: Icon(
                postCubit.userLike[index]
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: postCubit.userLike[index]? AppColor.blue : Theme.of(context).iconTheme.color,
              ),
              cubit: cubit,
              post: post,
              onPressed: () {
                postCubit.addLike(context,
                    postId: post.sId.toString(), index: index);
              },
              comment: c,
              onPressedSendComments: () {
                // cubit.addComments(context,
                //     postId: cubit.posts[index].sId.toString());
              },
              onPressedSharePosts: () {
                // cubit.sharePost(context,
                //     postId: cubit.posts[index].sId.toString());
              },
              onTapLikes: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => InfoLikeScreen(
                //           postId: cubit.posts[index].sId.toString()),
                //     ));
              },
              onTapComments: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CommentsScreen(
                //           postId: cubit.posts[index].sId.toString()),
                //     ));
              },
              statusComment: false,
            );
          },
        );
      },
      listener: (context, state) {
        // if (state is AddLikeSuccess) {
        //   if (kDebugMode) {
        //     print("Add Like Success");
        //   }
        // }
      },
    );
  }
}
