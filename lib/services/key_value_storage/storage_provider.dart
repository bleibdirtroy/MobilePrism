abstract class StorageProvider {
  Future<void> insertData(String key, String value);
  Future<void> updateData(String key, String value);
  Future<void> upsertData(String key, String value);
  Future<String> readData(String key);
  Future<bool> existsKey(String key);
  Future<void> deleteData(String key);
  Future<void> deleteAllData();
}
