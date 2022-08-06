import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/services/storage/secure_storage_provider.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class AuthService {
  final StorageProvider _storageProvider;

  AuthService(this._storageProvider);

  factory AuthService.secureStorage() => AuthService(SecureStorageProvider());

  Future<void> storeUserData(
    String hostname,
    String username,
    String password,
  ) async {
    await _storageProvider.storeData(hostnameKey, hostname);
    await _storageProvider.storeData(usernameKey, username);
    await _storageProvider.storeData(passwordKey, password);
  }

  Future<String> getHostname() {
    return _storageProvider.readData(hostnameKey);
  }

  Future<String> getUsername() {
    return _storageProvider.readData(usernameKey);
  }

  Future<String> getPassword() {
    return _storageProvider.readData(passwordKey);
  }

  Future<void> deleteUserData() async {
    await _storageProvider.deleteData(hostnameKey);
    await _storageProvider.deleteData(usernameKey);
    await _storageProvider.deleteData(passwordKey);
  }

  Future<bool> isUserdataStored() async {
    return await _storageProvider.existsKey(hostnameKey) &&
        await _storageProvider.existsKey(usernameKey) &&
        await _storageProvider.existsKey(passwordKey);
  }

  Future<void> defaultPhotoprismServer() async {
    return storeUserData(photoprimDefaultServer, "", "");
  }
}

const hostnameKey = "ajhfbjs";
const usernameKey = "adjhbcvjadsc";
const passwordKey = "dksahcbhjdbc";