import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentications/controller/auth_controller.dart';

class SecurityStatusCard extends StatelessWidget {
  const SecurityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricEnabled =
        context.select<AuthController, bool>((a) => a.biometricEnabled);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A3A8F), Color(0xFF2D5BE3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D5BE3).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.verified_user_outlined,
                color: Colors.white, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Status',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Account Protected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.fingerprint,
                        color: Colors.white70, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      biometricEnabled
                          ? 'Biometric auth enabled'
                          : 'Biometric auth disabled',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: biometricEnabled
                  ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: biometricEnabled
                    ? const Color(0xFF66BB6A)
                    : Colors.white38,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  biometricEnabled
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: biometricEnabled
                      ? const Color(0xFF66BB6A)
                      : Colors.white54,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  biometricEnabled ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: biometricEnabled
                        ? const Color(0xFF66BB6A)
                        : Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
