import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentications/controller/auth_controller.dart';
import '../../authentications/screen/login_page.dart';

class HomeSliverHeader extends StatelessWidget {
  const HomeSliverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 148,
      pinned: true,
      backgroundColor: const Color(0xFF0D1B4B),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B4B), Color(0xFF2D5BE3)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(Icons.person_outline, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Consumer<AuthController>(
                          builder: (context, auth, _) => Text(
                            auth.userName.isEmpty ? 'User' : auth.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<AuthController>(
                    builder: (context, auth, _) => IconButton(
                      tooltip: 'Sign out',
                      icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                      onPressed: () async {
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }
}
