import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FileDownloader {
  CancelToken _cancelToken;

  Future<void> start({
    @required String url,
    @required String location,
    String filename,
    Function onStart,
    Function(String) onProgress,
    Function(String) onDone,
    Function(Exception) onError,
    Function onExit,
    String method = 'GET',
    Map<String, dynamic> params,
    Map<String, dynamic> headers,
  }) async {
    Dio dio = Dio();

    _cancelToken = CancelToken();

    try {
      final downloadFileName =
          filename ?? url.substring(url.lastIndexOf('/') + 1);
      final filePath = '$location/$downloadFileName';

      final options = Options(method: method, headers: headers);

      if (onStart != null) {
        await onStart();
      }

      await dio.download(url, filePath,
          options: options,
          queryParameters: params, onReceiveProgress: (received, total) {
        if (total != -1 && onProgress != null) {
          final String progress =
              (received / total * 100).toStringAsFixed(0) + '%';
          onProgress(progress);
        }
      }, cancelToken: _cancelToken);

      if (onDone != null) {
        await onDone(filePath);
      }
    } catch (e) {
      if (onError != null && !_cancelToken.isCancelled) {
        await onError(e);
      }
    }

    if (onExit != null) {
      await onExit();
    }
  }

  void cancel() {
    if (_cancelToken != null && !_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
  }
}
