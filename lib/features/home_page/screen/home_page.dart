import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentications/controller/auth_controller.dart';
import '../../authentications/screen/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<AuthController>().logout();

            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
