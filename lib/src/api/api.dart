import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fast_localization/fast_localization.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:hasan_utils/src/alert.dart';
import 'package:hasan_utils/src/validate.dart';
import 'package:hasan_utils/src/api/api_authorization.dart';
import 'package:hasan_utils/src/api/api_multipart.dart';
import 'package:hasan_utils/src/api/api_interceptor.dart';
import 'package:hasan_utils/src/api/api_request_options.dart';
import 'package:hasan_utils/src/api/api_error_exception.dart';

class Api {
  static String? _baseUrl;
  static ApiAuthorization? _authorization;
  static List<ApiInterceptor>? _interceptors;
  static int _timeout = 60;
  static Map<String, String> _headers = {};

  static Dio? _dio;

  static ApiMultipart multipart = ApiMultipart();
  static String get baseUrl => _baseUrl ?? '';

  static options(
      {required String baseUrl,
      Map<String, String>? headers,
      ApiAuthorization? authorization,
      List<ApiInterceptor>? interceptors,
      int? timeout}) {
    _dio = null;
    _baseUrl = baseUrl;

    if (headers != null) {
      _headers.addAll(headers);
    }

    _authorization = authorization;
    _interceptors = interceptors;

    if (timeout != null) {
      _timeout = timeout;
    }
  }

  static String url(url) => '$baseUrl$url';

  static Map<String, String> get authorizationHeader => {
        'Authorization': _authorization?.header,
      };

  static _requestCall(String method, String url, BuildContext? context,
      {Map<String, dynamic>? params,
      String? alertTitle,
      bool auth = false,
      Map<String, String>? headers,
      Function? onStart,
      Function? onSuccess,
      Function? onFinish,
      Function? onError,
      bool silent = false}) {
    if (_baseUrl == null) {
      throw Exception(
          'Api error: No api base url specified, call Api.options(..) to set api base url.');
    }

    if (_dio == null) {
      _init();
    }

    if (kDebugMode) {
      print('Api | method: $method | ${_dio!.options.baseUrl}$url');
    }

    Map<String, dynamic> apiHeaders = {
      'Content-Language': Localization.languageCountry.replaceFirst('_', '-'),
      'Accept': 'application/json',
    }..addAll(_headers);

    if (auth && _authorization != null) {
      apiHeaders['Authorization'] = _authorization!.header;
    }

    if (headers != null) {
      apiHeaders.addAll(headers);
    }

    final Options options = Options(
      method: method,
      headers: apiHeaders,
    );

    final FormData formData =
        FormData.fromMap(params ?? {}, ListFormat.multiCompatible);

    if (onError != null) {
      final bool isValidType =
          onError is Function(ApiErrorException) || onError is Function();

      final bool isDynamicFunction = onError is Function(dynamic);

      if (!isValidType || isDynamicFunction) {
        throw Exception(
            'Api error: onError must have explicit type: use () {} or (ApiErrorException) {}');
      }
    }

    if (onStart != null) {
      onStart();
    }

    _addInterceptors();

    return _dio!
        .request(url, data: formData, options: options)
        .then((response) async {
      dynamic data;

      try {
        data = response.data;

        if (data is! List && data is! Map) {
          throw Exception('Response is not a JSON list or object.');
        }
      } catch (e) {
        _throwDioError(url, 'Error occurred while parsing JSON. ($e)');
      }

      try {
        if (onSuccess != null) {
          await onSuccess(data);
        }
      } catch (e) {
        _throwDioError(url,
            'Successful API call, but an error occurred inside `onSuccess` function. ($e)');
      }
    }).catchError((error) {
      if (kDebugMode) {
        final response = error is FormatException ? null : error.response;
        print('Api | error: $error | response: $response');
      }

      if (silent) {
        return;
      }

      String? errorMessage;
      int? statusCode;
      dynamic responseData;
      bool isServerError = false;

      final bool isDioError = error is DioException;

      if (isDioError) {
        statusCode = error.response?.statusCode;
        responseData = error.response?.data;
      }

      try {
        var errorResponse = json.decode(error.response.toString());
        var errorField = errorResponse['error'];

        if (errorField is String) {
          errorMessage = errorField;
          isServerError = true;
        } else if (errorField == null) {
          throw Exception('No error message from API');
        }
      } catch (e) {}

      errorMessage = errorMessage ?? Validate.message.unknownError;

      if (onError != null) {
        if (onError is Function()) {
          onError();
        } else if (onError is Function(ApiErrorException)) {
          final exception = ApiErrorException(
            message: errorMessage,
            isServerError: isServerError,
            statusCode: statusCode,
            responseData: responseData,
            dioError: isDioError ? error : null,
          );

          onError(exception);
        }

        return;
      }

      final errorTitle = alertTitle ?? t('error');

      if (context != null) {
        Alert.show(context, errorTitle, errorMessage);
      }
    }).whenComplete(() {
      if (onFinish != null) {
        onFinish();
      }
    });
  }

  static get(String url, BuildContext? context,
      {Map<String, String>? params,
      String? alertTitle,
      bool auth = true,
      Map<String, String>? headers,
      Function? onStart,
      Function? onSuccess,
      Function? onFinish,
      Function? onError,
      bool silent = false}) {
    String finalUrl = url;

    if (params != null) {
      final String queryParams = Uri(queryParameters: params).query;

      finalUrl += finalUrl.contains('?') ? '&' : '?';
      finalUrl += queryParams;
    }

    return _requestCall('GET', finalUrl, context,
        alertTitle: alertTitle,
        auth: auth,
        headers: headers,
        onStart: onStart,
        onSuccess: onSuccess,
        onFinish: onFinish,
        onError: onError,
        silent: silent);
  }

  static post(String url, BuildContext? context,
      {Map<String, dynamic>? params,
      String? alertTitle,
      bool auth = true,
      Map<String, String>? headers,
      Function? onStart,
      Function? onSuccess,
      Function? onFinish,
      Function? onError,
      bool silent = false}) {
    return _requestCall('POST', url, context,
        params: params,
        alertTitle: alertTitle,
        auth: auth,
        headers: headers,
        onStart: onStart,
        onSuccess: onSuccess,
        onFinish: onFinish,
        onError: onError,
        silent: silent);
  }

  static patch(String url, BuildContext? context,
      {Map<String, dynamic>? params,
      String? alertTitle,
      bool auth = true,
      Map<String, String>? headers,
      Function? onStart,
      Function? onSuccess,
      Function? onFinish,
      Function? onError,
      bool silent = false,
      bool mock = false}) {
    if (params == null) {
      params = Map.fromEntries({});
    }

    String method = 'PATCH';

    if (mock) {
      params['_method'] = method;
      method = 'POST';
    }

    return _requestCall(method, url, context,
        params: params,
        alertTitle: alertTitle,
        auth: auth,
        headers: headers,
        onStart: onStart,
        onSuccess: onSuccess,
        onFinish: onFinish,
        onError: onError,
        silent: silent);
  }

  static delete(String url, BuildContext? context,
      {Map<String, dynamic>? params,
      String? alertTitle,
      bool auth = true,
      Map<String, String>? headers,
      Function? onStart,
      Function? onSuccess,
      Function? onFinish,
      Function? onError,
      bool silent = false,
      bool mock = false}) {
    if (params == null) {
      params = Map.fromEntries({});
    }

    String method = 'DELETE';

    if (mock) {
      params['_method'] = method;
      method = 'POST';
    }

    return _requestCall(method, url, context,
        params: params,
        alertTitle: alertTitle,
        auth: auth,
        headers: headers,
        onStart: onStart,
        onSuccess: onSuccess,
        onFinish: onFinish,
        onError: onError,
        silent: silent);
  }

  static void _init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: _timeout),
        receiveTimeout: Duration(seconds: _timeout),
      ),
    );
  }

  static void _addInterceptors() {
    _dio!.interceptors.clear();

    if (_interceptors == null || _interceptors!.isEmpty) {
      return;
    }

    final List<Frame> trace = Trace.current(3).frames;

    for (final interceptor in _interceptors!) {
      final item = InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          if (interceptor.onRequest == null) {
            return;
          }

          final ApiRequestOptions apiOptions = ApiRequestOptions(
            baseUrl: options.baseUrl,
            path: options.path,
            method: options.method,
            headers: options.headers,
          );

          final bool handleNext = interceptor.onRequest!(apiOptions, trace);

          if (!handleNext) {
            return;
          }

          options.baseUrl = apiOptions.baseUrl;
          options.path = apiOptions.path;
          options.method = apiOptions.method;
          options.headers = apiOptions.headers;

          handler.next(options);
        },
      );

      _dio!.interceptors.add(item);
    }
  }

  static void _throwDioError(String url, String data) {
    final errorRequestOptions = RequestOptions(path: url);

    throw DioException(
      requestOptions: errorRequestOptions,
      response: Response(
        requestOptions: errorRequestOptions,
        data: data,
      ),
    );
  }
}
