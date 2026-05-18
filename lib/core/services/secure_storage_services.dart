import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _biometricEnabledKey = "biometric_enabled";

  Future<void> enableBiometric() async {
    await _storage.write(key: _biometricEnabledKey, value: "true");
  }

  Future<bool> isBiometricEnabled() async {
    return await _storage.read(key: _biometricEnabledKey) == "true";
  }

  Future<void> disableBiometric() async {
    await _storage.delete(key: _biometricEnabledKey);
  }
}