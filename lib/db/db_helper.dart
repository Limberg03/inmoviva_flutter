import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'; // Para detectar la plataforma
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Para plataformas de escritorio
import '../models/inventario.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Inicializar sqflite para Windows/Linux
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();  // Inicializa el entorno FFI
      databaseFactory = databaseFactoryFfi;  // Asigna la fábrica de base de datos FFI
    }

    // Obtener la ruta de la base de datos
    String path = await getDatabasesPath();
    String dbPath = join(path, 'inventarios.db');

    // Abrir la base de datos
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE inventarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha_publicacion TEXT,
            direccion TEXT,
            precio REAL,
            estado TEXT,
            superficie REAL,
            descripcion TEXT,
            nro_habitaciones INTEGER,
            nro_banos INTEGER,
            imagen TEXT
          )
        ''');
      },
    );
  }

  // Insertar un nuevo inventario
  Future<void> insertInventario(Inventario inventario) async {
    final db = await database;
    await db.insert(
      'inventarios',
      inventario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los inventarios
  Future<List<Inventario>> getInventarios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('inventarios');

    return List.generate(maps.length, (i) {
      return Inventario.fromMap(maps[i]);
    });
  }

  // Actualizar un inventario existente
  Future<void> updateInventario(Inventario inventario) async {
    final db = await database;
    await db.update(
      'inventarios',
      inventario.toMap(),
      where: 'id = ?',
      whereArgs: [inventario.id],
    );
  }

  // Eliminar un inventario
  Future<void> deleteInventario(int id) async {
    final db = await database;
    await db.delete(
      'inventarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
