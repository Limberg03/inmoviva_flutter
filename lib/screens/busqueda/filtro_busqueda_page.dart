import 'package:flutter/material.dart';
import 'package:inmoviva/models/inventario.dart';

class FiltroBusquedaPage extends StatefulWidget {
  @override
  _FiltroBusquedaPageState createState() => _FiltroBusquedaPageState();
}

class _FiltroBusquedaPageState extends State<FiltroBusquedaPage> {
  bool _filtrarPorPrecio = false;
  bool _filtrarPorEstado = false;
  bool _filtrarPorSuperficie = false;
  bool _filtrarPorHabitaciones = false;
  bool _filtrarPorBanos = false;

  // Controladores para los filtros
  TextEditingController _precioMinController = TextEditingController();
  TextEditingController _precioMaxController = TextEditingController();
  TextEditingController _superficieMinController = TextEditingController();
  TextEditingController _superficieMaxController = TextEditingController();
  TextEditingController _habitacionesController = TextEditingController();
  TextEditingController _banosController = TextEditingController();

  // Lista de estados predefinidos
  List<String> _estados = ['Libre', 'Vendido', 'Alquilado', 'Anticretico'];
  String? _selectedEstado; // Variable para guardar el estado seleccionado

  List<Inventario>? inventarios; // Lista de inventarios recibidos como argumento

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibir la lista de inventarios pasada como argumento
    inventarios = ModalRoute.of(context)?.settings.arguments as List<Inventario>?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filtros de Búsqueda"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CheckboxListTile(
              title: Text('Filtrar por Precio'),
              value: _filtrarPorPrecio,
              onChanged: (bool? value) {
                setState(() {
                  _filtrarPorPrecio = value ?? false;
                });
              },
            ),
            if (_filtrarPorPrecio) ...[
              TextField(
                controller: _precioMinController,
                decoration: InputDecoration(labelText: 'Precio Mínimo'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _precioMaxController,
                decoration: InputDecoration(labelText: 'Precio Máximo'),
                keyboardType: TextInputType.number,
              ),
            ],
            CheckboxListTile(
              title: Text('Filtrar por Estado'),
              value: _filtrarPorEstado,
              onChanged: (bool? value) {
                setState(() {
                  _filtrarPorEstado = value ?? false;
                });
              },
            ),
            if (_filtrarPorEstado)
              DropdownButtonFormField<String>(
                value: _selectedEstado,
                items: _estados.map((String estado) {
                  return DropdownMenuItem<String>(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEstado = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Por favor selecciona un estado' : null,
              ),
            
            // Filtro por Superficie
            CheckboxListTile(
              title: Text('Filtrar por Superficie'),
              value: _filtrarPorSuperficie,
              onChanged: (bool? value) {
                setState(() {
                  _filtrarPorSuperficie = value ?? false;
                });
              },
            ),
            if (_filtrarPorSuperficie) ...[
              TextField(
                controller: _superficieMinController,
                decoration: InputDecoration(labelText: 'Superficie Mínima (m²)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _superficieMaxController,
                decoration: InputDecoration(labelText: 'Superficie Máxima (m²)'),
                keyboardType: TextInputType.number,
              ),
            ],
            
            // Filtro por Habitaciones
            CheckboxListTile(
              title: Text('Filtrar por Número de Habitaciones'),
              value: _filtrarPorHabitaciones,
              onChanged: (bool? value) {
                setState(() {
                  _filtrarPorHabitaciones = value ?? false;
                });
              },
            ),
            if (_filtrarPorHabitaciones)
              TextField(
                controller: _habitacionesController,
                decoration: InputDecoration(labelText: 'Número de Habitaciones'),
                keyboardType: TextInputType.number,
              ),
            
            // Filtro por Baños
            CheckboxListTile(
              title: Text('Filtrar por Número de Baños'),
              value: _filtrarPorBanos,
              onChanged: (bool? value) {
                setState(() {
                  _filtrarPorBanos = value ?? false;
                });
              },
            ),
            if (_filtrarPorBanos)
              TextField(
                controller: _banosController,
                decoration: InputDecoration(labelText: 'Número de Baños'),
                keyboardType: TextInputType.number,
              ),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aplicar los filtros y regresar los inventarios filtrados
                Navigator.pop(context, _aplicarFiltros());
              },
              child: Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }

  // Función para aplicar los filtros
  List<Inventario> _aplicarFiltros() {
    List<Inventario> inventariosFiltrados = inventarios ?? [];

    if (_filtrarPorPrecio) {
      double? minPrecio = double.tryParse(_precioMinController.text);
      double? maxPrecio = double.tryParse(_precioMaxController.text);
      inventariosFiltrados = inventariosFiltrados.where((inventario) {
        final precio = inventario.precio ?? 0;
        return (minPrecio == null || precio >= minPrecio) &&
               (maxPrecio == null || precio <= maxPrecio);
      }).toList();
    }

    if (_filtrarPorEstado && _selectedEstado != null) {
      inventariosFiltrados = inventariosFiltrados.where((inventario) {
        return inventario.estado == _selectedEstado;
      }).toList();
    }

    if (_filtrarPorSuperficie) {
      double? minSuperficie = double.tryParse(_superficieMinController.text);
      double? maxSuperficie = double.tryParse(_superficieMaxController.text);
      inventariosFiltrados = inventariosFiltrados.where((inventario) {
        final superficie = inventario.superficie ?? 0;
        return (minSuperficie == null || superficie >= minSuperficie) &&
               (maxSuperficie == null || superficie <= maxSuperficie);
      }).toList();
    }

    if (_filtrarPorHabitaciones) {
      int? nroHabitaciones = int.tryParse(_habitacionesController.text);
      inventariosFiltrados = inventariosFiltrados.where((inventario) {
        return (nroHabitaciones == null || inventario.nroHabitaciones == nroHabitaciones);
      }).toList();
    }

    if (_filtrarPorBanos) {
      int? nroBanos = int.tryParse(_banosController.text);
      inventariosFiltrados = inventariosFiltrados.where((inventario) {
        return (nroBanos == null || inventario.nroBanos == nroBanos);
      }).toList();
    }

    return inventariosFiltrados; // Devuelve la lista filtrada
  }
}
