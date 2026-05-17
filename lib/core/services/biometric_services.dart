import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth =
  LocalAuthentication();

  /// Check if biometrics are supported
  Future<bool> isDeviceSupported() async {
    return await _auth.isDeviceSupported();
  }

  /// Check if biometrics are available
  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// Get available biometric methods
  Future<List<BiometricType>>
  getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  /// Authenticate user
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason:
        'Authenticate to continue',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }

  /// Fingerprint / Face ID only
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason:
        'Authenticate using biometrics',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }

  /// Cancel auth
  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
  }
}