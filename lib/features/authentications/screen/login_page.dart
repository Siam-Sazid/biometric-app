import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_page/screen/home_page.dart';
import '../controller/auth_controller.dart';
import '../widgets/biometric_button.dart';
import '../widgets/login_form_card.dart';
import '../widgets/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoBiometricLogin());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _autoBiometricLogin() async {
    final auth = context.read<AuthController>();
    final result = await auth.biometricLogin();
    if (!mounted) return;
    if (result == true) {
      _goHome();
    } else if (result == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Biometric authentication failed. Please sign in manually.'),
        ),
      );
    }
  }

  Future<void> _onLogin() async {
    final auth = context.read<AuthController>();
    final navigator = Navigator.of(context);

    final success = await auth.login(_emailController.text, _passwordController.text);
    if (!success || !mounted) return;

    final enableBiometric = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enable Biometric Login'),
        content: const Text('Use fingerprint or face ID to sign in next time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enable'),
          ),
        ],
      ),
    );

    if (enableBiometric == true) await auth.enableBiometric();
    navigator.pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthController, bool>((a) => a.isLoading);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B4B), Color(0xFF1A3A8F), Color(0xFF2D5BE3)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: 40),
                  LoginFormCard(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    isLoading: isLoading,
                    onLogin: _onLogin,
                  ),
                  const SizedBox(height: 28),
                  BiometricButton(onTap: isLoading ? null : _autoBiometricLogin),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
