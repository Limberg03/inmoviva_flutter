import 'dart:io';
import 'package:inmoviva/models/note.dart';
import 'package:inmoviva/models/ciudad.dart'; // Importa la clase Ciudad
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Operation {
  static Future<Database> _openDB() async {
    // Verifica si estás en un entorno de escritorio (Windows, macOS, Linux)
    if (isDesktop()) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE notes (id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT)"
        );
        db.execute(
          "CREATE TABLE ciudades (id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT)" // Nueva tabla ciudades
        );
      },
      version: 1,
    );
  }

  // Métodos CRUD para 'Note'
  static Future<int> insert(Note tp) async {
    Database database = await _openDB();
    return database.insert("notes", tp.toMap());
  }

  static Future<int> delete(Note tp) async {
    Database database = await _openDB();
    return database.delete("notes", where: 'id=? ', whereArgs: [tp.id]);
  }

  static Future<int> update(Note tp) async {
    Database database = await _openDB();
    return database.update("notes", tp.toMap(), where: 'id=? ', whereArgs: [tp.id]);
  }

  static Future<List<Note>> notes() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> notesMap = await database.query("notes");
    return List.generate(
      notesMap.length,
      (i) => Note(
        id: notesMap[i]['id'],
        nombre: notesMap[i]['nombre'],
        descripcion: notesMap[i]['descripcion'],
      ),
    );
  }

  // Nuevos métodos CRUD para 'Ciudad'
  static Future<int> insertCiudad(Ciudad ciudad) async {
    Database database = await _openDB();
    return database.insert("ciudades", ciudad.toMap());
  }

  static Future<int> deleteCiudad(Ciudad ciudad) async {
    Database database = await _openDB();
    return database.delete("ciudades", where: 'id=? ', whereArgs: [ciudad.id]);
  }

  static Future<int> updateCiudad(Ciudad ciudad) async {
    Database database = await _openDB();
    return database.update("ciudades", ciudad.toMap(), where: 'id=? ', whereArgs: [ciudad.id]);
  }

  static Future<List<Ciudad>> ciudades() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> ciudadesMap = await database.query("ciudades");
    return List.generate(
      ciudadesMap.length,
      (i) => Ciudad(
        id: ciudadesMap[i]['id'],
        nombre: ciudadesMap[i]['nombre'],
        descripcion: ciudadesMap[i]['descripcion'],
      ),
    );
  }

  static bool isDesktop() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}
