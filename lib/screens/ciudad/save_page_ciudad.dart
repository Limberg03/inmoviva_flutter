import 'package:flutter/material.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/models/ciudad.dart';

class SavePageCiudad extends StatefulWidget {
  final Ciudad? ciudad;

  SavePageCiudad({Key? key, this.ciudad}) : super(key: key);

  @override
  _SavePageCiudadState createState() => _SavePageCiudadState();
}

class _SavePageCiudadState extends State<SavePageCiudad> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ciudad != null) {
      nombreController.text = widget.ciudad!.nombre;
      descripcionController.text = widget.ciudad!.descripcion ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ciudad == null ? "Agregar Ciudad" : "Editar Ciudad"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Nombre es requerido";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Nombre"),
              ),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: "Descripción"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.ciudad == null) {
                      // Crear nueva ciudad
                      Ciudad nuevaCiudad = Ciudad(
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                      );
                      await Operation.insertCiudad(nuevaCiudad);
                    } else {
                      // Actualizar ciudad existente
                      widget.ciudad!.nombre = nombreController.text;
                      widget.ciudad!.descripcion = descripcionController.text;
                      await Operation.updateCiudad(widget.ciudad!);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.ciudad == null ? "Guardar" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
