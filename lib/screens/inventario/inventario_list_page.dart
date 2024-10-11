import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/inventario.dart';
// import '../models/inventario.dart'; // Removed incorrect import
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

  // Cargar inventarios desde la base de datos
  Future<void> _loadInventarios() async {
    List<Inventario> loadedInventarios = await _dbHelper.getInventarios();
    setState(() {
      inventarios = loadedInventarios;
      filteredInventarios = loadedInventarios; // Inicializar la lista filtrada
    });
  }

  // Filtrar inventarios en función del término de búsqueda
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

  // Agregar un nuevo inventario
  Future<void> _addInventario(Inventario inventario) async {
    await _dbHelper.insertInventario(inventario);
    _loadInventarios();
  }

  // Actualizar un inventario existente
  Future<void> _updateInventario(Inventario inventario) async {
    await _dbHelper.updateInventario(inventario);
    _loadInventarios();
  }

  // Eliminar un inventario
  Future<void> _deleteInventario(int id) async {
    await _dbHelper.deleteInventario(id);
    _loadInventarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventarios"),
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
                      return ListTile(
                        title: Text(inventario.direccion ?? 'Sin dirección'),
                        subtitle: Text('Precio: ${inventario.precio ?? 0} USD'),
                        leading: inventario.imagen != null
                            ? Image.file(File(inventario.imagen!))
                            : Icon(Icons.image),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                final updatedInventario = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InventarioFormPage(inventario: inventario),
                                  ),
                                );
                                if (updatedInventario != null) {
                                  _updateInventario(updatedInventario);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteInventario(inventario.id!);
                              },
                            ),
                          ],
                        ),
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
            _addInventario(newInventario);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
