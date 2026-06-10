import 'package:p2_dim0524/modules/cart/models/cart_item.dart';
import 'package:p2_dim0524/modules/products/models/product.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  void add(Product product) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void increment(int productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) _items[index].quantity++;
  }

  void decrement(int productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  void remove(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
  }
}
