import 'package:flutter/material.dart';
import '../../../core/enums/biometric_auth_result.dart';
import '../../../core/enums/biometric_status.dart';
import '../../../core/services/biometric_services.dart';
import '../../../core/services/secure_storage_services.dart';

class AuthController with ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  final SecureStorageService _storage = SecureStorageService();

  bool isLoading = false;
  bool isLoggedIn = false;
  BiometricStatus biometricStatus = BiometricStatus.unknown;
  String userName = '';

  AuthController() {
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    biometricStatus = await _storage.getBiometricStatus();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    userName = email.split('@').first;
    isLoggedIn = true;
    isLoading = false;
    biometricStatus = await _storage.getBiometricStatus();
    notifyListeners();

    return true;
  }

  Future<void> enableBiometric() async {
    biometricStatus = biometricStatus.enable();
    await _storage.saveBiometricStatus(biometricStatus);
    notifyListeners();
  }

  // Returns null when biometric is not in a state that allows an attempt.
  Future<BiometricAuthResult?> biometricLogin() async {
    if (!biometricStatus.canAttempt) return null;

    final result = await _biometricService.authenticate();

    switch (result) {
      case BiometricAuthResult.success:
        isLoggedIn = true;
      case BiometricAuthResult.lockedOut:
        biometricStatus = biometricStatus.lockOut();
        await _storage.saveBiometricStatus(biometricStatus);
      default:
        break;
    }

    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    biometricStatus = biometricStatus.reset();
    await _storage.saveBiometricStatus(biometricStatus);
    isLoggedIn = false;
    userName = '';
    notifyListeners();
  }
}
