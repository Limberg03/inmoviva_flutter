import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inmoviva/models/inventario.dart';

class InventarioFormPage extends StatefulWidget {
  final Inventario? inventario;

  InventarioFormPage({this.inventario});

  @override
  _InventarioFormPageState createState() => _InventarioFormPageState();
}

class _InventarioFormPageState extends State<InventarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();
  final _precioController = TextEditingController();
  final _estadoController = TextEditingController();
  final _superficieController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nroHabitacionesController = TextEditingController();
  final _nroBanosController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.inventario != null) {
      _direccionController.text = widget.inventario?.direccion ?? '';
      _precioController.text = widget.inventario?.precio?.toString() ?? '';
      _estadoController.text = widget.inventario?.estado ?? '';
      _superficieController.text = widget.inventario?.superficie?.toString() ?? '';
      _descripcionController.text = widget.inventario?.descripcion ?? '';
      _nroHabitacionesController.text = widget.inventario?.nroHabitaciones?.toString() ?? '';
      _nroBanosController.text = widget.inventario?.nroBanos?.toString() ?? '';
      if (widget.inventario?.imagen != null) {
        _imageFile = File(widget.inventario!.imagen!);
      }
    }
  }

  // Seleccionar una imagen usando file_picker
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  @override
  void dispose() {
    _direccionController.dispose();
    _precioController.dispose();
    _estadoController.dispose();
    _superficieController.dispose();
    _descripcionController.dispose();
    _nroHabitacionesController.dispose();
    _nroBanosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inventario != null
            ? 'Editar Inventario'
            : 'Nuevo Inventario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _direccionController,
                  decoration: InputDecoration(labelText: 'Dirección'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la dirección';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el precio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _estadoController,
                  decoration: InputDecoration(labelText: 'Estado'),
                ),
                TextFormField(
                  controller: _superficieController,
                  decoration: InputDecoration(labelText: 'Superficie'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _nroHabitacionesController,
                  decoration: InputDecoration(labelText: 'Número de Habitaciones'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _nroBanosController,
                  decoration: InputDecoration(labelText: 'Número de Baños'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(_imageFile!)
                    : Text('Ninguna imagen seleccionada'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Seleccionar Imagen'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final inventario = Inventario(
                        id: widget.inventario?.id,
                        direccion: _direccionController.text,
                        precio: double.tryParse(_precioController.text),
                        estado: _estadoController.text,
                        superficie: double.tryParse(_superficieController.text),
                        descripcion: _descripcionController.text,
                        nroHabitaciones: int.tryParse(_nroHabitacionesController.text),
                        nroBanos: int.tryParse(_nroBanosController.text),
                        imagen: _imageFile?.path,
                      );
                      Navigator.pop(context, inventario);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
