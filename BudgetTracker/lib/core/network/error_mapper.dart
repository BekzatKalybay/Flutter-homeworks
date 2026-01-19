import 'package:dio/dio.dart';
import '../errors/failure.dart';

class ErrorMapper {
  static Failure mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        final message = exception.response?.data?['message'] as String? ??
            exception.response?.statusMessage ??
            'Server error occurred';

        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerFailure('Server error: $message', statusCode: statusCode);
          } else if (statusCode >= 400) {
            return ValidationFailure('Validation error: $message');
          }
        }
        return ServerFailure(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return NetworkFailure('Request was cancelled.');

      case DioExceptionType.connectionError:
        return NetworkFailure('No internet connection. Please check your network.');

      case DioExceptionType.badCertificate:
        return NetworkFailure('SSL certificate error.');

      case DioExceptionType.unknown:
      default:
        final message = exception.message ?? 'An unknown error occurred';
        return UnknownFailure(message);
    }
  }

  static Failure mapException(Exception exception) {
    if (exception is DioException) {
      return mapDioException(exception);
    }
    return UnknownFailure(exception.toString());
  }
}
