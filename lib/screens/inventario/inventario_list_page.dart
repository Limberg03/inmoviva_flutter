import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:inmoviva/models/note.dart'; // Importamos el modelo de Note
import 'inventario_form_page.dart';

class InventarioListPage extends StatefulWidget {
  @override
  _InventarioListPageState createState() => _InventarioListPageState();
}

class _InventarioListPageState extends State<InventarioListPage> {
  List<Inventario> inventarios = [];
  List<Inventario> filteredInventarios = []; // Lista filtrada
  final DBHelper _dbHelper = DBHelper();
  String searchQuery = ''; // Término de búsqueda

  @override
  void initState() {
    super.initState();
    _loadInventarios(); // Cargar los inventarios desde la base de datos
  }

  Future<void> _loadInventarios() async {
    List<Inventario> loadedInventarios = await _dbHelper.getInventarios();
    setState(() {
      inventarios = loadedInventarios;
      filteredInventarios = loadedInventarios; // Inicializar la lista filtrada
    });
  }

  void _filterInventarios(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredInventarios = inventarios;
      } else {
        filteredInventarios = inventarios.where((inventario) {
          final direccionLower = inventario.direccion?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return direccionLower.contains(searchLower);
        }).toList();
      }
    });
  }

  // Obtener el tipo de propiedad desde SQLite
  Future<Note?> _getTipoPropiedad(int? id) async {
    if (id == null) return null;
    return await _dbHelper.getTipoPropiedadById(id); // Usamos la función de SQLite
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventarios"),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar por dirección',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: (value) {
                _filterInventarios(value); // Filtrar cuando el usuario escribe
              },
            ),
          ),
          Expanded(
            child: filteredInventarios.isEmpty
                ? Center(child: Text('No hay inventarios'))
                : ListView.builder(
                    itemCount: filteredInventarios.length,
                    itemBuilder: (context, index) {
                      final inventario = filteredInventarios[index];
                      return FutureBuilder<Note?>(
                        future: _getTipoPropiedad(inventario.tipoPropiedadId), // Obtener el tipo de propiedad
                        builder: (context, snapshot) {
                          final tipoPropiedad = snapshot.data;
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            elevation: 4, // Añade sombra
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey[300],
                                    ),
                                    child: inventario.imagen != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(inventario.imagen!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(Icons.image, color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          inventario.direccion ?? 'Sin dirección',
                                          style: TextStyle(
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Precio: ${inventario.precio?.toStringAsFixed(2) ?? 'No disponible'} USD',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Estado: ${inventario.estado ?? 'No disponible'}',
                                          style: TextStyle(
                                            color: Colors.orange[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (tipoPropiedad != null)
                                          Text(
                                            'Tipo de Propiedad: ${tipoPropiedad.nombre}',
                                            style: TextStyle(
                                              color: Colors.purple[700],
                                              fontSize: 14,
                                            ),
                                          ),
                                        Text(
                                          'Superficie: ${inventario.superficie?.toStringAsFixed(2) ?? 'No disponible'} m²',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Habitaciones: ${inventario.nroHabitaciones ?? 'No disponible'}',
                                          style: TextStyle(
                                            color: Colors.teal,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Baños: ${inventario.nroBanos ?? 'No disponible'}',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue[700]),
                                    onPressed: () async {
                                      final updatedInventario = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InventarioFormPage(
                                            inventario: inventario,
                                          ),
                                        ),
                                      );
                                      if (updatedInventario != null) {
                                        _loadInventarios();
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red[700]),
                                    onPressed: () {
                                      _dbHelper.deleteInventario(inventario.id!);
                                      _loadInventarios();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newInventario = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventarioFormPage(),
            ),
          );
          if (newInventario != null) {
            _loadInventarios();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[800],
      ),
    );
  }
}
