import 'package:flutter/material.dart';
import 'package:p2_dim0524/modules/cart/cart_page.dart';
import 'package:p2_dim0524/modules/login/login_page.dart';
import 'package:p2_dim0524/modules/products/models/product.dart';
import 'package:p2_dim0524/modules/products/widgets/product_card.dart';
import 'package:p2_dim0524/services/cart_service.dart';
import 'package:p2_dim0524/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> _produtos = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _buscarProdutos();
  }

  Future<void> _buscarProdutos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final produtos = await ProductService.fetchProducts();
      setState(() {
        _produtos = produtos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Sem conexão com a internet.';
        _carregando = false;
      });
    }
  }

  Future<void> _fazerLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F8),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Loja Online',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_erro!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _buscarProdutos,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _produtos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final produto = _produtos[index];
        return ProductCard(
          nome: produto.title,
          descricao: produto.description,
          preco: produto.precoFormatado,
          imagemUrl: produto.image,
          onComprar: () {
            CartService.instance.add(produto);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${produto.title} adicionado ao carrinho!'),
                backgroundColor: Colors.black87,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}
