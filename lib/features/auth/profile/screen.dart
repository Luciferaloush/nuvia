import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/cache_helper.dart';
import '../../../widget/profile/my_posts.dart';
import '../../../widget/profile/profile.dart';
import '../../post/cubit/post_cubit.dart';
import '../../post/screen/my_shared_posts.dart';
import '../../replies/cubit/replies_cubit.dart';
import '../../replies/screen.dart';
import 'cubit/profile_cubit.dart';
import 'my_post_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(CacheHelper.getData(key: "token"));
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = ProfileCubit();
            cubit.profile(context);
            cubit.myPosts(context);
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => PostCubit()..mySharedPosts(context),
        ),
        BlocProvider(
          create: (context) => RepliesCubit()..myReplies(),
        ),
      ],
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = ProfileCubit.get(context);
          if (state is ProfileLoading ) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded || state is MyPostsLoaded) {
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 100.h,
                        floating: true,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: CachedNetworkImage(
                            imageUrl: "https://picsum.photos/1200/500",
                            fit: BoxFit.cover,
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      Profile(
                        image: cubit.user.image.toString(),
                        firstname: cubit.user.firstname.toString(),
                        lastname: cubit.user.lastname.toString(),
                        icon: cubit.user.gender.toString() == "0"
                            ? Icons.male
                            : Icons.female,
                        gender: cubit.user.gender.toString() == "0"
                            ? "Male"
                            : "Female",
                        itemCount: cubit.user.selectedTopics,
                        item: cubit.user.selectedTopics.toString(),
                        following: cubit.user.following.toString(),
                        followers: cubit.user.followers.toString(),
                      ),
                      TabBar(
                        tabs: [
                          Tab(text: "my_post".tr()),
                          Tab(text: "replies".tr()),
                          Tab(text: "my_share".tr()),
                        ],
                        indicatorColor: Theme.of(context).dividerColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor:
                            Theme.of(context).unselectedWidgetColor,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            const MyPostScreen(),
                            const MyRepliesScreen(),
                            MySharedPostsScreen(user: cubit.user,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
