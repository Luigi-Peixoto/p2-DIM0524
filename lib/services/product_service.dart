import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:p2_dim0524/modules/products/models/product.dart';

class ProductService {
  static const _baseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao buscar produtos: ${response.statusCode}');
  }
}
