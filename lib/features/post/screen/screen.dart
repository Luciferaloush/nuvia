import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/sizedbox_extensions.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widget/post/post_item.dart';
import '../../../widget/post/post_reco_item.dart';
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
        return SingleChildScrollView(
          child: Column(
            children: [
              // Following Users Posts
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.userPosts.length,
                itemBuilder: (context, index) {
                  return PostItem(
                    cubit: cubit,
                    index: index,
                    post: cubit.userPosts[index],
                    onPressed: () {
                      cubit.addLike(context,
                        postId: cubit.userPosts[index].sId.toString(), index: index);
                    },
                    comment: cubit.commentC,
                    onPressedSendComments: () {
                      cubit.addComments(context,
                          postId: cubit.userPosts[index].sId.toString(),
                          comment: cubit.commentC
                      );
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
                                postId: cubit.userPosts[index].sId.toString()),
                          ));
                    },
                    onTapComments: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: cubit.userPosts[index].sId.toString()),
                          ));
                    },
                    statusComment: cubit.commentStatus,
                    state: state,
                  );
                },
              ),
              // Recommended Friends
              state is PostLoaded ?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  horizontalSpace(15),
                  Text("People", style: Theme.of(context).textTheme.titleMedium,)
                ],
              ): const Center(
              ),
              verticalSpace(10),
              state is PostLoaded ?  SizedBox(
                height: 200.h,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Theme.of(context).dividerColor)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child:Container(
                              width: 150.w,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  child: CachedNetworkImage( imageUrl: 'https://picsum.photos/200',fit: BoxFit.fill,)),
                            ) ),

                            verticalSpace(30),
                            Row(
                              children: [
                                horizontalSpace(10),
                                Text("Ali Habib", style: Theme.of(context).textTheme.labelLarge,)
                              ],
                            ),
                            verticalSpace(10),

                            Row(
                              children: [
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                                    height: 25.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: AppColor.blue,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                      child: Text("Follow", style: Theme.of(context).textTheme.labelLarge),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ) : const Center(
                child: CircularProgressIndicator(),
              ),
              // Recommended Posts
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.recommendedPosts.length,
                itemBuilder: (context, index) {
                  return RecommendedPostsItem(
                    cubit: cubit,
                    index: index,
                    post: cubit.recommendedPosts[index],
                    onPressed: () {
                      cubit.addLike(context,
                        postId: cubit.recommendedPosts[index].sId.toString(), index: index,);
                    },
                    comment: cubit.commentC,
                    onPressedSendComments: () {
                      cubit.addComments(context,
                          postId: cubit.recommendedPosts[index].sId.toString(),
                          comment: cubit.commentC
                      );
                    },
                    onPressedSharePosts: () {
                      cubit.sharePost(context,
                          postId: cubit.recommendedPosts[index].sId.toString());
                    },
                    onTapLikes: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoLikeScreen(
                                postId: cubit.recommendedPosts[index].sId.toString()),
                          ));
                    },
                    onTapComments: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: cubit.recommendedPosts[index].sId.toString()),
                          ));
                    },
                    statusComment: cubit.commentStatus,
                    state: state,
                  );
                },
              ),
            ],
          ),
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