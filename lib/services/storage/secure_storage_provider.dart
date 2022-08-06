import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileprism/services/storage/storage_exceptions.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class SecureStorageProvider implements StorageProvider {
  FlutterSecureStorage? _storage;

  SecureStorageProvider() {
    _storage = FlutterSecureStorage(
        aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
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
    print("storeData");
    print("key: $key");
    print("value: $value \n");
    if (!await storage.containsKey(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions())) {
      await storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } else {
      throw KeyAlreadyExistsInStorage();
    }
  }

  @override
  Future<void> updateData(String key, String value) async {
    final storage = _isStorageInitialized();
    print("updateData");
    print("key: $key");
    print("value: $value \n");
    if (await storage.containsKey(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions())) {
      await storage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<String> readData(String key) async {
    final storage = _isStorageInitialized();
    print("readData");
    print("key: $key");
    if (await storage.containsKey(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions())) {
      final String item = await storage.read(
              key: key,
              aOptions: _getAndroidOptions(),
              iOptions: _getIOSOptions()) ??
          "";
      print("item: $item");
      return item;
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<bool> existsKey(String key) async {
    final storage = _isStorageInitialized();
    print("existsKey");
    print("key: $key");
    final exists = await storage.containsKey(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
    print("exists: $exists");
    return exists;
  }

  @override
  Future<void> deleteData(String key) async {
    final storage = _isStorageInitialized();
    print("deleteData");
    print("key: $key");
    await storage.delete(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  @override
  Future<void> deleteAllData() async {
    final storage = _isStorageInitialized();
    print("deleteAllData");
    print("deleteAll");
    await storage.deleteAll(
        aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: "mobileprism",
        accessibility: IOSAccessibility.first_unlock,
      );
}
