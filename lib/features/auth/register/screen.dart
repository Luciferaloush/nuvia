import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/gender_selector.dart';
import '../../../widget/global_text.dart';
import '../login/screen.dart';
import 'complete_register.dart';
import 'cubit/register_cubit.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          shadowColor: Colors.transparent,
        ),
        body: BlocProvider(
            create: (context) => RegisterCubit(),
            child: BlocConsumer<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterError) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }

                }, builder: (context, state) {
              RegisterCubit cubit = RegisterCubit.get(context);
              return Form(
                  key: cubit.formKeyRegister,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 16.ph,
                          Text(
                            "signup".tr(),
                            style: const TextStyle(
                              color: AppColor.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CustomTextField(
                            controller: cubit.firstname,
                            textInputType: TextInputType.emailAddress,
                            hint: 'first_name'.tr(),
                            title: "first_name".tr(),
                            validator: (val) {
                              // if (val!.isEmpty) {
                              //   if (EmailValidator.validate(val) == false) {
                              //     return 'email_invalid'.tr(context);
                              //   }
                              //   return 'required_field'.tr(context);
                              // } else {
                              //   return null;
                              // }
                            },
                          ),
                          CustomTextField(
                            controller: cubit.lastname,
                            textInputType: TextInputType.emailAddress,
                            hint: 'lastname'.tr(),
                            title: "lastname".tr(),
                            validator: (val) {

                            },
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
                          GenderSelector(
                            title: "gender".tr(),
                            initValue: (cubit.gender == null)
                                ? null
                                : ((cubit.gender == 0)
                                ? GenderType.male
                                : GenderType.female),
                            onChange: (value) {
                              cubit.onChangeGender(value);
                            },
                          ),
                          //16.ph,
                          CustomButton(
                            text: 'next'.tr(),
                            onPressed: () {
                              if (cubit.formKeyRegister.currentState!
                                  .validate()) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context1) =>
                                //             CompleteRegisterScreen(
                                //               cubit: RegisterCubit.get(context),
                                //             )
                                //     )
                                // );
                                print("${cubit.firstname.text}+${cubit.lastname
                                    .text} + ${cubit.email.text} + ${cubit
                                    .password.text} + ${cubit.gender}");
                               if(cubit.formKeyRegister.currentState!.validate()){
                                 Navigator.pushAndRemoveUntil(context,
                                     MaterialPageRoute(builder: (context) =>
                                         CompleteRegisterScreen(
                                           firstname: cubit.firstname.text,
                                             lastname: cubit.lastname.text,
                                           email: cubit.email.text,
                                           password: cubit.password.text,
                                           gender: cubit.gender!.toInt(),
                                         ),), (route) => false);
                               }
                              }
                            },
                          ),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GlobalText(
                                  text: 'have_account'.tr(),
                                  padding: const EdgeInsets.all(0),
                                  fontSize: 11.sp,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const LoginScreen()));
                                  },
                                  child: Text(
                                    'login'.tr(),
                                    style: TextStyle(
                                        color: AppColor.orange,
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
                  ));
            })));
  }
}
