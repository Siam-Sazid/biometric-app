import 'package:flutter/material.dart';

import 'action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      (Icons.fingerprint_rounded, 'Biometrics', Color(0xFF2D5BE3)),
      (Icons.lock_reset_rounded, 'Change PIN', Color(0xFF00897B)),
      (Icons.devices_rounded, 'My Devices', Color(0xFF7B1FA2)),
      (Icons.history_rounded, 'Activity Log', Color(0xFFD84315)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        for (final (icon, label, color) in actions)
          ActionCard(icon: icon, label: label, color: color),
      ],
    );
  }
}
