import 'package:flutter/material.dart';

import '../widgets/home_sliver_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/section_title.dart';
import '../widgets/security_status_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: CustomScrollView(
        slivers: [
          const HomeSliverHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SecurityStatusCard(),
                const SizedBox(height: 28),
                const SectionTitle('Quick Actions'),
                const SizedBox(height: 14),
                const QuickActionsGrid(),
                const SizedBox(height: 28),
                const SectionTitle('Recent Activity'),
                const SizedBox(height: 14),
                const RecentActivityCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
