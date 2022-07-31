import 'package:mobileprism/services/storage/secure_storage_provider.dart';
import 'package:mobileprism/services/storage/storage_provider.dart';

class AuthService {
  final StorageProvider _storageProvider;

  AuthService(this._storageProvider);

  factory AuthService.secureStorage() => AuthService(SecureStorageProvider());

  Future<void> storeUserCredentials(
    String hostname,
    String username,
    String password,
  ) async {
    await _storageProvider.storeData(hostnameKey, hostname);
    await _storageProvider.storeData(usernameKey, username);
    await _storageProvider.storeData(passwordKey, password);
  }

  Future<String> readHostname() {
    return _storageProvider.readData(hostnameKey);
  }

  Future<String> readUsername() {
    return _storageProvider.readData(usernameKey);
  }

  Future<String> readPassword() {
    return _storageProvider.readData(passwordKey);
  }

  Future<void> deleteUserCredentials() async {
    await _storageProvider.deleteData(hostnameKey);
    await _storageProvider.deleteData(usernameKey);
    await _storageProvider.deleteData(passwordKey);
  }

  Future<bool> isUserLoggedIn() async {
    return await _storageProvider.existsKey(hostnameKey) &&
        await _storageProvider.existsKey(usernameKey) &&
        await _storageProvider.existsKey(passwordKey);
  }
}

const hostnameKey = "hostname";
const usernameKey = "username";
const passwordKey = "password";
