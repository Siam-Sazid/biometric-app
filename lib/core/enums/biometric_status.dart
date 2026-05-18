enum BiometricStatus {
  unknown,
  disabled,
  enabled,
  lockedOut;

  static BiometricStatus fromString(String? raw) => switch (raw) {
        'enabled' => enabled,
        'lockedOut' => lockedOut,
        _ => disabled,
      };

  bool get canAttempt => this == enabled;
  bool get isEnabled => this == enabled;
}
