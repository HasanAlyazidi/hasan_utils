library hasan_utils;

import 'dart:io' show Platform;

export 'src/api/api_authorization.dart';
export 'src/api/api_interceptor.dart';
export 'src/api/api_request_options.dart';
export 'src/api/api.dart';

export 'src/alert.dart';
export 'src/storage.dart';
export 'src/navigation.dart';
export 'src/validate.dart' show Validate;
export 'src/file_utils.dart';
export 'src/file_downloader.dart';

export 'src/persistence/persistence.dart';
export 'src/persistence/persistence_engine.dart';
export 'src/persistence/local_persistence.dart';
export 'src/persistence/json_persistence.dart';

String get deviceOS => Platform.operatingSystem;
