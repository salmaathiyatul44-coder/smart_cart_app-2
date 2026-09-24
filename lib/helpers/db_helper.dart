import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('toko_baju.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabel master_products sesuai kriteria LKPD 4
    await db.execute('''
      CREATE TABLE master_products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT
      )
    ''');

    // Tabel local_cart sesuai kriteria LKPD 4
    await db.execute('''
      CREATE TABLE local_cart (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT,
        quantity INTEGER NOT NULL
      )
    ''');

    // Katalog Produk Baju & Fashion
    await db.insert('master_products', {
      'id': 'b1',
      'name': 'Kaos Oversize Casual',
      'price': 85000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=600',
    });

    await db.insert('master_products', {
      'id': 'b2',
      'name': 'Jaket Denim Vintage',
      'price': 245000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=600',
    });

    await db.insert('master_products', {
      'id': 'b3',
      'name': 'Kemeja Flanel Premium',
      'price': 135000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=600',
    });

    await db.insert('master_products', {
      'id': 'b4',
      'name': 'Hoodie Fleece Plain',
      'price': 175000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?q=80&w=600',
    });
  }

  // --- CRUD MASTER PRODUCTS ---
  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final result = await db.query('master_products');
    return result.map((json) => Product.fromMap(json)).toList();
  }

  // --- CRUD LOCAL CART ---
  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final result = await db.query('local_cart');
    return result.map((json) => CartItem.fromMap(json)).toList();
  }

  Future<void> insertCartItem(CartItem item) async {
    final db = await instance.database;
    await db.insert(
      'local_cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    final db = await instance.database;
    await db.update(
      'local_cart',
      {'quantity': quantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> deleteCartItem(String productId) async {
    final db = await instance.database;
    await db.delete('local_cart', where: 'product_id = ?', whereArgs: [productId]);
  }

  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('local_cart');
  }
}