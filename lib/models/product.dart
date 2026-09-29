class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }
}