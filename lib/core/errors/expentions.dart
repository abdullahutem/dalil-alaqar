import 'package:dalil_alaqar/core/errors/error_model.dart';
import 'package:dio/dio.dart';

//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

//!CacheExeption
class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleDioException(DioException e) {
  // Helper function to safely parse error response
  ErrorModel parseErrorResponse(dynamic data, int statusCode) {
    try {
      // Check if response is HTML (bot protection page)
      if (data is String &&
          (data.trim().startsWith('<!DOCTYPE') ||
              data.trim().startsWith('<html'))) {
        return ErrorModel(
          status: statusCode,
          errorMessage:
              'Access blocked by security protection. Please try again or contact support.',
        );
      }

      // If data is already a Map, use it directly
      if (data is Map) {
        return ErrorModel.fromJson(data);
      }

      // If data is a String, it might be JSON - but if it's not parseable, return generic error
      return ErrorModel(
        status: statusCode,
        errorMessage:
            data?.toString() ?? 'An error occurred. Please try again.',
      );
    } catch (e) {
      return ErrorModel(
        status: statusCode,
        errorMessage: 'An error occurred. Please try again.',
      );
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(
        e.response != null
            ? parseErrorResponse(e.response!.data, e.response!.statusCode ?? 0)
            : ErrorModel(
                status: 0,
                errorMessage:
                    'Connection error. Please check your internet connection.',
              ),
      );
    case DioExceptionType.badCertificate:
      throw BadCertificateException(
        e.response != null
            ? parseErrorResponse(e.response!.data, e.response!.statusCode ?? 0)
            : ErrorModel(status: 0, errorMessage: 'SSL certificate error.'),
      );
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(
        e.response != null
            ? parseErrorResponse(e.response!.data, e.response!.statusCode ?? 0)
            : ErrorModel(
                status: 0,
                errorMessage: 'Connection timeout. Please try again.',
              ),
      );

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(
        e.response != null
            ? parseErrorResponse(e.response!.data, e.response!.statusCode ?? 0)
            : ErrorModel(
                status: 0,
                errorMessage: 'Request timeout. Please try again.',
              ),
      );

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(
        e.response != null
            ? parseErrorResponse(e.response!.data, e.response!.statusCode ?? 0)
            : ErrorModel(
                status: 0,
                errorMessage: 'Send timeout. Please try again.',
              ),
      );

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode ?? 0;
      final responseData = e.response?.data;

      switch (statusCode) {
        case 400: // Bad request
          throw BadResponseException(
            parseErrorResponse(responseData, statusCode),
          );

        case 401: //unauthorized
          throw UnauthorizedException(
            parseErrorResponse(responseData, statusCode),
          );

        case 403: //forbidden
          throw ForbiddenException(
            parseErrorResponse(responseData, statusCode),
          );

        case 404: //not found
          throw NotFoundException(parseErrorResponse(responseData, statusCode));

        case 409: //cofficient
          throw CofficientException(
            parseErrorResponse(responseData, statusCode),
          );

        case 500: // Internal server error
          throw ServerException(parseErrorResponse(responseData, statusCode));

        case 504: // Gateway timeout
          throw BadResponseException(
            ErrorModel(
              status: 504,
              errorMessage: 'Gateway timeout. Please try again.',
            ),
          );

        default: // Any other bad response
          throw BadResponseException(
            parseErrorResponse(responseData, statusCode),
          );
      }

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: 'Request cancelled.', status: 0),
      );

    case DioExceptionType.unknown:
      throw UnknownException(
        ErrorModel(
          errorMessage: e.message ?? 'An unknown error occurred.',
          status: 0,
        ),
      );
  }
}
