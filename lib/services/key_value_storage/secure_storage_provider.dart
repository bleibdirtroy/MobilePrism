import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobileprism/exceptions.dart';
import 'package:mobileprism/services/key_value_storage/storage_exceptions.dart';
import 'package:mobileprism/services/key_value_storage/storage_provider.dart';

class SecureStorageProvider implements StorageProvider {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageProvider();

  @override
  Future<void> insertData(String key, String value) async {
    if (!await existsKey(key)) {
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
    if (await existsKey(key)) {
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
  Future<void> upsertData(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  @override
  Future<String> readData(String key) async {
    if (await existsKey(key)) {
      final String item = await _storage.read(
            key: key,
            aOptions: _getAndroidOptions(),
            iOptions: _getIOSOptions(),
          ) ??
          "";
      return item;
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<bool> existsKey(String key) async {
    bool existsKey;
    if (Platform.isAndroid) {
      existsKey = await _storage.containsKey(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } else if (Platform.isIOS) {
      existsKey = await _storage.read(
            key: key,
            aOptions: _getAndroidOptions(),
            iOptions: _getIOSOptions(),
          ) !=
          null;
    } else {
      throw UnsupportedPlatformException();
    }
    return existsKey;
  }

  @override
  Future<void> deleteData(String key) async {
    if (await existsKey(key)) {
      await _storage.delete(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<void> deleteAllData() async {
    await _storage.deleteAll(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: false,
        sharedPreferencesName: "mobileprism",
      );

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: "mobileprism",
      );
}
