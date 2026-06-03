import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2_dim0524/pages/login_page.dart';
import 'package:p2_dim0524/pages/products_page.dart';
import 'package:p2_dim0524/services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
    );
  }
}

/// Tela inicial que verifica se há credenciais salvas.
/// Se houver, tenta autenticar automaticamente e vai para ProductPage.
/// Caso contrário, vai para LoginPage.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      // Tenta autenticar com as credenciais salvas
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

    // Sem credenciais salvas ou autenticação falhou
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
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}