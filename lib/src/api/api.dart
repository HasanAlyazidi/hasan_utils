import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fast_localization/fast_localization.dart';

import 'package:hasan_utils/src/alert.dart';
import 'package:hasan_utils/src/validate.dart';
import 'package:hasan_utils/src/api/api_authorization.dart';
import 'package:hasan_utils/src/api/api_multipart.dart';

class Api {
  static String _baseUrl;
  static ApiAuthorization _authorization;
  static Map<String, String> _headers = {};

  static Dio _dio = Dio(BaseOptions(
      baseUrl: baseUrl, connectTimeout: 15 * 1000, receiveTimeout: 15 * 1000));

  static ApiMultipart multipart = ApiMultipart();
  static String get baseUrl => _baseUrl;

  static options(
      {@required String baseUrl,
      Map<String, String> headers,
      ApiAuthorization authorization}) {
    _baseUrl = baseUrl;

    if (headers != null) {
      _headers.addAll(headers);
    }

    _authorization = authorization;
  }

  static String url(url) => '$baseUrl$url';

  static Map<String, String> get authorizationHeader => {
        'Authorization': _authorization?.header,
      };

  static _requestCall(String method, String url, BuildContext context,
      {Map<String, dynamic> params,
      String alertTitle,
      bool auth,
      Map<String, String> headers,
      Function onStart,
      Function onSuccess,
      Function onFinish,
      Function onError,
      bool silent}) {
    if (_baseUrl == null) {
      throw Exception(
          'Api error: No api base url specified, call Api.options(..) to set api base url.');
    }

    if (kDebugMode) {
      print('Api | method: $method | ${_dio.options.baseUrl}$url');
    }

    var apiHeaders = {
      'Content-Language': Localization.languageCountry.replaceFirst('_', '-'),
      'Accept': 'application/json',
    }..addAll(_headers);

    if (auth && _authorization != null) {
      apiHeaders['Authorization'] = _authorization.header;
    }

    if (headers != null) {
      apiHeaders.addAll(headers);
    }

    final Options options = Options(
      method: method,
      headers: apiHeaders,
    );

    final FormData formData = FormData.fromMap(params);

    if (onStart != null) {
      onStart();
    }

    return _dio.request(url, data: formData, options: options).then((response) async {
      Map<String, dynamic> data = json.decode(response.toString());

      try {
        if (onSuccess != null) {
          await onSuccess(data);
        }
      } catch (e) {
        throw DioError(
          response: Response(
            data:
                'Successful API call, but an error occurred inside `onSuccess` function. ($e)',
          ),
        );
      }
    }).catchError((error) {
      if (kDebugMode) {
        final response = error is FormatException ? null : error.response;
        print('Api | error: $error | response: $response');
      }

      if (silent) {
        return;
      }

      if (onError != null) {
        onError();
        return;
      }

      String errorMessage;

      try {
        var errorResponse = json.decode(error.response.toString());
        errorMessage = errorResponse['error'];

        if (errorMessage == null) {
          throw Exception('No error message from API');
        }
      } catch (e) {
        errorMessage = Validate.message.unknownError;
      }

      final errorTitle = alertTitle ?? t('error');

      Alert.show(context, errorTitle, errorMessage);
    }).whenComplete(() {
      if (onFinish != null) {
        onFinish();
      }
    });
  }

  static get(String url, BuildContext context,
      {Map<String, String> params,
      String alertTitle,
      bool auth = true,
      Map<String, String> headers,
      Function onStart,
      Function onSuccess,
      Function onFinish,
      Function onError,
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

  static post(String url, BuildContext context,
      {Map<String, dynamic> params,
      String alertTitle,
      bool auth = true,
      Map<String, String> headers,
      Function onStart,
      Function onSuccess,
      Function onFinish,
      Function onError,
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

  static patch(String url, BuildContext context,
      {Map<String, dynamic> params,
      String alertTitle,
      bool auth = true,
      Map<String, String> headers,
      Function onStart,
      Function onSuccess,
      Function onFinish,
      Function onError,
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

  static delete(String url, BuildContext context,
      {Map<String, dynamic> params,
      String alertTitle,
      bool auth = true,
      Map<String, String> headers,
      Function onStart,
      Function onSuccess,
      Function onFinish,
      Function onError,
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
}
