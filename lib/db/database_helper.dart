import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inmoviva/models/ciudad.dart'; // Asegúrate de importar tu modelo

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inmoviva.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ciudades (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT
      )
    ''');
  }

  // Funciones CRUD para Ciudad

  Future<void> insertCiudad(Ciudad ciudad) async {
    final Database db = await database;
    await db.insert(
      'ciudades',
      ciudad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ciudad>> getCiudades() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ciudades');
    return List.generate(maps.length, (i) {
      return Ciudad.fromMap(maps[i]);
    });
  }

  Future<void> updateCiudad(Ciudad ciudad) async {
    final Database db = await database;
    await db.update(
      'ciudades',
      ciudad.toMap(),
      where: 'id = ?',
      whereArgs: [ciudad.id],
    );
  }

  Future<void> deleteCiudad(Ciudad ciudad) async {
    final Database db = await database;
    await db.delete(
      'ciudades',
      where: 'id = ?',
      whereArgs: [ciudad.id],
    );
  }
}

