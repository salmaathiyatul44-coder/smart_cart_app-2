import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<Product> _products = [];
  List<CartItem> _cartItems = [];

  List<Product> get products => [..._products];
  List<CartItem> get cartItems => [..._cartItems];

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> fetchAndSetData() async {
    final productList = await DBHelper.instance.getProducts();
    _products = productList.map((item) => Product(
      id: item['id'],
      name: item['name'],
      price: (item['price'] as num).toDouble(),
      imageUrl: item['imageUrl'],
      description: item['description'] ?? '',
    )).toList();

    final cartList = await DBHelper.instance.getCartItems();
    _cartItems = cartList.map((item) => CartItem(
      id: item['id'],
      productId: item['product_id'],
      name: item['name'],
      price: (item['price'] as num).toDouble(),
      imageUrl: item['imageUrl'],
      quantity: item['quantity'],
    )).toList();

    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    final index = _cartItems.indexWhere((item) => item.productId == product.id);

    if (index >= 0) {
      final newQuantity = _cartItems[index].quantity + 1;
      _cartItems[index].quantity = newQuantity;
      await DBHelper.instance.updateCartQuantity(product.id, newQuantity);
    } else {
      final newItem = CartItem(
        id: DateTime.now().toString(),
        productId: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        quantity: 1,
      );
      _cartItems.add(newItem);
      await DBHelper.instance.insertCart({
        'id': newItem.id,
        'product_id': newItem.productId,
        'name': newItem.name,
        'price': newItem.price,
        'imageUrl': newItem.imageUrl,
        'quantity': newItem.quantity,
      });
    }

    notifyListeners();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
        await DBHelper.instance.deleteCartItem(productId);
      } else {
        _cartItems[index].quantity = newQuantity;
        await DBHelper.instance.updateCartQuantity(productId, newQuantity);
      }
      notifyListeners();
    }
  }

  Future<void> addProduct(String name, double price, String imageUrl, String description) async {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: name,
      price: price,
      imageUrl: imageUrl,
      description: description,
    );
    _products.add(newProduct);
    await DBHelper.instance.insertProduct({
      'id': newProduct.id,
      'name': newProduct.name,
      'price': newProduct.price,
      'imageUrl': newProduct.imageUrl,
      'description': newProduct.description,
    });
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((prod) => prod.id == id);
    _cartItems.removeWhere((item) => item.productId == id);
    await DBHelper.instance.deleteProduct(id);
    await DBHelper.instance.deleteCartItem(id);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await DBHelper.instance.clearCart();
    notifyListeners();
  }
}