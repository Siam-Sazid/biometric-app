import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    return await _auth.isDeviceSupported();
  }

  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  // Returns true = success, false = failed, null = user cancelled
  Future<bool?> authenticate() async {
    await _auth.stopAuthentication();
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to continue',
        persistAcrossBackgrounding: true,
      );
      if (!result) print('Fingerprint does not match');
      return result ? true : false;
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.userCanceled) return null;
      print('LocalAuthException: ${e.code} — ${e.description}');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }

  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
  }
}
