import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jio_ird/src/providers/external_providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.watch(baseUrlProvider),
    headers: {"Content-Type": "application/json"},
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    requestHeader: true,
    responseHeader: false,
    responseBody: true,
    error: true,
  ));

  final Map<String, int> retryCounts = {};

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = ref.read(accessTokenProvider);
        options.headers['Authorization'] = token;
        debugPrint("Headers: ${options.headers}");
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        final requestKey = error.requestOptions.uri.toString();
        retryCounts[requestKey] = (retryCounts[requestKey] ?? 0);

        if (retryCounts[requestKey]! < 5 &&
            (error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.receiveTimeout ||
                error.type == DioExceptionType.sendTimeout ||
                (error.response?.statusCode ?? 500) >= 500)) {
          retryCounts[requestKey] = retryCounts[requestKey]! + 1;
          try {
            final response = await dio.fetch(error.requestOptions);
            return handler.resolve(response);
          } catch (_) {
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
