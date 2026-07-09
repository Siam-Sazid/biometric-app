import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/biometric_auth_result.dart';
import '../controller/auth_controller.dart';
import 'pattern_lock_grid.dart';

const _accentColor = Color(0xFF2D5BE3);

/// Opens the custom in-app biometric + pattern-lock fallback sheet.
/// Returns true if the user authenticated successfully.
Future<bool> showBiometricAuthSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const BiometricAuthSheet(),
  );
  return result ?? false;
}

enum _SheetPhase { biometricInProgress, patternFallback, success, error }

class BiometricAuthSheet extends StatefulWidget {
  const BiometricAuthSheet({super.key});

  @override
  State<BiometricAuthSheet> createState() => _BiometricAuthSheetState();
}

class _BiometricAuthSheetState extends State<BiometricAuthSheet> {
  final _patternGridKey = GlobalKey<PatternLockGridState>();

  late _SheetPhase _phase;
  String _errorMessage = '';
  bool _patternError = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthController>();
    if (auth.biometricStatus.isEnabled) {
      _phase = _SheetPhase.biometricInProgress;
      WidgetsBinding.instance.addPostFrameCallback((_) => _attemptBiometric());
    } else if (auth.hasPatternLock) {
      _phase = _SheetPhase.patternFallback;
    } else {
      _phase = _SheetPhase.error;
      _errorMessage = 'No biometric or pattern set up yet.';
    }
  }

  Future<void> _attemptBiometric() async {
    final auth = context.read<AuthController>();
    final result = await auth.attemptBiometric();
    if (!mounted) return;

    if (result == BiometricAuthResult.success) {
      _onSuccess();
      return;
    }

    if (auth.hasPatternLock) {
      setState(() => _phase = _SheetPhase.patternFallback);
    } else {
      setState(() {
        _phase = _SheetPhase.error;
        _errorMessage = result == BiometricAuthResult.lockedOut
            ? 'Too many attempts. Biometric login is locked.'
            : 'Biometric authentication failed.';
      });
    }
  }

  Future<void> _onPatternComplete(List<int> nodes) async {
    final auth = context.read<AuthController>();
    final matches = await auth.verifyPattern(nodes.join(','));
    if (!mounted) return;

    if (matches) {
      _onSuccess();
    } else {
      setState(() => _patternError = true);
      _patternGridKey.currentState?.shakeError();
    }
  }

  void _onSuccess() {
    setState(() => _phase = _SheetPhase.success);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 14, 28, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              _buildPhaseContent(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseContent(AuthController auth) {
    switch (_phase) {
      case _SheetPhase.biometricInProgress:
        return _BiometricInProgressView(
          showPatternOption: auth.hasPatternLock,
          onUsePattern: () => setState(() => _phase = _SheetPhase.patternFallback),
        );
      case _SheetPhase.patternFallback:
        return _PatternFallbackView(
          gridKey: _patternGridKey,
          hasError: _patternError,
          onComplete: (nodes) {
            setState(() => _patternError = false);
            _onPatternComplete(nodes);
          },
        );
      case _SheetPhase.success:
        return const _SuccessView();
      case _SheetPhase.error:
        return _ErrorView(
          message: _errorMessage,
          onDismiss: () => Navigator.of(context).pop(false),
        );
    }
  }
}

class _BiometricInProgressView extends StatelessWidget {
  final bool showPatternOption;
  final VoidCallback onUsePattern;

  const _BiometricInProgressView({required this.showPatternOption, required this.onUsePattern});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: _accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.fingerprint, color: _accentColor, size: 44),
        ),
        const SizedBox(height: 20),
        const Text(
          'Verifying your identity…',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Follow the prompt on your device',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(color: _accentColor, strokeWidth: 2.5),
        ),
        if (showPatternOption) ...[
          const SizedBox(height: 24),
          TextButton(
            onPressed: onUsePattern,
            child: const Text('Use pattern instead'),
          ),
        ],
      ],
    );
  }
}

class _PatternFallbackView extends StatelessWidget {
  final GlobalKey<PatternLockGridState> gridKey;
  final bool hasError;
  final ValueChanged<List<int>> onComplete;

  const _PatternFallbackView({
    required this.gridKey,
    required this.hasError,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Draw your pattern', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(
          hasError ? 'Incorrect pattern, try again' : 'Connect at least 4 dots',
          style: TextStyle(
            fontSize: 13,
            color: hasError ? const Color(0xFFE0453C) : Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PatternLockGrid(key: gridKey, onComplete: onComplete),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: _accentColor, size: 64),
        SizedBox(height: 16),
        Text('Authenticated', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const _ErrorView({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFE0453C), size: 48),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: onDismiss,
            style: FilledButton.styleFrom(
              backgroundColor: _accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }
}
