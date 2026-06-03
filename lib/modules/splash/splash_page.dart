import 'package:flutter/material.dart';
import 'package:p2_dim0524/modules/login/login_page.dart';
import 'package:p2_dim0524/modules/products/products_page.dart';
import 'package:p2_dim0524/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _verificarLoginSalvo();
  }

  Future<void> _verificarLoginSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
      final token = await AuthService.login(username, password);

      if (!mounted) return;

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductPage()),
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF3F0F8),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
