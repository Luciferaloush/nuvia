import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widget/button.dart';
import 'cubit/register_cubit.dart';

class CompleteRegisterScreen extends StatelessWidget {
  final String firstname, lastname, email, password;
  final int gender;

  const CompleteRegisterScreen({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Complete Screen $firstname $lastname $email $password $gender");
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) =>
            RegisterCubit()..user(firstname, lastname, email, password, gender),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is RegisterLoading) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  });
            }

            if (state is RegisterSuccess) {
              context.pushNamedAndRemoveUntil("/topicsScreen");
              if (kDebugMode) {
                print("SUCCESS");
              }
            }
          },
          builder: (context, state) {
            final cubit = RegisterCubit.get(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is PickImagesLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: LinearProgressIndicator(),
                    ),
                  if (cubit.imageUrl != null && cubit.imageUrl.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(cubit.imageUrl.toString()),
                      radius: 55.r,
                    )
                  else
                    InkWell(
                      onTap: () {
                        cubit.selectImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColor.blue,
                        radius: 50.r,
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text("select_photo".tr(),
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    height: 40.h,
                  ),
                  ButtonAuth(
                    title: 'signup'.tr(),
                    onTap: () {
                      cubit.register(context);
                    },
                    width: 150.w,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
