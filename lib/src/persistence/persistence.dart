import 'dart:convert';

import 'package:hasan_utils/src/persistence/persistence_engine.dart';

class Persistence {
  final PersistenceEngine engine = null;

  Map<String, dynamic> _data = {};

  static Future loadAll(List<Persistence> items) {
    final futures = items.map((item) => item.load());
    return Future.wait(futures);
  }

  static Future putAll(List<Future> puts) {
    return Future.wait(puts);
  }

  dynamic get(String field) => _data[field];

  void update(String field, dynamic value) => _data[field] = value;

  Future load() async {
    if (engine == null) {
      throw Exception('No engine specified');
    }

    final String json = await engine.load();
    _data = jsonDecode(json);
  }

  Future save() {
    final string = jsonEncode(_data);
    return engine.save(string);
  }

  Future reset() async {
    await engine.reset();
    await load();
  }

  @override
  String toString() => _data.toString();
}
