import 'package:inmoviva/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Operation {
  static Future<Database> _openDB() async {
    return openDatabase(
        join(await getDatabasesPath(), 'notes.db'), //notes.db ?
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE notes (id INTEGER AUTO_INCREMENT PRIMARY KEY, nombre TEXT, descripcion TEXT)",
      );
    }, version: 1);
  }

  static Future<int> insert(Note tp) async {
    //void ?
    Database database = await _openDB();

    return database.insert("notes", tp.toMap());
  }

  static Future<List<Note>> notes() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> notesMap =
        await database.query("notes");

    for (var n in notesMap) {
      print("___" + n['nombre']);
    }
    return List.generate(
        notesMap.length,
        (i) => Note(
            id: notesMap[i]['id'],
            nombre: notesMap[i]['nombre'],
            descripcion: notesMap[i]['descripcion']));
  }
}
