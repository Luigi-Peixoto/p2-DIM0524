import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = 'https://fakestoreapi.com';

  static Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token'] as String?;
      }

      return null;
    } catch (e, stack) {
      print('ERRO na requisição: $e');
      print('Stack: $stack');
      return null;
    }
  }
}
