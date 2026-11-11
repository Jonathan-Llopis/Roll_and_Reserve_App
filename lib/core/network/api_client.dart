import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roll_and_reserve/core/error/exceptions.dart';
import 'package:roll_and_reserve/core/network/token_provider.dart';

class ApiClient {
  final Dio dio;
  final TokenProvider tokenProvider;
  final String? baseUrl;
  final List<Duration>? retryDelays;
  final int retries;

  ApiClient({
    required this.dio,
    required this.tokenProvider,
    this.baseUrl,
    this.retryDelays,
    this.retries = 3,
  }) {
    _init();
  }

  void _init() {
    dio.options.baseUrl = baseUrl ??
        (dotenv.isInitialized ? dotenv.env['BACKEND'] : null) ??
        'http://localhost:3000';
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.sendTimeout = const Duration(seconds: 15);
    dio.options.headers['Content-Type'] = 'application/json';

    // Auth Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final hasAuth = options.headers.keys.any(
            (k) => k.toLowerCase() == 'authorization',
          );
          if (!hasAuth) {
            final token = await tokenProvider.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );

    // Smart Retry Interceptor
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: retries,
        retryDelays: retryDelays ??
            const [
              Duration(seconds: 1),
              Duration(seconds: 2),
              Duration(seconds: 3),
            ],
      ),
    );
  }

  Dio get client => dio;

  Never handleError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw AuthException(
          error.response?.data is Map
              ? (error.response?.data['message']?.toString() ?? 'Unauthorized')
              : 'Unauthorized',
          statusCode,
        );
      }
      if (statusCode != null && statusCode >= 500) {
        throw ServerException(
          error.response?.data is Map
              ? (error.response?.data['message']?.toString() ?? 'Server Error')
              : 'Server Error',
          statusCode,
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        throw NetworkException(
          error.message ?? 'Network connection failed',
        );
      }
      throw ServerException(
        error.response?.data is Map
            ? (error.response?.data['message']?.toString() ??
                error.message ??
                'Request failed')
            : (error.message ?? 'Request failed'),
        statusCode,
      );
    }
    throw ServerException(error.toString());
  }

  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.get<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      handleError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      handleError(e);
    }
  }
}
