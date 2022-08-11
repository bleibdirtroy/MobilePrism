import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileprism/services/storage/storage_exceptions.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class SecureStorageProvider implements StorageProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageProvider();

  @override
  Future<void> storeData(String key, String value) async {
    log("storeData");
    log("key: $key");
    log("value: $value \n");
    if (!await _storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
      await _storage.write(
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
    log("updateData");
    log("key: $key");
    log("value: $value \n");
    if (await _storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
      await _storage.write(
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
    log("readData");
    log("key: $key");
    if (await _storage.containsKey(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    )) {
      final String item = await _storage.read(
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
    log("existsKey");
    log("key: $key");
    if (Platform.isAndroid) {
      final exists = await _storage.containsKey(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      log("exists: $exists");
      return exists;
    } else {
      final exists = await _storage.read(key: key) == "";
      return !exists;
    }
  }

  @override
  Future<void> deleteData(String key) async {
    log("deleteData");
    log("key: $key");
    await _storage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  @override
  Future<void> deleteAllData() async {
    log("deleteAllData");
    log("deleteAll");
    await _storage.deleteAll(
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
