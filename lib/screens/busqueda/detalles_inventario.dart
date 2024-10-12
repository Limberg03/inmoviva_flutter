import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inmoviva/models/inventario.dart';

class DetallesInventarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Recibir el inventario desde la ruta
    final Inventario inventario = ModalRoute.of(context)?.settings.arguments as Inventario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Propiedad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar la imagen de la propiedad
            inventario.imagen != null
                ? Image.file(
                    File(inventario.imagen!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
            SizedBox(height: 16),
            // Dirección
            Text(
              'Dirección: ${inventario.direccion ?? 'No especificada'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Estado
            Text(
              'Estado: ${inventario.estado ?? 'No disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            // Precio
            Text(
              'Precio: \$${inventario.precio?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(fontSize: 16, color: Colors.green[700]),
            ),
            SizedBox(height: 8),
            // Superficie
            Text(
              'Superficie: ${inventario.superficie?.toStringAsFixed(2)} m²',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            // Descripción
            Text(
              inventario.descripcion ?? 'Sin descripción',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
