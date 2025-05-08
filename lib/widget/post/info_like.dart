import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nuvia/core/extensions/sizedbox_extensions.dart';

import '../../features/info_like/cubit/info_like_cubit.dart';

class InfoLike extends StatelessWidget {
  final InfoLikeCubit cubit;
  final String postId;

  const InfoLike({super.key, required this.cubit, required this.postId});

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
                      "All Like:",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    horizontalSpace(10),
                    Text(
                      "${cubit.likes!.totalLikes}",
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
                itemCount: cubit.likes?.likes?.length ?? 0,
                itemBuilder: (context, index) {
                  final like = cubit.likes!.likes![index];
                  final imageUrl = like.image;

                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      child: (imageUrl != null && imageUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Icon(
                              Icons.person), // أيقونة بديلة عند عدم وجود صورة
                    ),
                    title: Text("${like.firstname} ${like.lastname}"),
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
