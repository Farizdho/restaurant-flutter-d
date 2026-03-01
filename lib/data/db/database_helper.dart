import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/favorite_restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableName = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'restaurant.db');

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  // ========================
  // INSERT
  // ========================
  Future<void> insertFavorite(FavoriteRestaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ========================
  // GET ALL
  // ========================
  Future<List<FavoriteRestaurant>> getFavorites() async {
    final db = await database;
    final result = await db.query(_tableName);

    return result.map((e) => FavoriteRestaurant.fromMap(e)).toList();
  }

  // ========================
  // GET BY ID
  // ========================
  Future<FavoriteRestaurant?> getFavoriteById(String id) async {
    final db = await database;
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return FavoriteRestaurant.fromMap(result.first);
    }
    return null;
  }

  // ========================
  // DELETE
  // ========================
  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
