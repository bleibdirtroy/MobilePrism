import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/models/photo_prism_server.dart';
import 'package:mobileprism/services/key_value_storage/secure_storage_provider.dart';
import 'package:mobileprism/services/key_value_storage/storage_provider.dart';

class AuthService {
  final StorageProvider _storageProvider;

  AuthService(this._storageProvider);

  factory AuthService.secureStorage() => AuthService(SecureStorageProvider());

  Future<void> storeUserData({
    required String hostname,
    required String username,
    required String password,
    required String sessionToken,
    required String previewToken,
  }) async {
    await _storageProvider.upsertData(hostnameKey, hostname);
    await _storageProvider.upsertData(usernameKey, username);
    await _storageProvider.upsertData(passwordKey, password);
    await _storageProvider.upsertData(sessionTokenKey, sessionToken);
    await _storageProvider.upsertData(previewTokenKey, previewToken);
    PhotoPrismServer().hostname = hostname;
    PhotoPrismServer().username = username;
    PhotoPrismServer().sessionToken = sessionToken;
    PhotoPrismServer().previewToken = previewToken;
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

  Future<String> getSessionToken() {
    return _storageProvider.readData(sessionTokenKey);
  }

  Future<String> getPreviewToken() {
    return _storageProvider.readData(previewTokenKey);
  }

  Future<void> setHostname(String hostname) {
    return _storageProvider.upsertData(hostnameKey, hostname);
  }

  Future<void> setUsername(String username) {
    return _storageProvider.upsertData(usernameKey, username);
  }

  Future<void> setPassword(String password) {
    return _storageProvider.upsertData(passwordKey, password);
  }

  Future<void> setSessionToken(String sessionToken) {
    return _storageProvider.upsertData(sessionTokenKey, sessionToken);
  }

  Future<void> setPreviewToken(String previewToken) {
    return _storageProvider.upsertData(previewTokenKey, previewToken);
  }

  Future<void> deleteUserData() async {
    await _storageProvider.deleteData(hostnameKey);
    await _storageProvider.deleteData(usernameKey);
    await _storageProvider.deleteData(passwordKey);
    await _storageProvider.deleteData(sessionTokenKey);
    await _storageProvider.deleteData(previewTokenKey);
  }

  Future<bool> isUserdataStored() async {
    return await _storageProvider.existsKey(hostnameKey) &&
        await _storageProvider.existsKey(usernameKey) &&
        await _storageProvider.existsKey(passwordKey) &&
        await _storageProvider.existsKey(sessionTokenKey) &&
        await _storageProvider.existsKey(previewTokenKey);
  }

  Future<void> demoPhotoprismServer() async {
    return storeUserData(
      hostname: publicPhotoPrismServer,
      username: "",
      password: "",
      sessionToken: "",
      previewToken: publicPhotoPrismPreviewToken,
    );
  }
}

const hostnameKey = "hostname";
const usernameKey = "username";
const passwordKey = "password";
const sessionTokenKey = "sessionToken";
const previewTokenKey = "previewToken";
