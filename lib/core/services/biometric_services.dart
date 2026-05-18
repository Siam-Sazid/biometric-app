import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final Logger _log = Logger(printer: PrettyPrinter(methodCount: 0));

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
    _log.i('[Biometric] Starting authentication...');
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to continue',
        persistAcrossBackgrounding: true,
      );
      if (result) {
        _log.i('[Biometric] SUCCESS — authentication passed');
      } else {
        _log.w('[Biometric] FAILED — authentication rejected');
      }
      return result;
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
          _log.i('[Biometric] CANCELLED — ${e.code.name}');
          return null;
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          _log.e('[Biometric] LOCKED OUT — too many failed attempts');
          return false;
        case LocalAuthExceptionCode.noBiometricsEnrolled:
          _log.w('[Biometric] No biometrics enrolled on this device');
          return false;
        case LocalAuthExceptionCode.noBiometricHardware:
          _log.w('[Biometric] No biometric hardware available');
          return false;
        default:
          _log.e('[Biometric] Error: ${e.code.name} — ${e.description}');
          return false;
      }
    } catch (e) {
      _log.e('[Biometric] Unexpected exception type: ${e.runtimeType} — $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    _log.i('[Biometric] Starting biometric-only authentication...');
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Authenticate using biometrics',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (result) {
        _log.i('[Biometric] SUCCESS — biometric matched');
      } else {
        _log.w('[Biometric] FAILED — biometric did not match');
      }
      return result;
    } on LocalAuthException catch (e) {
      _log.e('[Biometric] Error: ${e.code.name} — ${e.description}');
      return false;
    }
  }

  Future<void> cancelAuthentication() async {
    await _auth.stopAuthentication();
    _log.i('[Biometric] Authentication cancelled programmatically');
  }
}
