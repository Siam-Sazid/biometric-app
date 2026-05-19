enum BiometricStatus {
  unknown,
  disabled,
  enabled,
  lockedOut;

  static BiometricStatus fromString(String? raw) => switch (raw) {
        null => unknown,
        'enabled' => enabled,
        'lockedOut' => lockedOut,
        _ => disabled,
      };

  bool get canAttempt => this == enabled;
  bool get isEnabled => this == enabled;

  // Valid transitions only; invalid calls are no-ops.
  BiometricStatus enable() =>
      this == disabled || this == unknown ? enabled : this;

  BiometricStatus lockOut() => this == enabled ? lockedOut : this;

  BiometricStatus reset() => disabled;
}
