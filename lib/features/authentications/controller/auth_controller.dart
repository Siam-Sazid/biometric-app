import 'package:flutter/material.dart';
import '../../../core/services/biometric_services.dart';
import '../../../core/services/secure_storage_services.dart';

class AuthController with ChangeNotifier {
  final BiometricService _biometricService = BiometricService();
  final SecureStorageService _storage = SecureStorageService();

  bool isLoading = false;
  bool isLoggedIn = false;
  bool biometricEnabled = false;
  String userName = '';

  AuthController() {
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    biometricEnabled = await _storage.isBiometricEnabled();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    userName = email.split('@').first;
    isLoggedIn = true;
    isLoading = false;
    biometricEnabled = await _storage.isBiometricEnabled();
    notifyListeners();

    return true;
  }

  Future<void> enableBiometric() async {
    await _storage.enableBiometric();
    biometricEnabled = true;
    notifyListeners();
  }

  // Returns true = success, false = failed, null = cancelled or not enabled
  Future<bool?> biometricLogin() async {
    if (!biometricEnabled) return null;

    final result = await _biometricService.authenticate();

    if (result == true) {
      isLoggedIn = true;
      notifyListeners();
      return true;
    }

    return result;
  }

  Future<void> logout() async {
    await _storage.disableBiometric();
    isLoggedIn = false;
    biometricEnabled = false;
    userName = '';
    notifyListeners();
  }
}
