import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final Function validator;
  final TextInputType? textInputType;
  final Border? border;
  final EdgeInsets? margin;
  final TextDirection? direction;
  final Function? onChangedCountryCode;
  final bool? showPass;
  final Color? hinColor;
  final Function? onShowPass;
  final Function? onChanged;
  final String? title;
  final Widget? suffixIcon;
  final double? radius;
  const CustomTextField({
    Key? key,
    this.radius,
    this.hint,
    this.hinColor,
    required this.controller,
    required this.validator,
    this.textInputType,
    this.border,
    this.margin,
    this.onChangedCountryCode,
    this.showPass,
    this.onShowPass,
    this.direction,
    this.onChanged,
    this.title,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: direction ?? Directionality.of(context),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        margin: margin ?? const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            if (title != null)
              Row(
                mainAxisAlignment: (direction == TextDirection.ltr)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                        color: AppColor.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: border == null ? null : BorderRadius.circular(radius == null ? 4: radius!.toDouble()),
                border: border ?? null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      validator: (value) {
                        return validator(value);
                      },
                      onChanged: (text) {
                        if (onChanged != null) {
                          onChanged!(text);
                        }
                      },
                      style: Theme.of(context).textTheme.labelLarge,
                      keyboardType: textInputType ?? TextInputType.text,
                      obscureText: !(showPass ?? true),
                      decoration: InputDecoration(
                        suffixIcon: suffixIcon,
                        hintText: hint,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Theme.of(context).colorScheme.tertiary), borderRadius: BorderRadius.circular(20.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        filled: false,
                        hintStyle: TextStyle(
                          color: hinColor ?? Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  if (textInputType == TextInputType.visiblePassword)
                    IconButton(
                      onPressed: () {
                        if (onShowPass != null) {
                          onShowPass!(!showPass!);
                        }
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        color: (!(showPass ?? true))
                            ? Colors.black
                            : Colors.grey[300]!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
