import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/endpoint_constants.dart';
import '../../../../core/cubit/locale/locale_cubit.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/helper/dio_helper.dart';
import '../../../../core/network/status_code.dart';
import '../../../../widget/gender_selector.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);
  final formKeyRegister = GlobalKey<FormState>();

  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final cloudinary = CloudinaryPublic('dfoitqico', 'hk2d1zrm');
  final imagePicker = ImagePicker();

  var imageUrl;

  int? gender;
  bool showPass = false;

  Future<XFile?> pickImages() async {
    try {
      var image = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      return image;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void selectImage() async {
    emit(PickImagesLoading());
    var image = await pickImages();
    if (image != null) {
      print("Image selected: ${image.path}");
      var uploadedUrl = await uploadImageToCloudinary(image);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
        print("Image uploaded successfully: $imageUrl");
        emit(PickImages(images: imageUrl!));
      } else {
        emit(RegisterError(error: "Failed to upload image"));
      }
    } else {
      print("No image selected");
    }
  }

  Future<String?> uploadImageToCloudinary(XFile image) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      print("Image uploaded successfully: ${response.secureUrl}");
      return response.secureUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }

  void user(String firstname, String lastname, String email, String password,
      int gender) {
    this.firstname.text = firstname;
    this.lastname.text = lastname;
    this.email.text = email;
    this.password.text = password;
    this.gender = gender;
  }

  Future<void> register(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;

    print(languageCode);
    emit(RegisterLoading());
    DioHelper.postData(
        url: "${EndpointConstants.register}$languageCode",
        data: {
          "image": imageUrl.toString(),
          "firstname": firstname.text.trim(),
          "lastname": lastname.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
          "gender": gender.toString()
        }).then((value) {
      print("Registering with data: ${{
        "image": imageUrl.toString(),
        "firstname": firstname.text.trim(),
        "lastname": lastname.text.trim(),
        "email": email.text.trim(),
        "password": password.text.trim(),
        "gender": gender.toString()
      }}");
      if (value == null) {
        emit(RegisterError(error: "value is null"));
        return;
      }
      if (kDebugMode) {
        print(value.statusCode);
      }
      if (value.statusCode != StatusCode.ok) {
        if (kDebugMode) {
          print(value.data.runtimeType);
          print(value.data);
          print(value.statusCode);
        }

        emit(RegisterError(error: value.data.toString()));
        return;
      }
      if (value.statusCode == StatusCode.ok) {
        if (kDebugMode) {
          print(value.data);
        }
        CacheHelper.saveData(key: "token", value: value.data['token']);
        CacheHelper.saveData(key: "userId", value: value.data['_id']);
        emit(RegisterSuccess());
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(RegisterError(error: error.toString()));
    }).catchError((error, stacktrace) {
      print("Error occurred: ${error.toString()}");
      print("Stacktrace: $stacktrace");
      emit(RegisterError(error: error.toString()));
    });
  }

  onShowPass(bool val) {
    showPass = !showPass;
    emit(RegisterUpdate());
  }

  onChangeGender(GenderType gender) {
    if (gender == GenderType.male) {
      this.gender = 0;
    } else {
      this.gender = 1;
    }
  }
}
