import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/cache_helper.dart';
import '../../../widget/profile/profile.dart';
import '../../post/cubit/post_cubit.dart';
import '../../post/screen/my_shared_posts.dart';
import '../../replies/cubit/replies_cubit.dart';
import '../../replies/screen.dart';
import 'cubit/profile_cubit.dart';

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
          create: (context) => ProfileCubit()..profile(context),
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
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
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
                            _buildTweetsTab(),
                            const MyRepliesScreen(),
                            MySharedPostsScreen(user: cubit.user),
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
              child: Text("Error reload page"),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      "https://picsum.photos/200",
                    ),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                    height: 30.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: Theme.of(context).dividerColor)),
                    child: const Center(
                        child: Text(
                      "Edit Profile",
                    ))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "علي حبيب",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "@AliHabib",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // الوصف
          const Text(
            "مطور Flutter | مهتم بالذكاء الاصطناعي | أعشق البرمجة والتكنولوجيا",
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Text("1,234 متابع",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
              Text("567 متابع", style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTweetsTab() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              //backgroundImage: CachedNetworkImageProvider("https://picsum.photos/200"),
              backgroundColor: Colors.blue,
            ),
            title: const Text("تغريدة مثيرة للاهتمام"),
            subtitle: const Text("هذه تجربة محاكاة لبروفايل Twitter"),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget _buildRepliesTab() {
    return const Center(child: Text("الردود ستظهر هنا"));
  }

  Widget _buildMediaTab() {
    return const Center(child: Text("الصور والفيديوهات ستظهر هنا"));
  }
}
