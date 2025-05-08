import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/sizedbox_extensions.dart';

import '../../modle/auth/user.dart';
import '../../modle/post/share.dart';
import '../custom_text_field.dart';

class MySharedPosts extends StatelessWidget {
  final User user;
  final SharedPosts sharedPosts;
  final TextEditingController comment;
  final void Function()? onPressedSendComments;

  const MySharedPosts(
      {super.key,
      required this.user,
      required this.sharedPosts,
      required this.comment,
      required this.onPressedSendComments});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(sharedPosts.crcreatedAt.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: const NetworkImage("https://picsum.photos/200"),
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
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        verticalSpace(10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 1,
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
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
                              "${sharedPosts.creator!.firstname}\t${sharedPosts.creator!.lastname}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(createdAt),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text("${sharedPosts.content}"),
                    SizedBox(height: 12.h),
                    if (sharedPosts.image != null &&
                        sharedPosts.image!.isNotEmpty) ...[
                      if (sharedPosts.image!.length > 1) ...[
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 400.h,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                          ),
                          items: sharedPosts.image!.map((imageUrl) {
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
                                      placeholder: (context, url) =>
                                          const Center(
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
                            imageUrl: sharedPosts.image!.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                            IconButton(icon: const Icon(
                                // (sharedPosts.likeStatus == true)
                                //     ? Icons.favorite
                                //     : Icons.favorite_border,
                                // color: (post.likeStatus == true) ? Colors.red : null,
                                Icons.favorite), onPressed: () {}),
                            // Text(
                            //   (post.likeStatus == true)
                            //       ? (post.likes?.length ?? 0 + 1).toString()
                            //       : (post.likes?.length ?? 0).toString(),
                            // ),
                          ],
                        ),
                        // comments
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                //   _showCommentsDialog(context, post);
                              },
                            ),
                            //post.comments.length
                            //                  statusComment == true
                            //                       Text(statusComment
                            //                           ? (post.comments!.length + 1).toString()
                            //                           : (post.comments?.length.toString() ?? "0")),
                          ],
                        ),
                        // المشاركات
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {}),
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
                          border:
                              Border.all(color: Theme.of(context).focusColor),
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
              ),
            ),
          ),
        )
      ],
    );
  }
}
