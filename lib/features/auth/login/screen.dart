import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/global_text.dart';
import '../register/screen.dart';
import 'cubit/login_cubit.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          shadowColor: Colors.transparent,
        ),
        body: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is LoginError) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                  if (state is LoginLoading) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                  }

                  if (state is LoginSuccess) {
                    context.pushNamedAndRemoveUntil("/homeScreen");

                    if (kDebugMode) {
                      print("SUCCESS");
                    }
                  }

                }, builder: (context, state) {
              final cubit = LoginCubit.get(context);
              return Center(
                child: Form(
                    key: cubit.formKeyLogin,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // 16.ph,
                            Image.asset(
                                "assets/images/11667100_20944986.jpg"),
                            Text(
                              "signup".tr(),
                              style: const TextStyle(
                                color: AppColor.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            CustomTextField(
                              controller: cubit.email,
                              textInputType: TextInputType.emailAddress,
                              hint: 'email'.tr(),
                              title: "email".tr(),
                              validator: (val) {

                              },
                            ),
                            CustomTextField(
                              controller: cubit.password,
                              textInputType: TextInputType.emailAddress,
                              hint: 'pass'.tr(),
                              title: "pass".tr(),
                              validator: (val) {

                              },
                            ),
                            //16.ph,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ButtonAuth(
                                title: 'login'.tr(),
                                onTap: () {
                                  if (cubit.formKeyLogin.currentState!
                                      .validate()) {
                                    cubit.login(context);
                                  }
                                },
                                width: double.infinity,
                              ),
                            ),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GlobalText(
                                    text: 'dont_have_account'.tr(),
                                    padding: const EdgeInsets.all(0),
                                    fontSize: 11.sp,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const RegisterScreen()));
                                    },
                                    child: Text(
                                      'signup'.tr(),
                                      style: TextStyle(
                                          color: AppColor.blue,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    )),
              );
            })));
  }
}
