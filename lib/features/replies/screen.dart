import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widget/custom_replies/custom_replies.dart';
import 'cubit/replies_cubit.dart';

class MyRepliesScreen extends StatelessWidget {
  const MyRepliesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepliesCubit, RepliesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = RepliesCubit.get(context);

        if (state is RepliesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RepliesLoaded) {
          return ListView.builder(
            itemCount: cubit.myReply.comments?.length ?? 0,
            itemBuilder: (context, index) {
              final comment = cubit.myReply.comments![index];
              return CustomReplies(
                replies: comment.replies!,
                comments: comment,
                postOwner: comment.postOwner!,
              );
            },
          );
        } else {
          return  Center(child: Text("error_loading_please_try_again".tr()));
        }
      },
    );
  }
}
