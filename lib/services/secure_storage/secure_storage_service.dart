import 'package:mobileprism/services/secure_storage/secure_storage_provider.dart';

class SecureStorageService {
  final SecureStorageProvider _provider;

  SecureStorageService(this._provider);

  void openStorage() => _provider.openStorage();

  Future<void> storeData(String key, Object value) =>
      _provider.storeData(key, value);

  Future<T> readData<T>(String key) => _provider.readData(key);
}
