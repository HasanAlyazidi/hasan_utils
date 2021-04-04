import 'dart:convert';

import 'package:hasan_utils/src/storage.dart';
import 'package:hasan_utils/src/persistence/persistence_engine.dart';

class JsonPersistence implements PersistenceEngine {
  JsonPersistence({
    required this.key,
    required this.data,
    this.version = 0,
  });

  final String key;
  final int version; // TODO: implement
  final Map<String, dynamic> data;

  Future<String> load() async {
    final loaded = await Storage.get<String>(key);
    return loaded ?? jsonEncode(data);
  }

  Future<void> save(String string) {
    return Storage.setString(key, string);
  }

  Future<void> reset() {
    throw Exception('implemented yet'); // TODO: implement
  }
}
