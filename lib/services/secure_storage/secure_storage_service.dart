import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageIsNotOpen implements Exception {}

class ItemNotFoundInStorage implements Exception {}

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageService();

  Future<void> storeData(String key, Object value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  Future<T> readData<T>(String key) async {
    if (await _storage.containsKey(key: key)) {
      final String item = await _storage.read(key: key) ?? "";
      return jsonDecode(item) as T;
    } else {
      throw ItemNotFoundInStorage();
    }
  }
}
