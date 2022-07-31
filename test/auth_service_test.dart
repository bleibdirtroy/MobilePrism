import 'package:flutter_test/flutter_test.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/storage/storage_exceptions.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

const String hostname = "127.0.0.1";
const String username = "bleibdirtroy";
const String password = "mySecretPassword";
void main() {
  group("Test AuthService", () {
    test("Store credentials", () async {
      final AuthService authService = AuthService(MockStorageProvider());
      await authService.storeUserCredentials(hostname, username, password);

      expect(await authService.readHostname(), hostname);
      expect(await authService.readUsername(), username);
      expect(await authService.readPassword(), password);

      expect(await authService.isUserdataStored(), true);

      try {
        await authService.storeUserCredentials(hostname, username, password);
      } catch (e) {
        expect(e, isA<KeyAlreadyExistsInStorage>());
      }
    });

    test("Delete credentials", () async {
      final AuthService authService = AuthService(MockStorageProvider());
      await authService.storeUserCredentials(hostname, username, password);
      expect(await authService.isUserdataStored(), true);
      //expect(await authService.readUsername(), username);
      await authService.deleteUserCredentials();
      expect(await authService.isUserdataStored(), false);
      try {
        await authService.readHostname();
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.readUsername();
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
      try {
        await authService.readPassword();
      } catch (e) {
        expect(e, isA<KeyNotFoundInStorage>());
      }
    });
  });
}

class MockStorageProvider implements StorageProvider {
  bool existsHostnameKey = false;
  bool existsUsernameKey = false;
  bool existsPasswordKey = false;

  @override
  Future<void> deleteAllData() {
    existsHostnameKey = existsUsernameKey = existsPasswordKey = false;
    return Future.value();
  }

  @override
  Future<void> deleteData(String key) {
    if (key == 'hostname') {
      existsHostnameKey = false;
    } else if (key == 'username') {
      existsUsernameKey = false;
    } else if (key == 'password') {
      existsPasswordKey = false;
    }
    return Future.value();
  }

  @override
  Future<bool> existsKey(String key) {
    if ((key == 'hostname' && existsHostnameKey) ||
        (key == 'username' && existsUsernameKey) ||
        (key == 'password' && existsPasswordKey)) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  Future<String> readData(String key) {
    if (key == 'hostname' && existsHostnameKey) {
      return Future.value(hostname);
    } else if (key == 'username' && existsUsernameKey) {
      return Future.value(username);
    } else if (key == 'password' && existsPasswordKey) {
      return Future.value(password);
    } else {
      throw KeyNotFoundInStorage();
    }
  }

  @override
  Future<void> storeData(String key, String value) {
    if (key == "hostname" && !existsHostnameKey) {
      existsHostnameKey = true;
      return Future.value();
    } else if (key == "username" && !existsUsernameKey) {
      existsUsernameKey = true;
      return Future.value();
    } else if (key == "password" && !existsPasswordKey) {
      existsPasswordKey = true;
      return Future.value();
    }
    throw KeyAlreadyExistsInStorage();
  }

  @override
  Future<void> updateData(String key, String value) {
    if (key == "hostname" && existsHostnameKey) {
      existsHostnameKey = true;
    } else if (key == "username" && existsUsernameKey) {
      existsUsernameKey = true;
    } else if (key == "password" && existsPasswordKey) {
      existsPasswordKey = true;
    }
    return Future.value();
  }
}
