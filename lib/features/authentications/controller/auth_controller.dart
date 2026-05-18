import 'package:flutter/material.dart';
import '../../../core/services/biometric_services.dart';
import '../../../core/services/secure_storage_services.dart';



class AuthController with ChangeNotifier {
  final BiometricService _biometricService =
  BiometricService();

  final SecureStorageService _storage =
  SecureStorageService();

  bool isLoading = false;

  bool isLoggedIn = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoggedIn = true;
    isLoading = false;
    notifyListeners();

    return true;
  }

  /// Enable biometric after first login
  Future<bool> isBiometricEnabled() => _storage.isBiometricEnabled();

  Future<void> enableBiometric() async {
    await _storage.enableBiometric();
  }

  // Returns true = success, false = failed, null = cancelled or not enabled
  Future<bool?> biometricLogin() async {
    final biometricEnabled = await _storage.isBiometricEnabled();
    if (!biometricEnabled) return null;

    final result = await _biometricService.authenticate();

    if (result == true) {
      isLoggedIn = true;
      notifyListeners();
      return true;
    }

    return result; // false = failed, null = cancelled
  }

  Future<void> logout() async {
    isLoggedIn = false;
    notifyListeners();
  }
}