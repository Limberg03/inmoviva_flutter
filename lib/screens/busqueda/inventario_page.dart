import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/inventario.dart';

class InventarioPage extends StatefulWidget {
  final List<Inventario>? inventariosFiltrados; // Recibir inventarios filtrados como argumento

  InventarioPage({this.inventariosFiltrados}); // Constructor opcional para inventarios filtrados

  @override
  _InventarioListPageState createState() => _InventarioListPageState();
}

class _InventarioListPageState extends State<InventarioPage> {
  final DBHelper _dbHelper = DBHelper();
  List<Inventario> inventarios = []; // Lista de inventarios
  List<Inventario> inventariosFiltrados = []; // Lista de inventarios filtrados por búsqueda
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController(); // Controlador para búsqueda

  @override
  void initState() {
    super.initState();
    if (widget.inventariosFiltrados == null) {
      _cargarInventarios(); // Cargar inventarios si no se aplicaron filtros
    } else {
      inventarios = widget.inventariosFiltrados!;
      inventariosFiltrados = inventarios;
    }

    // Listener para aplicar filtro en tiempo real cuando el usuario escribe
    _searchController.addListener(_filterSearchResults);
  }

  Future<void> _cargarInventarios() async {
    setState(() {
      isLoading = true;
    });
    // Cargar los inventarios desde la base de datos
    List<Inventario> inventariosCargados = await _dbHelper.getInventarios();
    setState(() {
      inventarios = inventariosCargados;
      inventariosFiltrados = inventariosCargados;
      isLoading = false;
    });
  }

  // Función para aplicar la búsqueda en tiempo real
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
    _searchController.dispose(); // Limpiar el controlador cuando se destruya el widget
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
                  // Navegar a la página de búsqueda avanzada y pasar la lista de inventarios
                  final inventariosFiltrados = await Navigator.pushNamed(
                    context,
                    '/filtro_busqueda',
                    arguments: inventarios, // Pasar la lista de inventarios a la página de filtros
                  );

                  // Actualizar la lista con los resultados filtrados
                  if (inventariosFiltrados != null) {
                    setState(() {
                      inventarios = inventariosFiltrados as List<Inventario>;
                      _filterSearchResults(); // Aplicar búsqueda en los resultados filtrados
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
        automaticallyImplyLeading: true, // Mantiene la flecha de atrás
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : inventariosFiltrados.isEmpty
              ? Center(child: Text('No hay inventarios disponibles'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de tarjetas por fila
                    childAspectRatio: 0.75, // Aspecto de la tarjeta
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: inventariosFiltrados.length,
                  itemBuilder: (context, index) {
                    final inventario = inventariosFiltrados[index];
                    return _buildCard(inventario);
                  },
                ),
    );
  }

  // Función para determinar el color de fondo del estado
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

  Widget _buildCard(Inventario inventario) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de la propiedad
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: inventario.imagen != null && inventario.imagen!.isNotEmpty
                ? Image.file(
                    File(inventario.imagen!),
                    fit: BoxFit.cover,
                    height: 120, // Tamaño ajustado de la imagen
                    width: double.infinity,
                  )
                : Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título con dirección
                Text(
                  inventario.direccion ?? 'Sin dirección',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blueGrey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Si es muy largo, lo corta
                ),
                SizedBox(height: 2),
                Text(
                  'Dirección: ${inventario.direccion ?? 'No especificada'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Si es muy largo, lo corta
                ),
                SizedBox(height: 4),
                // Estado de la propiedad con fondo
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: _getEstadoColor(inventario.estado ?? ''),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Estado: ${inventario.estado ?? 'No disponible'}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Precio de la propiedad
                Text(
                  'Precio: \$${inventario.precio?.toStringAsFixed(2) ?? "0.00"}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 13,
                  ),
                ),
                // Superficie
                Text(
                  'Superficie: ${inventario.superficie?.toStringAsFixed(2)} m²',
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 6),
                // Descripción de la propiedad
                Text(
                  inventario.descripcion ?? 'Sin descripción',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                  maxLines: 2, // Mostrar solo dos líneas de la descripción
                  overflow: TextOverflow.ellipsis, // Cortar si es muy largo
                ),
                // Botón de ver detalles
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.info, color: Colors.blue),
                    onPressed: () {
                      // Navegar a la página de detalles
                      Navigator.pushNamed(
                        context,
                        '/detalles_inventario',
                        arguments: inventario, // Pasar el inventario completo a la nueva página
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
