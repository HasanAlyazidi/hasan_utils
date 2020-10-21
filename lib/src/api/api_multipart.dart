import 'dart:io';

import 'package:dio/dio.dart';

class ApiMultipart {
  Future<MultipartFile> fromFile(File file, {String filename}) {
    return MultipartFile.fromFile(file.path, filename: filename);
  }
}
