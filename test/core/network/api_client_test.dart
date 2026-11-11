import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roll_and_reserve/core/error/exceptions.dart';
import 'package:roll_and_reserve/core/network/api_client.dart';
import 'package:roll_and_reserve/core/network/token_provider.dart';

class MockTokenProvider extends Mock implements TokenProvider {}

class TestHttpAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  TestHttpAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late MockTokenProvider mockTokenProvider;
  late Dio dio;

  setUp(() {
    mockTokenProvider = MockTokenProvider();
    dio = Dio();
  });

  group('ApiClient Initialization & Configuration', () {
    test('configures default timeouts and headers', () {
      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      expect(client.dio.options.baseUrl, equals('https://api.rollandreserve.com'));
      expect(client.dio.options.connectTimeout, equals(const Duration(seconds: 15)));
      expect(client.dio.options.receiveTimeout, equals(const Duration(seconds: 15)));
      expect(client.dio.options.sendTimeout, equals(const Duration(seconds: 15)));
      expect(client.dio.options.headers['Content-Type'], equals('application/json'));
    });
  });

  group('ApiClient AuthInterceptor', () {
    test('automatically injects Bearer token when token is available', () async {
      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => 'valid_jwt_token_123');

      RequestOptions? capturedOptions;

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        capturedOptions = options;
        return ResponseBody.fromString(
          json.encode({'status': 'ok'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      final response = await client.get('/test');

      expect(response.statusCode, equals(200));
      expect(capturedOptions, isNotNull);
      expect(
        capturedOptions!.headers['Authorization'],
        equals('Bearer valid_jwt_token_123'),
      );
    });

    test('does not inject Authorization header when token is null or empty', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      RequestOptions? capturedOptions;

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        capturedOptions = options;
        return ResponseBody.fromString(
          json.encode({'status': 'ok'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      final response = await client.get('/public-endpoint');

      expect(response.statusCode, equals(200));
      expect(capturedOptions, isNotNull);
      expect(capturedOptions!.headers.containsKey('Authorization'), isFalse);
    });

    test('preserves explicitly provided Authorization header', () async {
      when(() => mockTokenProvider.getToken())
          .thenAnswer((_) async => 'auto_token');

      RequestOptions? capturedOptions;

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        capturedOptions = options;
        return ResponseBody.fromString(
          json.encode({'status': 'ok'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      await client.get(
        '/custom-auth',
        options: Options(headers: {'authorization': 'Bearer custom_token'}),
      );

      expect(
        capturedOptions!.headers['authorization'],
        equals('Bearer custom_token'),
      );
    });
  });

  group('ApiClient Retry Policy', () {
    test('retries on 503 Service Unavailable up to 3 times before succeeding', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      int attempts = 0;

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        attempts++;
        if (attempts < 3) {
          return ResponseBody.fromString(
            json.encode({'error': 'Temporarily unavailable'}),
            503,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString(
          json.encode({'success': true}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
        retries: 3,
        retryDelays: const [
          Duration(milliseconds: 10),
          Duration(milliseconds: 20),
          Duration(milliseconds: 30),
        ],
      );

      final response = await client.get('/unstable-service');

      expect(response.statusCode, equals(200));
      expect(attempts, equals(3));
      expect(response.data, equals({'success': true}));
    });
  });

  group('ApiClient Exception Mapping', () {
    test('maps 401 Unauthorized to AuthException', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        return ResponseBody.fromString(
          json.encode({'message': 'Invalid credentials'}),
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      expect(
        () => client.get('/protected'),
        throwsA(isA<AuthException>().having((e) => e.statusCode, 'statusCode', 401)),
      );
    });

    test('maps 500 Internal Server Error to ServerException after retries exhaust', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        return ResponseBody.fromString(
          json.encode({'message': 'Database failure'}),
          500,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
        retries: 2,
        retryDelays: const [
          Duration(milliseconds: 5),
          Duration(milliseconds: 10),
        ],
      );

      expect(
        () => client.get('/crash'),
        throwsA(isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });

    test('maps connection error to NetworkException', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'Connection refused',
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
        retries: 1,
        retryDelays: const [Duration(milliseconds: 5)],
      );

      expect(
        () => client.get('/offline'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('ApiClient HTTP Methods', () {
    test('post, put, delete, patch invoke respective Dio methods', () async {
      when(() => mockTokenProvider.getToken()).thenAnswer((_) async => null);

      String? capturedMethod;
      dynamic capturedData;

      dio.httpClientAdapter = TestHttpAdapter((options) async {
        capturedMethod = options.method;
        capturedData = options.data;
        return ResponseBody.fromString(
          json.encode({'result': 'success'}),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final client = ApiClient(
        dio: dio,
        tokenProvider: mockTokenProvider,
        baseUrl: 'https://api.rollandreserve.com',
      );

      final postRes = await client.post('/items', data: {'name': 'dice'});
      expect(postRes.statusCode, 200);
      expect(capturedMethod, 'POST');
      expect(capturedData, {'name': 'dice'});

      final putRes = await client.put('/items/1', data: {'name': 'd20'});
      expect(putRes.statusCode, 200);
      expect(capturedMethod, 'PUT');
      expect(capturedData, {'name': 'd20'});

      final patchRes = await client.patch('/items/1', data: {'name': 'd12'});
      expect(patchRes.statusCode, 200);
      expect(capturedMethod, 'PATCH');
      expect(capturedData, {'name': 'd12'});

      final deleteRes = await client.delete('/items/1');
      expect(deleteRes.statusCode, 200);
      expect(capturedMethod, 'DELETE');
    });
  });
}
