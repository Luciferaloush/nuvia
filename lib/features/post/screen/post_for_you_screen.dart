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

class PostForYouScreen extends StatelessWidget {
  const PostForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        final cubit = PostCubit.get(context);
        if (state is PostForYouLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostForYouError) {
          return Center(child: Text(state.error));
        }
        else if(state is PostForYouLoaded){
          return SingleChildScrollView(
            child: Column(
              children: [
                // Following Users Posts
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.excellentPosts.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      cubit: cubit,
                      index: index,
                      post: cubit.excellentPosts[index],
                      onPressed: () {
                        cubit.addLike(context,
                            postId: cubit.excellentPosts[index].sId.toString(), index: index);
                      },
                      comment: cubit.commentC,
                      onPressedSendComments: () {
                        cubit.addComments(context,
                            postId: cubit.excellentPosts[index].sId.toString(),
                            comment: cubit.commentC
                        );
                      },
                      onPressedSharePosts: () {
                        cubit.sharePost(context,
                            postId: cubit.excellentPosts[index].sId.toString());
                      },
                      onTapLikes: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoLikeScreen(
                                  postId: cubit.excellentPosts[index].sId.toString()),
                            ));
                      },
                      onTapComments: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                  postId: cubit.excellentPosts[index].sId.toString()),
                            ));
                      },
                      statusComment: cubit.commentStatus,
                      state: state,
                    );
                  },
                ),
                // Recommended Friends
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    horizontalSpace(15),
                    Text("People", style: Theme.of(context).textTheme.titleMedium,)
                  ],
                ),
                verticalSpace(10),
                SizedBox(
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
                ),
                // Recommended Posts
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.topPosts.length,
                  itemBuilder: (context, index) {
                    return RecommendedPostsItem(
                      cubit: cubit,
                      index: index,
                      post: cubit.topPosts[index],
                      onPressed: () {
                        cubit.addLike(context,
                          postId: cubit.topPosts[index].sId.toString(), index: index,);
                      },
                      comment: cubit.commentC,
                      onPressedSendComments: () {
                        cubit.addComments(context,
                            postId: cubit.topPosts[index].sId.toString(),
                            comment: cubit.commentC
                        );
                      },
                      onPressedSharePosts: () {
                        cubit.sharePost(context,
                            postId: cubit.topPosts[index].sId.toString());
                      },
                      onTapLikes: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoLikeScreen(
                                  postId: cubit.topPosts[index].sId.toString()),
                            ));
                      },
                      onTapComments: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                  postId: cubit.topPosts[index].sId.toString()),
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
        }
        else if(state is TPPostLoaded){
          return SingleChildScrollView(
            child: Column(
              children: [
                // Following Users Posts
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.tPPosts.length,
                  itemBuilder: (context, index) {
                    return PostItem(
                      cubit: cubit,
                      index: index,
                      post: cubit.tPPosts[index],
                      onPressed: () {
                        cubit.addLike(context,
                            postId: cubit.tPPosts[index].sId.toString(), index: index);
                      },
                      comment: cubit.commentC,
                      onPressedSendComments: () {
                        cubit.addComments(context,
                            postId: cubit.tPPosts[index].sId.toString(),
                            comment: cubit.commentC
                        );
                      },
                      onPressedSharePosts: () {
                        cubit.sharePost(context,
                            postId: cubit.tPPosts[index].sId.toString());
                      },
                      onTapLikes: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoLikeScreen(
                                  postId: cubit.tPPosts[index].sId.toString()),
                            ));
                      },
                      onTapComments: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                  postId: cubit.tPPosts[index].sId.toString()),
                            ));
                      },
                      statusComment: cubit.commentStatus,
                      state: state,
                    );
                  },
                ),
                // Recommended Friends
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    horizontalSpace(15),
                    Text("People", style: Theme.of(context).textTheme.titleMedium,)
                  ],
                ),
                verticalSpace(10),
                SizedBox(
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
                ),
                // Recommended Posts
              ],
            ),
          );
        }

          return const Center(
            child: CircularProgressIndicator(),
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