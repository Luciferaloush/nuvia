import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';
import 'package:nuvia/core/extensions/theme_extensions.dart';

import '../../core/helper/cache_helper.dart';
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
    print(CacheHelper.getData(key: "token"));
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
              Tab(
                text: 'For you',
              ),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return TabBarView(
              children: [
                const AllPostScreen(),
                _buildFollowingTab(context, state),
                //Text("For you"),
                //Text("Following")
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildForYouTab(BuildContext context, HomeState state) {
    return const Center(child: Text("For You Content"));
  }

  Widget _buildFollowingTab(BuildContext context, HomeState state) {
    return const Center(child: Text("Following Content"));
  }

//   void _showTweetDialog(
//       BuildContext context,
//       TextEditingController postController,
//       void Function()? onTap,
//       List<String> selectedTopics) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return BlocProvider.value(
//           value:TopicCubit()..getTopic(context),
//   child: Container(
//           height: MediaQuery.of(context).size.height * 0.8,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     ElevatedButton(
//                       onPressed: onTap,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: const Text(
//                         'Post',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               //ignore: prefer_const_constructors
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: onTap,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         height: 30.h,
//                         width: 40.w,
//                         decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(10)),
//                         child: const Center(
//                           child: Icon(Icons.image),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               BlocConsumer<TopicCubit, TopicState>(
//                 listener: (context, state) {},
//                 builder: (context, state) {
//                   final cubit = TopicCubit.get(context);
//                   if (state is TopicLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is TopicError) {
//                     return Center(child: Text(state.error));
//                   } else if (state is TopicLoaded) {
//                     final topics = cubit.topics.topics;
//                     return Row(
//                       children: [
//                         if (selectedTopics.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'Selected: ${selectedTopics.length}/5',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         Expanded(
//                           child:  SizedBox(
//                             height: 100.h,
//                             child: ListView.builder(scrollDirection: Axis.vertical,
//                               itemCount: topics!.length,
//                               itemBuilder: (context, index) {
//                                 final topic = topics[index];
//                                 final isSelected = selectedTopics.contains(topic);
//                                 return CheckboxListTile(
//                                   title: Text(
//                                     topic,
//                                     textDirection: TextDirection.rtl,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal,
//                                     ),
//                                   ),
//                                   value: isSelected,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (selectedTopics.length < 5) {
//                                           selectedTopics.add(topic);
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                   'You can select up to 5 topics only'),
//                                             ),
//                                           );
//                                         }
//                                       } else {
//                                         selectedTopics.remove(topic);
//                                       }
//                                     });
//                                   },
//                                   secondary: isSelected
//                                       ? const Icon(Icons.check_circle,
//                                       color: Colors.green)
//                                       : const Icon(Icons.radio_button_unchecked),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   return const Center(child: CircularProgressIndicator());
//                 },
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: postController,
//                     maxLines: null,
//                     expands: true,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "What's happening?",
//                     ),
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
// );
//       },
//     );
//   }
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

  Widget _buildPostsList(BuildContext context) {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        return _buildPostItem(context);
      },
    );
  }

  Widget _buildPostItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس المنشور (المستخدم وصورة البروفايل)
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
                    "post.userName",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    'post.time.hour:post.time.minute',
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
          // محتوى المنشور
          const Text("post.content"),
          SizedBox(height: 12.h),
          Container(
            width: MediaQuery.of(context).size.height,
            height: 400.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.fill),
            ),
          ),
          // صورة المنشور (إذا وجدت)
          // يمكنك إضافة صورة هنا إذا كان المنشور يحتوي على صورة
          // Divider(),
          SizedBox(height: 12.h),
          // تفاعلات المنشور (إعجابات، تعليقات، مشاركات)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // الإعجابات
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                        // post.likes.contains('currentUserId') // استبدل بمعرف المستخدم الحالي
                        //     ? Icons.favorite
                        //     : Icons.favorite_border,
                        Icons.favorite_border
                        // color: post.likes.contains('currentUserId')
                        //     ? Colors.red
                        //     : null,

                        ),
                    onPressed: () {
                      //context.read<HomeCubit>().toggleLike(post.id);
                    },
                  ),
                  //post.likes.length
                  const Text('10'),
                ],
              ),
              // التعليقات
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      //   _showCommentsDialog(context, post);
                    },
                  ),
                  //post.comments.length
                  const Text('12'),
                ],
              ),
              // المشاركات
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // context.read<HomeCubit>().sharePost(post.id);
                    },
                  ),
                  //post.shares.length
                  const Text('4'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
