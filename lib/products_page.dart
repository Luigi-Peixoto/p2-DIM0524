import 'package:flutter/material.dart';
import 'package:p2_dim0524/product_card.dart';

import 'login_page.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  final List<Map<String, dynamic>> produtos = const [
    {
      'nome': 'Notebook',
      'descricao': 'Notebook 15" com processador Intel i7',
      'preco': 'R\$ 3500.00',
    },
    {
      'nome': 'Mouse',
      'descricao': 'Mouse sem fio com bateria de longa duração',
      'preco': 'R\$ 85.00',
    },
    {
      'nome': 'Teclado',
      'descricao': 'Teclado RGB com switch mecânico',
      'preco': 'R\$ 450.00',
    },
    {
      'nome': 'Monitor',
      'descricao': 'Monitor Full HD com painel IPS',
      'preco': 'R\$ 1200.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F8),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,

        title: const Text(
          'Loja Online',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),

          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: produtos.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),

        itemBuilder: (context, index) {
          final produto = produtos[index];

          return ProductCard(
            nome: produto['nome'],
            descricao: produto['descricao'],
            preco: produto['preco'],
          );
        },
      ),
    );
  }
}