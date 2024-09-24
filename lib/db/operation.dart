import 'dart:io';

import 'package:inmoviva/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Operation {
  static Future<Database> _openDB() async {
    // Verifica si estás en un entorno de escritorio (Windows, macOS, Linux)
    if (isDesktop()) {
    // Inicializa sqflite_common_ffi para los entornos de escritorio
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    }

    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE notes (id INTEGER PRIMARY KEY, nombre TEXT, descripcion TEXT)",
        );
      },
      version: 1,
    );
  }

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
    return database.update("notes",tp.toMap(), where: 'id=? ', whereArgs: [tp.id]);
  }


  static Future<List<Note>> searchNotes(String query) async {
  Database database = await _openDB();
  final List<Map<String, dynamic>> notesMap = await database.query(
    "notes",
    where: "nombre LIKE ?",
    whereArgs: ['%$query%'],
  );

  return List.generate(
    notesMap.length,
    (i) => Note(
      id: notesMap[i]['id'],
      nombre: notesMap[i]['nombre'],
      descripcion: notesMap[i]['descripcion'],
    ),
  );
}

  static Future<List<Note>> notes() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> notesMap = await database.query("notes");

    for (var n in notesMap) {
      print("___" + n['nombre']);
    }

    return List.generate(
      notesMap.length,
      (i) => Note(
        id: notesMap[i]['id'],
        nombre: notesMap[i]['nombre'],
        descripcion: notesMap[i]['descripcion'],
      ),
    );
  }

  static bool isDesktop() {
    // Detecta si es un entorno de escritorio
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}
