import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nuvia/core/extensions/sizedbox_extensions.dart';

import '../../features/post/cubit/post_cubit.dart';
import '../../modle/auth/user.dart';
import '../../modle/post/post.dart';
import '../custom_text_field.dart';

class MyPostItem extends StatelessWidget {
  final Posts post;
  final User user;
  final void Function()? onPressed;
  final void Function()? onPressedSendComments;
  final void Function()? onPressedSharePosts;
  final void Function()? onTapLikes;
  final void Function()? onTapComments;
  final int index;

  final TextEditingController comment;
  const MyPostItem(
      {super.key,
      required this.post,
      required this.onPressed,
      required this.onPressedSendComments,
      required this.onPressedSharePosts,
      required this.onTapLikes,
      required this.onTapComments,
      required this.index,
      required this.user, required this.comment});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(post.createdAt.toString());
    final postCubit = BlocProvider.of<PostCubit>(context);

    return BlocProvider(
  create: (context) => PostCubit(),
  child: Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage:
                    const NetworkImage("https://picsum.photos/200"),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstname}\t${user.lastname}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd – kk:mm').format(createdAt),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text("${post.content}"),
          SizedBox(height: 12.h),
          if (post.image != null && post.image!.isNotEmpty) ...[
            if (post.image!.length > 1) ...[
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.h,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: post.image!.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: post.image!.first,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ], // Divider(),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // likes
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                          (post.likePost == true)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: (post.likePost == true)
                              ? Colors.red
                              : Theme.of(context).iconTheme.color
                      ),
                      onPressed: (){
                        postCubit.addLike(context, postId: post.sId.toString(), index: index);

                      }),
                  //Text(( post.likeStatus == true || statusLike == true)? post.likes?.length++1.toString() ?? "0" : post.likes?.length.toString() ?? "0"),
                  Text(
                    (post.likeStatus == true)
                        ? (post.likes?.length ?? 0 + 1).toString()
                        : (post.likes?.length ?? 0).toString(),
                  ),
                  horizontalSpace(10),
                  InkWell(
                      onTap: onTapLikes,
                      child: Text(
                        "Likes",
                        style: Theme.of(context).textTheme.labelLarge,
                      ))
                ],
              ),
              // comments
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: onPressedSendComments),
                  //post.comments.length
//                  statusComment == true
                  Text(post.comments?.length.toString() ?? "0"),
                  horizontalSpace(10),
                  InkWell(
                      onTap: onTapComments,
                      child: Text(
                        "Comments",
                        style: Theme.of(context).textTheme.labelLarge,
                      ))
                ],
              ),
              // المشاركات
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: (){
                        postCubit.sharePost(context, postId: post.sId.toString());

                      }),
                  //post.shares.length
                  Text(post.sharedPosts?.length.toString() ?? "0"),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                controller: postCubit.comment,
                radius: 15,
                border: Border.all(color: Theme.of(context).focusColor),
                hint: "type comments...",
                hinColor: Theme.of(context).hintColor,
                margin: EdgeInsets.all(5.h),
                validator: () {},
              )),
              horizontalSpace(10),
              GestureDetector(
                onTap: (){
                  postCubit.addComments(context, postId: post.sId.toString());
                },
                child: CircleAvatar(
                    backgroundColor: Theme.of(context).cardColor,
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).iconTheme.color,
                    )),
              )
            ],
          ),
        ],
      ),
    ),
);
  }
}
