import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.example.com', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
      ));
    }
  }

  Dio get dio => _dio;
}
