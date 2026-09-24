import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shopping_cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, // Versi dinaikkan agar membuat ulang tabel
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        price REAL,
        imageUrl TEXT,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart (
        id TEXT PRIMARY KEY,
        product_id TEXT,
        name TEXT,
        price REAL,
        imageUrl TEXT,
        quantity INTEGER
      )
    ''');

    // Masukkan Produk Awal/Default ke Database
    await db.insert('products', {
      'id': 'p1',
      'name': 'Smartphone Pro',
      'price': 5000000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
      'description': 'Smartphone canggih dengan layar AMOLED dan kamera jernih.',
    });

    await db.insert('products', {
      'id': 'p2',
      'name': 'Laptop Ultra',
      'price': 12000000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
      'description': 'Laptop ringan berperforma tinggi untuk kerja dan game.',
    });

    await db.insert('products', {
      'id': 'p3',
      'name': 'Wireless Earbuds',
      'price': 750000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500',
      'description': 'Earbuds nirkabel dengan Noise Cancelling.',
    });

    await db.insert('products', {
      'id': 'p4',
      'name': 'Smartwatch Fit',
      'price': 1500000.0,
      'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      'description': 'Jam tangan pintar untuk memantau kesehatan dan olahraga.',
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS products');
    await db.execute('DROP TABLE IF EXISTS cart');
    await _createDB(db, newVersion);
  }

  // --- CRUD PRODUK ---
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }

  Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('products', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteProduct(String id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD KERANJANG ---
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await instance.database;
    return await db.query('cart');
  }

  Future<int> insertCart(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('cart', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCartQuantity(String productId, int quantity) async {
    final db = await instance.database;
    return await db.update(
      'cart',
      {'quantity': quantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> deleteCartItem(String productId) async {
    final db = await instance.database;
    return await db.delete('cart', where: 'product_id = ?', whereArgs: [productId]);
  }

  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart');
  }
}