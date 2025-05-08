import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class CoverImage extends StatelessWidget {
  final String image;
  const CoverImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppColor.blue,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image)
        )
      ),
    );
  }
}
