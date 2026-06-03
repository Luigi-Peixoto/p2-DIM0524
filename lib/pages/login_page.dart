import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2_dim0524/services/auth_service.dart';
import 'package:p2_dim0524/pages/products_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _credenciaisInvalidas = false;
  bool _carregando = false;

  Future<void> fazerLogin() async {
    setState(() {
      _credenciaisInvalidas = false;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final token = await AuthService.login(
      _userController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _carregando = false);

    if (token != null) {
      // Salva credenciais no dispositivo para login automático
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _userController.text.trim());
      await prefs.setString('password', _passwordController.text);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductPage()),
      );
    } else {
      setState(() => _credenciaisInvalidas = true);
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Minha aplicação',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 32),

                // Usuário
                TextFormField(
                  controller: _userController,
                  decoration: InputDecoration(
                    hintText: 'usuário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'esse campo é obrigatório';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'senha',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'esse campo é obrigatório';
                    }
                    return null;
                  },
                ),

                // Mensagem de erro
                if (_credenciaisInvalidas) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Credenciais inválidas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _carregando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Não tem uma conta? Cadastre-se',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}