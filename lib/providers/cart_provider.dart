import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  Future<void> fetchCartItems() async {
    _items = await DBHelper.instance.getCartItems();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    final index = _items.indexWhere((item) => item.productId == product.id);

    if (index >= 0) {
      _items[index].quantity += 1;
      await DBHelper.instance.updateCartQuantity(product.id, _items[index].quantity);
    } else {
      final newItem = CartItem(
        id: DateTime.now().toString(),
        productId: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        quantity: 1,
      );
      _items.add(newItem);
      await DBHelper.instance.insertCartItem(newItem);
    }
    notifyListeners();
  }

  Future<void> updateQuantity(String productId, int delta) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final newQuantity = _items[index].quantity + delta;
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
        await DBHelper.instance.updateCartQuantity(productId, newQuantity);
      } else {
        await DBHelper.instance.deleteCartItem(productId);
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    await DBHelper.instance.clearCart();
    _items.clear();
    notifyListeners();
  }
}