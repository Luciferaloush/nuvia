import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/endpoint_constants.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(

        followRedirects: false,
        validateStatus: (status) => true,
        baseUrl: EndpointConstants.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response?> getData({
    required String url,
    required Map<String, dynamic> query,
    Map<String, dynamic>? headers,
  }) async {
    dio?.options.headers = {};
    if (headers != null) {
      dio?.options.headers.addAll(headers);
    }
    return await dio?.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response?> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    dio?.options.headers = {};

    if (headers != null) {
      dio?.options.headers.addAll(headers);
    }

    return await dio?.post(
      url,
      queryParameters: query,
      data: json.encode(data),
    );
  }
}
