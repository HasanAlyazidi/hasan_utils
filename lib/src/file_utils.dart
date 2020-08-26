import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FileUtils {
  static Future delete({String path, Function onError}) async {
    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    }
  }
}
