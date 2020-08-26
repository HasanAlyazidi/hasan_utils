abstract class PersistenceEngine {
  Future<String> load();
  Future<void> save(String string);
  Future<void> reset();
}
