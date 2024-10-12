import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:inmoviva/models/note.dart';
import 'inventario_form_page.dart';

class InventarioListPage extends StatefulWidget {
  @override
  _InventarioListPageState createState() => _InventarioListPageState();
}

class _InventarioListPageState extends State<InventarioListPage> {
  List<Inventario> inventarios = [];
  List<Inventario> filteredInventarios = [];
  final DBHelper _dbHelper = DBHelper();
  String searchQuery = '';
  bool isLoading = false; // Para gestionar la carga de inventarios

  @override
  void initState() {
    super.initState();
    _loadInventarios(); 
  }

  Future<void> _loadInventarios() async {
    setState(() {
      isLoading = true; // Mostrar indicador de carga
    });

    List<Inventario> loadedInventarios = await _dbHelper.getInventarios();
    setState(() {
      inventarios = loadedInventarios;
      filteredInventarios = loadedInventarios;
      isLoading = false; // Ocultar indicador de carga
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

  Future<Note?> _getTipoPropiedad(int? id) async {
    if (id == null) return null;
    return await _dbHelper.getTipoPropiedadById(id);
  }

  // Confirmación de eliminación
  void _confirmDelete(BuildContext context, int inventarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este inventario?"),
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
                _dbHelper.deleteInventario(inventarioId);
                _loadInventarios();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventarios"),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              // Aquí puedes implementar el menú para ordenar inventarios
            },
          ),
        ],
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
                _filterInventarios(value);
              },
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: filteredInventarios.isEmpty
                      ? Center(child: Text('No hay inventarios'))
                      : ListView.builder(
                          itemCount: filteredInventarios.length,
                          itemBuilder: (context, index) {
                            final inventario = filteredInventarios[index];
                            return FutureBuilder<Note?>(
                              future: _getTipoPropiedad(inventario.tipoPropiedadId),
                              builder: (context, snapshot) {
                                final tipoPropiedad = snapshot.data;
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Dismissible(
                                    key: Key(inventario.id.toString()),
                                    background: Container(color: Colors.red),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      _confirmDelete(context, inventario.id!);
                                    },
                                    child: ListTile(
                                      leading: _buildImageThumbnail(inventario),
                                      title: Text(
                                        inventario.direccion ?? 'Sin dirección',
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: _buildDetails(inventario, tipoPropiedad),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
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
                                              _confirmDelete(context, inventario.id!);
                                            },
                                          ),
                                        ],
                                      ),
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

  Widget _buildImageThumbnail(Inventario inventario) {
    return Container(
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
    );
  }

  Widget _buildDetails(Inventario inventario, Note? tipoPropiedad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}
