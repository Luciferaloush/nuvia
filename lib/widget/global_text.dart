import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

class GlobalText extends StatelessWidget {
  const GlobalText({
    super.key,
    this.padding,
    this.fontSize,
    this.fontWeight,
    required this.text,
  });
  final String text;
  final double? fontSize;
  final  FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Text(
        text,


        overflow: TextOverflow.ellipsis,

        style: TextStyle(fontSize: fontSize ?? 13.sp, color: AppColor.blue,fontWeight:fontWeight?? FontWeight.normal),
      ),
    );
  }
}
