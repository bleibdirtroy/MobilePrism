import 'dart:convert';

import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/services/key_value_storage/secure_storage_provider.dart';

class SettingsService {
  final _secureStorage = SecureStorageProvider();
  Future<void> setUseDatabase() async {
    await _secureStorage.upsertData(
      useDatabaseOnlyKey,
      jsonEncode(PhotoPrismServer().useDatabaseOnly),
    );
  }

  Future<void> loadSettings() async {
    if (await _secureStorage.existsKey(useDatabaseOnlyKey)) {
      PhotoPrismServer().useDatabaseOnly = jsonDecode(
        await _secureStorage.readData(useDatabaseOnlyKey),
      ) as bool;
    } else {
      await _secureStorage.insertData(useDatabaseOnlyKey, jsonEncode(false));
    }
  }
}

const useDatabaseOnlyKey = "useDatabaseOnly";
