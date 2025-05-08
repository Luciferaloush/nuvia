import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../modle/replies/my_comments.dart';
import '../../modle/replies/post_owner.dart';
import '../../modle/replies/replies.dart';

class CustomReplies extends StatelessWidget {
  final MyComments comments;
  final PostOwner postOwner;
  final Replies replies;

  const CustomReplies({
    super.key,
    required this.comments,
    required this.postOwner,
    required this.replies,
  });

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(comments.createdAt.toString());

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
                    "${postOwner.firstname}\t${postOwner.lastname}",
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
          Text("${postOwner.content}"),
          SizedBox(height: 12.h),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text("${replies.firstname}\t${replies.lastname}",
                style: Theme.of(context).textTheme.labelLarge),
            subtitle: Text(replies.comment.toString()),
          ),
        ],
      ),
    );
  }
}
