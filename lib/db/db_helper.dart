import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/note.dart';
import '../models/inventario.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Inicializamos la base de datos usando FFI si estamos en Windows o Linux
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Obtener la ruta de la base de datos
    String path = await getDatabasesPath();
    String dbPath = join(path, 'inventarios.db');

    // Abrir la base de datos y aplicar migraciones si es necesario
    return await openDatabase(
      dbPath,
      version: 3, // Cambiamos la versión a 3 para realizar la migración de la nueva columna
      onCreate: (db, version) async {
        // Creamos las tablas iniciales
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            descripcion TEXT
          )
        ''');

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
            imagenes TEXT, -- Nueva columna para almacenar las imágenes
            tipo_propiedad_id INTEGER,
            FOREIGN KEY (tipo_propiedad_id) REFERENCES notes(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migración de la versión 1 a la 2
          await db.execute('''
            ALTER TABLE inventarios ADD COLUMN tipo_propiedad_id INTEGER;
          ''');
        }
        if (oldVersion < 3) {
          // Migración de la versión 2 a la 3 para añadir la columna imagenes
          await db.execute('''
            ALTER TABLE inventarios ADD COLUMN imagenes TEXT;
          ''');
        }
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

  // Obtener el tipo de propiedad (Note) por su ID
  Future<Note?> getTipoPropiedadById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first); // Devolvemos el Note si existe
    } else {
      return null; // Si no existe, devolvemos null
    }
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
