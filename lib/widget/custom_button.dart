import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.onPressed});
final String text;
final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
   return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child:  Text(text, style: const TextStyle(color: Colors.white)),
    );  }
}
