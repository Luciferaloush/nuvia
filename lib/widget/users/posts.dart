import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/extensions/sizedbox_extensions.dart';
import '../../features/users/cubit/users_cubit.dart';
import '../../modle/post/post.dart';
import '../custom_text_field.dart';

class UserPosts extends StatelessWidget {
  final Posts post;
  final UsersCubit cubit;
  final void Function()? onPressed;
  final void Function()? onPressedSendComments;
  final void Function()? onPressedSharePosts;
  final void Function()? onTapLikes;
  final void Function()? onTapComments;
  final bool statusComment;
  final TextEditingController comment;
  final Widget icon;
  const UserPosts(
      {super.key,
      required this.post,
      this.onPressed,
      this.onPressedSendComments,
      this.onPressedSharePosts,
      this.onTapLikes,
      this.onTapComments,
      required this.statusComment,
      required this.comment,
      required this.cubit, required this.icon});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(post.createdAt.toString());
    int currentShares = post.sharedPosts?.length ?? 0;

    return Padding(
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
                    "${cubit.user!.firstname}\t ${cubit.user!.lastname}",
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
                  // قم بإيقاف الحركة التلقائية
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
                      icon: icon,
                      onPressed: onPressed),
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
                  Text(statusComment
                      ? (post.comments!.length + 1).toString()
                      : (post.comments?.length.toString() ?? "0")),
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
                      onPressed: onPressedSharePosts),
                  //post.shares.length
                  // Text(
                  //   (state is SharePostSuccess)
                  //       ? (currentShares + 1).toString()
                  //       : currentShares.toString(),
                  // ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                controller: comment,
                radius: 15,
                border: Border.all(color: Theme.of(context).focusColor),
                hint: "type comments...",
                hinColor: Theme.of(context).hintColor,
                margin: EdgeInsets.all(5.h),
                validator: () {},
              )),
              horizontalSpace(10),
              GestureDetector(
                onTap: onPressedSendComments,
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
    );
  }
}
