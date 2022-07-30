import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageIsNotOpen implements Exception {}

class ItemNotFoundInStorage implements Exception {}

class SecureStorageProvider {
  FlutterSecureStorage? _storage;

  FlutterSecureStorage _getStorage() {
    final storage = _storage;
    if (_storage == null) {
      throw StorageIsNotOpen();
    } else {
      return storage!;
    }
  }

  void openStorage() {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  Future<void> storeData(String key, Object value) async {
    final storage = _getStorage();
    await storage.write(key: key, value: jsonEncode(value));
  }

  Future<T> readData<T>(String key) async {
    final storage = _getStorage();
    if (await storage.containsKey(key: key)) {
      final String item = await storage.read(key: key) ?? "";
      return jsonDecode(item) as T;
    } else {
      throw ItemNotFoundInStorage();
    }
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
