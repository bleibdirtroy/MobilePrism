abstract class StorageProvider {
  Future<void> storeData(String key, Object value);
  Future<void> updateData(String key, Object value);
  Future<T> readData<T>(String key);
  Future<bool> existsKey(String key);
  Future<void> deleteData(String key);
  Future<void> deleteAllData();
}
