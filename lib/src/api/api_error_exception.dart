import 'package:dio/dio.dart';

class ApiErrorException implements Exception {
  final String message;
  final bool isServerError;
  final bool isSimpleError;
  final int? statusCode;
  final dynamic responseData;
  final DioException? dioError;

  const ApiErrorException({
    required this.message,
    required this.isServerError,
    required this.isSimpleError,
    this.statusCode,
    this.responseData,
    this.dioError,
  });

  @override
  String toString() => 'ApiErrorException: $message';
}
