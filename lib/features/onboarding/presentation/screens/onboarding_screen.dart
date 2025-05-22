import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';


class OnboardingScreen extends StatefulWidget {
 const OnboardingScreen({super.key});


 @override
 State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
 final controller = PageController();
 bool isLastPage = false;


 @override
 void dispose() {
   controller.dispose();
   super.dispose();
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: 24.w),
       child: Column(
         children: [
           SizedBox(height: 60.h),
           Expanded(
             child: PageView(
               controller: controller,
               onPageChanged: (index) => setState(() => isLastPage = index == 2),
               children:  [
                 OnboardPage(title: 'welcome'.tr(), description: 'This is onboarding 1'),
                 OnboardPage(title: 'Explore', description: 'This is onboarding 2'),
                 OnboardPage(title: 'Start', description: 'This is onboarding 3'),
               ],
             ),
           ),
   
           SizedBox(height: 20.h),
           SizedBox(
             child: InkWell(
               onTap:  () {
                 if (isLastPage) {
                   context.pushNamedAndRemoveUntil(
                     Routes.signupScreen,
                     arguments: ModalRoute.withName('/'),
                   );                 } else {
                   controller.nextPage(
                     duration: const Duration(milliseconds: 500),
                     curve: Curves.easeInOut,
                   );
                 }
               },
               child: Container(
                 width: 80.w,
                 height: 30.h,
                 decoration: BoxDecoration(
                   color: AppColor.blue,
                   borderRadius: BorderRadius.circular(20.r)
                 ),
                 child: Center(
                   child: Text(isLastPage ? 'Get Started' : 'Next', style: Theme.of(context).textTheme.titleSmall!.copyWith(
                     color: Colors.white
                   )),
                 ),
               ),
             )
           ),
           SizedBox(height: 40.h),
         ],
       ),
     ),
   );
 }
}


class OnboardPage extends StatelessWidget {
 final String title;
 final String description;
 const OnboardPage({super.key, required this.title, required this.description});


 @override
 Widget build(BuildContext context) {
   return Padding(
     padding: EdgeInsets.symmetric(horizontal: 24.w),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Image.asset("assets/images/415389181_11624552.jpg", width: 300.r, height: 200.r,),
         SizedBox(height: 20.h),
         Text(
           title,
           // style: GoogleFonts.nunito(
           //   fontSize: 26.sp,
           //   fontWeight: FontWeight.bold,
           // ),
         ),
         SizedBox(height: 12.h),
         Text(
           description,
           textAlign: TextAlign.center,
           // style: GoogleFonts.nunito(fontSize: 16.sp),
         ),
       ],
     ),
   );
 }
}


