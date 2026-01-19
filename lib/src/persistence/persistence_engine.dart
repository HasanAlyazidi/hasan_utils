abstract class PersistenceEngine {
  Map<String, dynamic> get data;
  Future<String> load();
  Future<void> save(String string);
  Future<void> reset();
}
