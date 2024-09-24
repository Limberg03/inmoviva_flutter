import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/models/note.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MyList();
  }
}

class _MyList extends StatefulWidget {
  @override
  State<_MyList> createState() => _MyListState();
}

class _MyListState extends State<_MyList> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  String searchQuery = '';

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Tipo de Propiedad"),
        backgroundColor: Colors.blue[800],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle:
                    TextStyle(color: Colors.grey[400]), // Color del texto hint
                filled: true, // Habilita el color de fondo
                fillColor: Colors.white, // Color de fondo
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Bordes redondeados
                  borderSide:
                      BorderSide(color: Colors.blue[700]!, width: 1), // Borde
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      25.0), // Bordes redondeados al enfocar
                  borderSide: BorderSide(
                      color: Colors.blue[800]!, width: 2), // Borde al enfocar
                ),
                prefixIcon: Icon(Icons.search,
                    color: Colors.blue[800]), // Icono de búsqueda
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterNotes();
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredNotes.length,
          itemBuilder: (_, i) => _createItem(i),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
        onPressed: () {
          Navigator.pushNamed(context, '/save', arguments: Note.empty())
              .then((value) => _loadData());
        },
      ),
    );
  }

  _loadData() async {
    List<Note> auxNote = await Operation.notes();
    setState(() {
      notes = auxNote;
      filteredNotes = auxNote; // Inicializa la lista filtrada
    });
  }

  _filterNotes() {
    if (searchQuery.isEmpty) {
      filteredNotes = notes;
    } else {
      filteredNotes = notes
          .where((note) =>
              note.nombre.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  _createItem(int i) {
    return Dismissible(
      key: Key(filteredNotes[i].id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        // Eliminar la nota de la lista local inmediatamente
        final removedNote =
            notes[i]; // Guarda la nota eliminada para el Snackbar
        setState(() {
          notes.removeAt(i); // Elimina la nota de la lista local
        });

        // Eliminar la nota de la base de datos (esto puede ser asincrónico, pero no afecta la lista)
        Operation.delete(removedNote);

        // Muestra un mensaje al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tipo de Propiedad eliminado')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            filteredNotes[i].nombre,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            filteredNotes[i].descripcion ?? 'Sin descripción',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.pushNamed(context, '/save', arguments: filteredNotes[i])
                  .then((value) => _loadData());
            },
          ),
        ),
      ),
    );
  }
}
