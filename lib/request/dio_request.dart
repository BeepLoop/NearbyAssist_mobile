import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/model/settings_model.dart';
import 'package:nearby_assist/request/auth_interceptor.dart';

class DioRequest {
  BaseOptions options = BaseOptions(
    baseUrl: getIt.get<SettingsModel>().getServerAddr(),
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  DioRequest._privateConstructor();
  static final DioRequest _instance = DioRequest._privateConstructor();
  final _dio = Dio();
  final CancelToken _cancelToken = CancelToken();

  factory DioRequest() {
    _instance._dio.options = _instance.options;
    _instance._dio.interceptors.add(AuthInterceptor());

    return _instance;
  }

  Future<Response> get(
    String url, {
    int expectedStatus = HttpStatus.ok,
    bool requireAuth = true,
  }) async {
    _dio.options.headers["requireAuth"] = requireAuth;

    try {
      final response = await _dio.get(
        url,
        cancelToken: _cancelToken,
        onReceiveProgress: (int receive, int total) {
          if (kDebugMode) {
            print('receive: $receive, total: $total');
          }
        },
      );

      if (response.statusCode != expectedStatus) {
        throw Exception(response.data);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('get request errored: $e');
      }
      rethrow;
    }
  }

  Future<Response> post(
    String url,
    Object data, {
    int expectedStatus = HttpStatus.ok,
    bool requireAuth = true,
  }) async {
    _dio.options.headers["requireAuth"] = requireAuth;

    try {
      final response = await _dio.post(
        url,
        data: data,
        cancelToken: _cancelToken,
        onSendProgress: (int sent, int total) {
          if (kDebugMode) {
            print('sent: $sent, total: $total');
          }
        },
        onReceiveProgress: (int receive, int total) {
          if (kDebugMode) {
            print('receive: $receive, total: $total');
          }
        },
      );

      if (response.statusCode != expectedStatus) {
        throw Exception(response.data);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('post request errored: $e');
      }
      rethrow;
    }
  }

  Future<Response> multipart(
    String url,
    FormData data,
    Function(int, int)? onSendProgress, {
    int expectedStatus = HttpStatus.ok,
    bool requireAuth = true,
  }) async {
    _dio.options.headers["requireAuth"] = requireAuth;

    try {
      final response = await _dio.post(
        url,
        data: data,
        cancelToken: _cancelToken,
        onSendProgress: onSendProgress,
      );

      if (response.statusCode != expectedStatus) {
        throw Exception(response.data);
      }

      return response;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('== error: ${e.response?.data}');
        print('== message: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('== error on multipart: ${e.toString()}');
      }
      rethrow;
    }
  }

  Future<Response> request(
    String url, {
    int expectedStatus = HttpStatus.ok,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool requireAuth = true,
  }) async {
    _dio.options.headers["requireAuth"] = requireAuth;

    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        cancelToken: _cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode != expectedStatus) {
        throw Exception(response.data);
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  void cancel(String? reason) {
    _cancelToken.cancel(reason);
  }
}
