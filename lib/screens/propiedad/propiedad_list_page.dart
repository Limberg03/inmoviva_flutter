import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/propiedad.dart';
import 'package:inmoviva/screens/propiedad/propiedad_form_page.dart'; // Asegúrate de tener la ruta correcta.

class PropiedadListPage extends StatefulWidget {
  @override
  _PropiedadListPageState createState() => _PropiedadListPageState();
}

class _PropiedadListPageState extends State<PropiedadListPage> {
  List<Propiedad> propiedades = [];
  List<Propiedad> filteredPropiedades = [];
  String searchQuery = '';
  final DBHelper _dbHelper = DBHelper();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPropiedades();
  }

  Future<void> _loadPropiedades() async {
    setState(() {
      isLoading = true;
    });

    List<Propiedad> loadedPropiedades = await _dbHelper.getPropiedades();
    setState(() {
      propiedades = loadedPropiedades;
      filteredPropiedades = loadedPropiedades;
      isLoading = false;
    });
  }

  void _filterPropiedades() {
    if (searchQuery.isEmpty) {
      filteredPropiedades = propiedades;
    } else {
      filteredPropiedades = propiedades
          .where((propiedad) => propiedad.direccion!
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _confirmDelete(BuildContext context, int propiedadId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar esta propiedad?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () {
                Navigator.of(context).pop();
                _dbHelper.deletePropiedad(propiedadId);
                _loadPropiedades();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToFormPage({Propiedad? propiedad}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropiedadFormPage(propiedad: propiedad),
      ),
    );

    if (result != null) {
      _loadPropiedades();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Propiedades"),
        backgroundColor: Colors.blue[800],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue[700]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.blue[800]),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterPropiedades();
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredPropiedades.isEmpty
              ? Center(child: Text('No hay propiedades disponibles'))
              : Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: filteredPropiedades.length,
                    itemBuilder: (_, i) => _createItem(i),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToFormPage(); // Navegar a la página de agregar nueva propiedad
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }

  Widget _createItem(int i) {
    final propiedad = filteredPropiedades[i];
    return Dismissible(
      key: Key(propiedad.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        final removedPropiedad = propiedades[i];
        setState(() {
          propiedades.removeAt(i);
        });

        _dbHelper.deletePropiedad(removedPropiedad.id!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Propiedad eliminada')),
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
          leading: _buildImageThumbnail(propiedad),
          title: Text(
            propiedad.direccion ?? 'Sin dirección',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${propiedad.precio?.toStringAsFixed(2) ?? 'No disponible'} USD',
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _navigateToFormPage(propiedad: propiedad);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(Propiedad propiedad) {
    return propiedad.imagen != null && propiedad.imagen!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              File(propiedad.imagen!),
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          )
        : Icon(Icons.image, color: Colors.grey[600]);
  }
}
