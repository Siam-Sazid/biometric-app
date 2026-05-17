import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage =
  FlutterSecureStorage();

  static const String tokenKey = "auth_token";

  static const String biometricEnabledKey =
      "biometric_enabled";

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: tokenKey,
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: tokenKey,
    );
  }

  Future<void> enableBiometric() async {
    await _storage.write(
      key: biometricEnabledKey,
      value: "true",
    );
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(
      key: biometricEnabledKey,
    );

    return value == "true";
  }

  Future<void> disableBiometric() async {
    await _storage.delete(
      key: biometricEnabledKey,
    );
  }
}