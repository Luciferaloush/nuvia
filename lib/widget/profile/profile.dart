import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/theme_extensions.dart';

import '../../core/extensions/sizedbox_extensions.dart';

class Profile extends StatelessWidget {
  final String image;
  final String firstname;
  final String lastname;
  final String gender;
  final IconData icon;
  final List<String>? itemCount;
  final String? item;

  const Profile(
      {super.key,
      required this.image,
      required this.firstname,
      required this.lastname,
      required this.gender,
      required this.icon,
      required this.itemCount,
      required this.item});

  @override
  Widget build(BuildContext context) {
    //final iconTheme = context.iconTheme;
    final textTheme = context.textTheme;

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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                      image,
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
                        borderRadius: BorderRadius.circular(25.dg),
                        border: Border.all(color: Theme.of(context).dividerColor)),
                    child: Center(
                        child: Text(
                      "edit_profile".tr(),
                      style: textTheme.bodySmall,
                    ))),
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            "$firstname\t $lastname  ",
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          verticalSpace(10),
          const Text(
            "مطور Flutter | مهتم بالذكاء الاصطناعي | أعشق البرمجة والتكنولوجيا",
          ),
          verticalSpace(16),
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).iconTheme.color,
                size: 15.h,
              ),
              horizontalSpace(4),
              Text(gender,style: textTheme.labelLarge,)
            ],
          ),
          verticalSpace(5),
          Row(
            children: [
              Text("1,234 متابع",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold)),
              horizontalSpace(20),
              Text("567 متابع",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  )),
              const Spacer(),
            ],
          ),
          verticalSpace(10),
          Text("interested".tr(), style: textTheme.titleMedium),
          verticalSpace(10),
          SizedBox(
            height: 30.h,
            child: ListView.builder(
              itemCount: itemCount!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                List<String> interests = itemCount!;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.r),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Center(
                      child: Text(
                        interests[index],
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
