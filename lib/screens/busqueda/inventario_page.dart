import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/inventario.dart';

class InventarioPage extends StatefulWidget {
  final List<Inventario>? inventariosFiltrados;

  InventarioPage({this.inventariosFiltrados});

  @override
  _InventarioListPageState createState() => _InventarioListPageState();
}

class _InventarioListPageState extends State<InventarioPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Inventario> inventarios = [];
  List<Inventario> inventariosFiltrados = [];
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.inventariosFiltrados == null) {
      _cargarInventarios();
    } else {
      inventarios = widget.inventariosFiltrados!;
      inventariosFiltrados = inventarios;
    }

    _searchController.addListener(_filterSearchResults);
  }

  Future<void> _cargarInventarios() async {
    setState(() {
      isLoading = true;
    });
    List<Inventario> inventariosCargados = await _dbHelper.getInventarios();
    setState(() {
      inventarios = inventariosCargados;
      inventariosFiltrados = inventariosCargados;
      isLoading = false;
    });
  }

  void _filterSearchResults() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      inventariosFiltrados = inventarios.where((inventario) {
        final direccion = inventario.direccion?.toLowerCase() ?? '';
        return direccion.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () async {
                if (inventarios.isNotEmpty) {
                  final inventariosFiltrados = await Navigator.pushNamed(
                    context,
                    '/filtro_busqueda',
                    arguments: inventarios,
                  );

                  if (inventariosFiltrados != null) {
                    setState(() {
                      inventarios = inventariosFiltrados as List<Inventario>;
                      _filterSearchResults();
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cargando inventarios, por favor espera...')),
                  );
                }
              },
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : inventariosFiltrados.isEmpty
              ? Center(child: Text('No hay inventarios disponibles'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65, // Ajusté el aspecto para mejorar el diseño
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: inventariosFiltrados.length,
                  itemBuilder: (context, index) {
                    final inventario = inventariosFiltrados[index];
                    return _buildCard(inventario, context);
                  },
                ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'libre':
        return Colors.green[100]!;
      case 'alquilado':
        return Colors.red[100]!;
      case 'anticretico':
        return Colors.orange[100]!;
      case 'vendido':
        return Colors.blue[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Widget _buildCard(Inventario inventario, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detalles_inventario',
          arguments: inventario,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Borde más redondeado
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la propiedad
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: inventario.imagen != null && inventario.imagen!.isNotEmpty
                  ? Image.file(
                      File(inventario.imagen!),
                      fit: BoxFit.cover,
                      height: 120, // Tamaño de la imagen ajustado
                      width: double.infinity,
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 60, color: Colors.grey), // Icono ajustado
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dirección
                  Text(
                    inventario.direccion ?? 'Sin dirección',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Tamaño de la fuente mejorado
                      color: Colors.blueGrey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Estado
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: _getEstadoColor(inventario.estado ?? ''),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Estado: ${inventario.estado ?? 'No disponible'}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  // Precio
                  Text(
                    'Precio: \$${inventario.precio?.toStringAsFixed(2) ?? "0.00"}',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12, // Tamaño de la fuente ajustado
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Superficie
                  Text(
                    'Superficie: ${inventario.superficie?.toStringAsFixed(2)} m²',
                    style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 6),
                  // Descripción
                  Text(
                    inventario.descripcion ?? 'Sin descripción',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 11, // Ajuste en el tamaño de la fuente
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Tooltip(
                      message: "Detalles de la propiedad",
                      child: IconButton(
                        icon: Icon(Icons.info, color: Colors.blue, size: 22),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/detalles_inventario',
                            arguments: inventario,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
