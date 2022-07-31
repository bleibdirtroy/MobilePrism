abstract class StorageProvider {
  Future<void> storeData(String key, String value);
  Future<void> updateData(String key, String value);
  Future<String> readData(String key);
  Future<bool> existsKey(String key);
  Future<void> deleteData(String key);
  Future<void> deleteAllData();
}
