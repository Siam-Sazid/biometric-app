import 'package:flutter/material.dart';

import 'activity_tile.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    const activities = [
      (Icons.login_rounded, 'Login via Biometrics', 'Today, 9:41 AM', Color(0xFF2D5BE3)),
      (Icons.shield_outlined, 'Security check passed', 'Today, 9:40 AM', Color(0xFF00897B)),
      (Icons.fingerprint_rounded, 'Biometric setup updated', 'Yesterday, 6:12 PM', Color(0xFF7B1FA2)),
      (Icons.devices_rounded, 'New device authorized', 'May 15, 3:24 PM', Color(0xFFD84315)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < activities.length; i++) ...[
            ActivityTile(
              icon: activities[i].$1,
              title: activities[i].$2,
              time: activities[i].$3,
              color: activities[i].$4,
            ),
            if (i < activities.length - 1)
              Divider(height: 1, indent: 70, color: Colors.grey.shade100),
          ],
        ],
      ),
    );
  }
}
