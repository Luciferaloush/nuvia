import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';
import 'package:nuvia/core/extensions/theme_extensions.dart';

import '../../core/helper/cache_helper.dart';
import '../post/screen/post_for_you_screen.dart';
import '../post/screen/screen.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(CacheHelper.getData(key: "token"));
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showTweetDialog(
              context,
              context.read<HomeCubit>().post,
              () {
                context.read<HomeCubit>().addPost(context);
              },
              () {
                context.read<HomeCubit>().selectImages();
              },
              context.read<HomeCubit>().images,
            );
          },
          backgroundColor: Colors.blue,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28.0,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Nuvia", style: context.textTheme.titleMedium),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              context.pushNamed("/profileScreen");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.orange,
                child: Text("P"),
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.pushNamed("/settingScreen");
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.settings),
              ),
            )
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: Colors.blue,
            labelColor: Theme.of(context).tabBarTheme.labelColor,
            unselectedLabelColor:
                Theme.of(context).tabBarTheme.unselectedLabelColor,
            onTap: (index) => context.read<HomeCubit>().changeTab(index),
            tabs: const [

              Tab(text: 'Following'),
              Tab(
                text: 'For You',
              ),
            ],
          ),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return const TabBarView(
              children: [
                AllPostScreen(),
                PostForYouScreen()
                //Text("For you"),
                //Text("Following")
              ],
            );
          },
        ),
      ),
    );
  }

  void _showTweetDialog(
    BuildContext context,
    TextEditingController postController,
    void Function()? onTap,
    void Function()? onTapSelect,
    List<File> images,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      builder: (context) {
        return BlocProvider.value(
          value: HomeCubit(),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Post',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    //ignore: prefer_const_constructors
                    if (images.isNotEmpty)
                      SizedBox(
                        height: 120.h,
                        child: ListView.builder(
                          itemCount: images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    images[index],
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () {
                                        // context.read<HomeCubit>().removeImage(index);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: onTapSelect,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Icon(Icons.image,
                                      color: Theme.of(context).indicatorColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: StatefulBuilder(
                          builder: (context, setInnerState) {
                            return TextField(
                              controller: postController,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "What's happening?\nadd some hashtag like: #sport #technolgy",
                                  hintStyle:
                                      Theme.of(context).textTheme.titleMedium),
                              style: TextStyle(
                                fontSize: 18,
                                color: postController.text.isNotEmpty &&
                                        postController.text.startsWith("#")
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                              onChanged: (value) {
                                setInnerState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
