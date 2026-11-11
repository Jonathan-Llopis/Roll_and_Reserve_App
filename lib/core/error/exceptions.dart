class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException([this.message = 'Server Error', this.statusCode]);

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache Error']);

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException([this.message = 'Authentication Error', this.statusCode]);

  @override
  String toString() => 'AuthException: $message (code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'Network Connection Error']);

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException([this.message = 'Validation Error']);

  @override
  String toString() => 'ValidationException: $message';
}
