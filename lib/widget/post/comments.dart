import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/extensions/sizedbox_extensions.dart';
import '../../features/comments/cubit/comments_cubit.dart';

class Comments extends StatelessWidget {
  final CommentsCubit cubit;
  final String postId;

  const Comments({super.key, required this.cubit, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "All Comments:",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    horizontalSpace(10),
                    Text(
                      "${cubit.comments.length}",
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.comments.length,
                itemBuilder: (context, index) {

                  return ListTile(
                    leading: const SizedBox(
                      width: 50,
                      child:  Icon(
                          Icons.person),

                    ),
                    title: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
                      margin: EdgeInsets.symmetric( vertical: 3.h),
                      height: 50.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25.r)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ali Habib", style: Theme.of(context).textTheme.labelLarge),
                            Text("${cubit.comments[index].comment}", style: Theme.of(context).textTheme.labelMedium,),
                          ],
                        )),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
