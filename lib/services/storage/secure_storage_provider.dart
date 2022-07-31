import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileprism/services/storage/storage_exceptions.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class SecureStorageProvider implements StorageProvider {
  FlutterSecureStorage? _storage;

  SecureStorageProvider() {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  FlutterSecureStorage _isStorageInitialized() {
    if (_storage == null) {
      throw StorageIsNotInitialized();
    } else {
      return _storage!;
    }
  }

  @override
  Future<void> storeData(String key, String value) async {
    final storage = _isStorageInitialized();
    if (!await storage.containsKey(key: key, aOptions: _getAndroidOptions())) {
      await storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } else {
      throw KeyAlreadyExistsInStorage();
    }
  }

  @override
  Future<void> updateData(String key, String value) async {
    final storage = _isStorageInitialized();
    if (await storage.containsKey(key: key, aOptions: _getAndroidOptions())) {
      await storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
      );
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<String> readData(String key) async {
    final storage = _isStorageInitialized();
    if (await storage.containsKey(key: key, aOptions: _getAndroidOptions())) {
      final String item =
          await storage.read(key: key, aOptions: _getAndroidOptions()) ?? "";
      return item;
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<bool> existsKey(String key) {
    final storage = _isStorageInitialized();
    return storage.containsKey(key: key, aOptions: _getAndroidOptions());
  }

  @override
  Future<void> deleteData(String key) async {
    final storage = _isStorageInitialized();
    await storage.delete(key: key, aOptions: _getAndroidOptions());
  }

  @override
  Future<void> deleteAllData() async {
    final storage = _isStorageInitialized();
    await storage.deleteAll(aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
