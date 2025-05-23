import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extensions/sizedbox_extensions.dart';
import '../core/theme/app_colors.dart';
import '../features/users/cubit/users_cubit.dart';
import '../features/users/users_profile.dart';

class CustomUsers extends StatelessWidget {
  final String profile;
  final TextEditingController controller;
  final UsersCubit cubit;

  const CustomUsers(
      {super.key,
      required this.profile,
      required this.controller,
      required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              verticalSpace(40),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   child: TextField(
              //     decoration: InputDecoration(
              //       hintText: 'بحث عن مستخدم...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide:
              //             BorderSide(color: Theme.of(context).dividerColor),
              //       ),
              //       suffixIcon: const Icon(Icons.search),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Followers",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Icon(
                      Icons.search_outlined,
                      color: Theme.of(context).iconTheme.color,
                      size: 20.h,
                    ),
                  ],
                ),
              ),
              verticalSpace(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 30.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).cardColor),
                      child: Center(
                        child: Text(
                          "Your Followers",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              verticalSpace(10),

              Divider(
                color: Theme.of(context).dividerColor,
              ),
              verticalSpace(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      "People you may know",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.users.length,
                itemBuilder: (context, index) {
                  final users = cubit.users[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text("${users.firstname}\t${users.lastname}"),
                          leading: const Icon(Icons.person),
                          trailing: SizedBox(
                            width: 60.w,
                            height: 35.h,
                            child: InkWell(
                              onTap: () {
                                if (cubit.userFollow[index]) {
                                  cubit.unfollow(context,
                                      userId: users.id.toString(),
                                      index: index);
                                } else {
                                  cubit.follow(context,
                                      userId: users.id.toString(),
                                      index: index);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context).cardColor),
                                ),
                                child: Center(
                                  child:
                  cubit.userFollow[index]?
                  Text(
                                      cubit.userFollow[index]
                                      ? "Following"
                                      : "Follow",
                                  ) : Text(cubit.users[index].followingStatusFo.toString())
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersProfileScreen(
                                    userId: users.id.toString()),
                              ));
                        },
                        child: Container(
                          height: 30.h,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.blue),
                          child: Center(
                            child: Text(
                              profile,
                              style: const TextStyle(color: Color(0xffFFFFFF)),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(5),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      )
                    ],
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
