import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/endpoint_constants.dart';
import '../../../core/cubit/locale/locale_cubit.dart';
import '../../../core/helper/cache_helper.dart';
import '../../../core/helper/dio_helper.dart';
import '../../../core/network/status_code.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeTabState(0));

  static HomeCubit get(context) => BlocProvider.of(context);
  final TextEditingController post = TextEditingController();
  final List<String> selectedTopics = [];
  final List<File> images = [];
  final List<String> base64Images = [];
  final List<String> imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  void changeTab(int index) {
    if (state is HomeTabState &&
        (state as HomeTabState).currentTabIndex != index) {
      emit(HomeTabState(index));
    }
  }

  Future<List<File>> pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        images.clear();
        for (var file in pickedFiles) {
          images.add(File(file.path));
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
    return images;
  }

  void selectImages() async {
    var select = await pickImages();
    emit(PickImages(images: select));
  }

  Future<void> addPost(BuildContext context) async {
    final localeCubit = BlocProvider.of<LocaleCubit>(context);
    final languageCode = localeCubit.state.locale.languageCode;
    String inputText = post.text.trim();
    RegExp hashtagRegExp = RegExp(r'#\w+');
    Iterable<Match> matches = hashtagRegExp.allMatches(inputText);
    List<String> hashtags = matches.map((match) => match.group(0)!).toList();
    String content = inputText.replaceAll(hashtagRegExp, '').trim();

    print(languageCode);
    final cloudinary = CloudinaryPublic('dfoitqico', 'hk2d1zrm');
    for (int i = 0; i < images.length; i++) {
      try {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path));
        imageUrls.add(res.secureUrl);
        if (kDebugMode) {
          print('Images: $images');
        }
      } catch (e) {
        print('Error uploading image $i: $e');
      }
    }

    emit(AddPostLoading());

    DioHelper.postData(
        url: "${EndpointConstants.add}$languageCode",
        data: {"content": content, "image": imageUrls, "hashtag": hashtags},
        headers: {"token": CacheHelper.getData(key: "token")}).then((value) {
      if (value == null) {
        emit(AddPostError());
        if (kDebugMode) {
          print("Value is null");
        }
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

        emit(AddPostError());
        return;
      }
      if (value.statusCode == StatusCode.notFound) {
        emit(AddPostError());
        if (kDebugMode) {
          print(value.data);
        }
      }
      if (value.statusCode == StatusCode.ok) {
        post.clear();
        emit(PostAddedSuccessfully());
        if (kDebugMode) {
          print(value.data);
        }
      }
    }).catchError((error, stacktrace) {
      if (kDebugMode) {
        print("error: $error\nstacktrace: $stacktrace,\n");
      }
      emit(AddPostError());
    }).catchError((error, stacktrace) {
      print("Error occurred: ${error.toString()}");
      print("Stacktrace: $stacktrace");
      emit(AddPostError());
    });
  }
}
