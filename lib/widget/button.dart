import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

class ButtonAuth extends StatelessWidget {
  final void Function()? onTap;
  final double? width;
  final String title;
  const ButtonAuth({super.key, this.onTap, this.width, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:  onTap,
      child: Container(
        width: width,
        height: 30.h,
        decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(20.r)
        ),
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.white
          )),
        ),
      ),
    );
  }
}
