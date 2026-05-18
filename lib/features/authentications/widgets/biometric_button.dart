import 'package:flutter/material.dart';

class BiometricButton extends StatelessWidget {
  final VoidCallback? onTap;

  const BiometricButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'or continue with',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
            ),
            child: const Icon(Icons.fingerprint, color: Colors.white, size: 34),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Biometrics',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 12),
        ),
      ],
    );
  }
}
