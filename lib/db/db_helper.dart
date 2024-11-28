import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/note.dart';
import '../models/inventario.dart';
import '../models/venta.dart';
import '../models/anticretico.dart';
//import '../models/propiedad.dart';
import 'package:inmoviva/models/propiedad.dart';

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
      version: 4, // Cambiamos la versión a 3 para realizar la migración de la nueva columna
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
         
          await db.execute('''
          CREATE TABLE propiedades (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            fecha TEXT,
            direccion TEXT,
            precio REAL,
            estado TEXT,
            superficie REAL,
            descripcion TEXT,
            nro_habitaciones INTEGER,
            nro_banos INTEGER,
            imagen TEXT,
            tipo_propiedad_id INTEGER,
            FOREIGN KEY (tipo_propiedad_id) REFERENCES notes(id)
          )
          ''');
          
           await db.execute('''
          CREATE TABLE ventas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inventario_id INTEGER,
            comprador TEXT,
            precio REAL,
            metodo_pago TEXT,
            fecha_transaccion TEXT,
            documento_pdf TEXT,
            FOREIGN KEY (inventario_id) REFERENCES inventarios(id)
          )
          ''');

          await db.execute('''
          CREATE TABLE anticreticos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            inventario_id INTEGER,
            arrendatario TEXT,
            monto_anticretico REAL,
            metodo_pago TEXT,
            fecha_inicio TEXT,
            fecha_fin TEXT,
            contrato_pdf TEXT,
            FOREIGN KEY (inventario_id) REFERENCES inventarios(id)
          );
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
          // Verificar si la columna imagenes ya existe antes de agregarla
          var result = await db.rawQuery("PRAGMA table_info(inventarios)"); 
          var columnExists = result.any((column) => column['name'] == 'imagenes');
          
          if (!columnExists) {
            await db.execute('''
              ALTER TABLE inventarios ADD COLUMN imagenes TEXT;
            ''');
          }
        }

        if (oldVersion < 4) {
          // Crear las nuevas tablas si aún no existen
          await db.execute('''
            CREATE TABLE IF NOT EXISTS ventas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              inventario_id INTEGER,
              comprador TEXT,
              precio REAL,
              metodo_pago TEXT,
              fecha_transaccion TEXT,
              documento_pdf TEXT,
              FOREIGN KEY (inventario_id) REFERENCES inventarios(id)
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS anticreticos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              inventario_id INTEGER,
              arrendatario TEXT,
              monto_anticretico REAL,
              metodo_pago TEXT,
              fecha_inicio TEXT,
              fecha_fin TEXT,
              contrato_pdf TEXT,
              FOREIGN KEY (inventario_id) REFERENCES inventarios(id)
            )
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

  //para obtener las propiedades
  //Future<List<Map<String, dynamic>>> getPropiedades() async {
    //final db = await database;
    //return await db.query('propiedades');
  //}
  // Método en la clase DBHelper para obtener todas las propiedades
  Future<List<Propiedad>> getPropiedades() async {
    final db = await database; // Asegúrate de que esta variable esté definida correctamente.
    final List<Map<String, dynamic>> maps = await db.query('propiedades');

    return List.generate(maps.length, (i) {
      return Propiedad.fromMap(maps[i]); // Suponiendo que tienes este método en el modelo Propiedad.
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

  // Método para agregar una propiedad
  Future<int> addPropiedad(Map<String, dynamic> propiedad) async {
    final db = await database;
    return await db.insert('propiedades', propiedad);
  }

  // Método para editar una propiedad
  Future<int> updatePropiedad(int id, Map<String, dynamic> propiedad) async {
    final db = await database;
    return await db.update('propiedades', propiedad, where: 'id = ?', whereArgs: [id]);
  }

  // Método para eliminar una propiedad
  Future<int> deletePropiedad(int id) async {
    final db = await database;
    return await db.delete('propiedades', where: 'id = ?', whereArgs: [id]);
  }

  //metodos de ventas....
  Future<void> insertVenta(Venta venta) async {
  final db = await database;
  await db.insert(
    'ventas',
    venta.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}/*
Future<List<Venta>> getVentas() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('ventas');

  return List.generate(maps.length, (i) {
    return Venta.fromMap(maps[i]);
  });
}*/
Future<List<Venta>> getVentas() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('ventas');
  // Si no hay datos, devuelve una lista vacía
  return maps.isNotEmpty
      ? List.generate(maps.length, (i) => Venta.fromMap(maps[i]))
      : [];
}

Future<void> deleteVenta(int id) async {
  final db = await database;
  await db.delete(
    'ventas',
    where: 'id = ?',
    whereArgs: [id],
  );
}
//para anticretico......
Future<void> insertAnticretico(Anticretico anticretico) async {
  final db = await database;
  await db.insert(
    'anticreticos', // Nombre de la tabla
    anticretico.toMap(), // Convertimos el objeto a mapa
    conflictAlgorithm: ConflictAlgorithm.replace, // En caso de conflicto, reemplazamos el registro
  );
}
Future<List<Anticretico>> getAnticreticos() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('anticreticos'); // Consultamos la tabla 'anticreticos'

  // Si hay datos, los transformamos a una lista de objetos Anticretico
  return maps.isNotEmpty
      ? List.generate(maps.length, (i) => Anticretico.fromMap(maps[i]))
      : [];
}
Future<void> deleteAnticretico(int id) async {
  final db = await database;
  await db.delete(
    'anticreticos', // Nombre de la tabla
    where: 'id = ?', // Condición para identificar el anticrético a eliminar
    whereArgs: [id], // Argumento que pasamos para el lugar del '?'
  );
}



}
