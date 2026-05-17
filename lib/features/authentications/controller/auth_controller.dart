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

  /// Fake API Login
  Future<bool> login(
      String email,
      String password,
      ) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    /// Replace with real API token
    const fakeToken = "JWT_TOKEN";

    await _storage.saveToken(fakeToken);

    isLoggedIn = true;

    isLoading = false;
    notifyListeners();

    return true;
  }

  /// Enable biometric after first login
  Future<void> enableBiometric() async {
    await _storage.enableBiometric();
  }

  /// Auto biometric login
  Future<bool> biometricLogin() async {
    final biometricEnabled =
    await _storage.isBiometricEnabled();

    if (!biometricEnabled) {
      return false;
    }

    final token = await _storage.getToken();

    if (token == null) {
      return false;
    }

    final authenticated =
    await _biometricService.authenticate();

    if (authenticated) {
      isLoggedIn = true;
      notifyListeners();

      return true;
    }

    return false;
  }

  /// Logout
  Future<void> logout() async {
    await _storage.deleteToken();

    isLoggedIn = false;

    notifyListeners();
  }
}