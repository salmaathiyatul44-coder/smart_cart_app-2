class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'],
    );
  }
}