import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/models/ciudad.dart';
import 'save_page_ciudad.dart'; // Asegúrate de tener este archivo

class ListPageCiudad extends StatefulWidget {
  @override
  _ListPageCiudadState createState() => _ListPageCiudadState();
}

class _ListPageCiudadState extends State<ListPageCiudad> {
  List<Ciudad> ciudades = [];

  @override
  void initState() {
    super.initState();
    _loadCiudades();
  }

  _loadCiudades() async {
    List<Ciudad> auxCiudades = await Operation.ciudades();
    setState(() {
      ciudades = auxCiudades;
    });
  }

  _deleteCiudad(Ciudad ciudad) async {
    await Operation.deleteCiudad(ciudad);
    _loadCiudades();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ciudad eliminada')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestionar Ciudades"),
      ),
      body: ListView.builder(
        itemCount: ciudades.length,
        itemBuilder: (context, index) {
          final ciudad = ciudades[index];
          return Dismissible(
            key: Key(ciudad.id.toString()),
            onDismissed: (direction) {
              _deleteCiudad(ciudad);
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(ciudad.nombre),
              subtitle: Text(ciudad.descripcion ?? 'Sin descripción'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavePageCiudad(ciudad: ciudad),
                    ),
                  ).then((_) => _loadCiudades());
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavePageCiudad(),
            ),
          ).then((_) => _loadCiudades());
        },
      ),
    );
  }
}
