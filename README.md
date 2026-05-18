# Biometric App

A Flutter application that demonstrates secure authentication using device biometrics (fingerprint / face ID) combined with traditional email and password login.

## Goal

The main goal is to provide a seamless and secure login experience — users sign in with credentials on first use, then opt into biometric authentication for all future sessions. Credentials and biometric preferences are stored securely on-device using encrypted storage.

## Features

- Email and password login
- Optional biometric login (fingerprint / face ID) after first sign-in
- Secure on-device storage of the biometric preference
- Auto-triggers biometric prompt on app launch if previously enabled
- Professional UI with a home dashboard showing security status and recent activity

## Tech Stack

| Package | Purpose |
|---|---|
| `local_auth ^3.0.1` | Biometric authentication |
| `flutter_secure_storage ^10.2.0` | Encrypted on-device storage |
| `provider ^6.1.5+1` | State management |

## Project Structure

```
lib/
├── main.dart
├── core/services/          # BiometricService, SecureStorageService
└── features/
    ├── authentications/    # LoginPage, AuthController, login widgets
    └── home_page/          # HomePage, home widgets
```

## Getting Started

```bash
flutter pub get
flutter run
```

Requires a physical device or emulator with biometric hardware enrolled for the biometric flow to work.
