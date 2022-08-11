import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileprism/services/storage/storage_exceptions.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class SecureStorageProvider implements StorageProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageProvider() {
    //_storage = const FlutterSecureStorage();
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
    log("storeData");
    log("key: $key");
    log("value: $value \n");
    if (!await storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
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
    log("updateData");
    log("key: $key");
    log("value: $value \n");
    if (await storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
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
    log("readData");
    log("key: $key");
    if (await storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
      final String item = await storage.read(
            key: key,
            aOptions: _getAndroidOptions(),
            iOptions: _getIOSOptions(),
          ) ??
          "";
      log("item: $item");
      return item;
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<bool> existsKey(String key) async {
    final storage = _isStorageInitialized();
    log("existsKey");
    log("key: $key");
    final exists = await storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
    log("exists: $exists");
    return exists;
  }

  @override
  Future<void> deleteData(String key) async {
    final storage = _isStorageInitialized();
    log("deleteData");
    log("key: $key");
    await storage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  @override
  Future<void> deleteAllData() async {
    final storage = _isStorageInitialized();
    log("deleteAllData");
    log("deleteAll");
    await storage.deleteAll(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: "mobileprism",
      );
}
