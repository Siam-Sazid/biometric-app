import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../enums/biometric_status.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _biometricStatusKey = 'biometric_status';

  Future<void> saveBiometricStatus(BiometricStatus status) async {
    await _storage.write(key: _biometricStatusKey, value: status.name);
  }

  Future<BiometricStatus> getBiometricStatus() async {
    final raw = await _storage.read(key: _biometricStatusKey);
    return BiometricStatus.fromString(raw);
  }
}
