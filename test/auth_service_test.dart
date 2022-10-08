import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/key_value_storage/storage_exceptions.dart';
import 'package:mobileprism/services/key_value_storage/storage_provider.dart';

const String hostname = "127.0.0.1";
const String username = "bleibdirtroy";
const String username2 = "bleibdirtroy2";
const String password = "mySecretPassword";
void main() {
  group("Test AuthService on Android", () {
    test("Store user data", () async {
      final AuthService authService =
          AuthService(MockStorageProvider.android());
      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        sessionToken: "",
        previewToken: "public",
      );

      expect(await authService.getHostname(), hostname);
      expect(await authService.getUsername(), username);
      expect(await authService.getPassword(), password);
      expect(await authService.getPreviewToken(), "public");
      expect(await authService.getSessionToken(), "");

      expect(await authService.isUserdataStored(), true);
    });
    test("Override stored data", () async {
      final AuthService authService =
          AuthService(MockStorageProvider.android());
      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        previewToken: "asdf",
        sessionToken: "qwer",
      );
      await authService.storeUserData(
        hostname: hostname,
        username: username2,
        password: password,
        previewToken: "fdsa",
        sessionToken: "rewq",
      );

      expect(await authService.getHostname(), hostname);
      expect(await authService.getUsername(), username2);
      expect(await authService.getPassword(), password);
      expect(await authService.getPreviewToken(), "fdsa");
      expect(await authService.getSessionToken(), "rewq");

      expect(await authService.isUserdataStored(), true);
    });
    test("Use public hostname", () async {
      final AuthService authService = AuthService(MockStorageProvider.iOS());

      await authService.demoPhotoprismServer();

      expect(await authService.getHostname(), publicPhotoPrismServer);

      expect(await authService.isUserdataStored(), true);
    });

    test("Delete user data", () async {
      final AuthService authService =
          AuthService(MockStorageProvider.android());
      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        sessionToken: "",
        previewToken: "public",
      );
      expect(await authService.isUserdataStored(), true);

      await authService.deleteUserData();
      expect(await authService.isUserdataStored(), false);
      try {
        await authService.getHostname();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.getUsername();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.getPassword();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
    });
  });
  group("Test AuthService on iOS", () {
    test("Store user data", () async {
      final AuthService authService = AuthService(MockStorageProvider.iOS());

      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        sessionToken: "",
        previewToken: "public",
      );

      expect(await authService.getHostname(), hostname);
      expect(await authService.getUsername(), username);
      expect(await authService.getPassword(), password);
      expect(await authService.getPreviewToken(), "public");
      expect(await authService.getSessionToken(), "");

      expect(await authService.isUserdataStored(), true);
    });
    test("Use public hostname", () async {
      final AuthService authService = AuthService(MockStorageProvider.iOS());

      await authService.demoPhotoprismServer();

      expect(await authService.getHostname(), publicPhotoPrismServer);
      expect(await authService.getPreviewToken(), "public");

      expect(await authService.isUserdataStored(), true);
    });

    test("Override stored data", () async {
      final AuthService authService = AuthService(MockStorageProvider.iOS());
      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        previewToken: "asdf",
        sessionToken: "qwer",
      );
      await authService.storeUserData(
        hostname: hostname,
        username: username2,
        password: password,
        previewToken: "fdsa",
        sessionToken: "rewq",
      );

      expect(await authService.getHostname(), hostname);
      expect(await authService.getUsername(), username2);
      expect(await authService.getPassword(), password);
      expect(await authService.getPreviewToken(), "fdsa");
      expect(await authService.getSessionToken(), "rewq");

      expect(await authService.isUserdataStored(), true);
    });

    test("Delete user data", () async {
      final AuthService authService = AuthService(MockStorageProvider.iOS());
      await authService.storeUserData(
        hostname: hostname,
        username: username,
        password: password,
        previewToken: "",
        sessionToken: "",
      );
      expect(await authService.isUserdataStored(), true);

      await authService.deleteUserData();
      expect(await authService.isUserdataStored(), false);
      try {
        await authService.getHostname();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.getUsername();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.getPassword();
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
    });
  });
}

class MockStorageProvider implements StorageProvider {
  final Map<String, dynamic> _storage;

  MockStorageProvider(this._storage);

  factory MockStorageProvider.iOS() => MockStorageProvider({
        "hostname": null,
        "username": null,
        "password": null,
        "sessionToken": null,
        "previewToken": null,
      });

  factory MockStorageProvider.android() => MockStorageProvider({});

  @override
  Future<void> deleteAllData() {
    _storage.clear();
    return Future.value();
  }

  @override
  Future<void> deleteData(String key) {
    _storage.remove(key);
    return Future.value();
  }

  @override
  Future<bool> existsKey(String key) {
    final existsKey = _storage.containsKey(key);
    return Future.value(existsKey);
  }

  @override
  Future<String> readData(String key) {
    if (_storage.containsKey(key)) {
      return Future.value(_storage[key].toString());
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<void> upsertData(String key, String value) {
    _storage[key] = value;
    return Future.value();
  }

  @override
  Future<void> insertData(String key, String value) {
    if (!_storage.containsKey(key)) {
      _storage[key] = value;
      return Future.value();
    } else {
      throw KeyAlreadyExistsInStorage();
    }
  }

  @override
  Future<void> updateData(String key, String value) {
    if (_storage.containsKey(key)) {
      _storage[key] = value;
      return Future.value();
    } else {
      throw KeyNotFoundInStorage();
    }
  }
}
