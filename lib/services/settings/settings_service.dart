import 'dart:convert';

import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/services/key_value_storage/secure_storage_provider.dart';

class SettingsService {
  final _secureStorage = SecureStorageProvider();
  Future<void> setUseDatabase() async {
    await _secureStorage.upsertData(
      "useDatabaseOnly",
      jsonEncode(PhotoPrismServer().useDatabaseOnly),
    );
  }

  Future<void> loadSettings() async {
    if (await _secureStorage.existsKey("useDatabaseOnly")) {
      PhotoPrismServer().useDatabaseOnly = jsonDecode(
        await _secureStorage.readData("useDatabaseOnly"),
      ) as bool;
    } else {
      await _secureStorage.insertData("useDatabaseOnly", jsonEncode(false));
    }
  }
}
