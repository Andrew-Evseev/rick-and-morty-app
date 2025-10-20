import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalStorage {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'rick_morty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            name TEXT,
            status TEXT,
            species TEXT,
            image TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(Map<String, dynamic> character) async {
    final db = await database;
    await db.insert(
      'favorites',
      character,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }
}
