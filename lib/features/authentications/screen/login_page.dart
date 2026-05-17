import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_page/screen/home_page.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => autoBiometricLogin());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> autoBiometricLogin() async {
    final auth = context.read<AuthController>();
    final success = await auth.biometricLogin();

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  Future<void> _onLogin() async {
    final auth = context.read<AuthController>();
    final navigator = Navigator.of(context);

    final success = await auth.login(
      emailController.text,
      passwordController.text,
    );

    if (!success || !mounted) return;

    final enableBiometric = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enable Biometric Login'),
        content: const Text(
          'Would you like to use fingerprint or face ID to log in next time?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (enableBiometric == true) {
      await auth.enableBiometric();
    }

    navigator.pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthController, bool>((a) => a.isLoading);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onLogin,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
