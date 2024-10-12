import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:inmoviva/models/note.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/db/db_helper.dart';

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
  int? _selectedTipoPropiedadId;
  final DBHelper _dbHelper = DBHelper();

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
      _selectedTipoPropiedadId = widget.inventario?.tipoPropiedadId;
      if (widget.inventario?.imagen != null) {
        _imageFile = File(widget.inventario!.imagen!);
      }
    }
  }

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

  Future<List<Note>> _getTiposDePropiedad() async {
    return await Operation.notes();
  }

  Future<void> _saveInventario() async {
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
        tipoPropiedadId: _selectedTipoPropiedadId,
        fechaPublicacion: DateTime.now().toIso8601String(),
      );

      if (inventario.id != null) {
        await _dbHelper.updateInventario(inventario);
      } else {
        await _dbHelper.insertInventario(inventario);
      }

      Navigator.pop(context, inventario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inventario != null ? 'Editar Inventario' : 'Nuevo Inventario'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_direccionController, 'Dirección', 'Por favor ingresa la dirección'),
                SizedBox(height: 16),
                _buildTextField(_precioController, 'Precio', 'Por favor ingresa el precio', keyboardType: TextInputType.number),
                SizedBox(height: 16),
                _buildTextField(_estadoController, 'Estado', 'Por favor ingresa el estado'),
                SizedBox(height: 16),
                _buildTextField(_superficieController, 'Superficie', 'Por favor ingresa la superficie', keyboardType: TextInputType.number),
                SizedBox(height: 16),
                _buildTextField(_descripcionController, 'Descripción', null, maxLines: 3),
                SizedBox(height: 16),
                _buildTextField(_nroHabitacionesController, 'Número de Habitaciones', 'Por favor ingresa el número de habitaciones', keyboardType: TextInputType.number),
                SizedBox(height: 16),
                _buildTextField(_nroBanosController, 'Número de Baños', 'Por favor ingresa el número de baños', keyboardType: TextInputType.number),
                SizedBox(height: 20),
                FutureBuilder<List<Note>>(
                  future: _getTiposDePropiedad(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButtonFormField<int>(
                      value: _selectedTipoPropiedadId,
                      items: snapshot.data!.map((note) {
                        return DropdownMenuItem<int>(
                          value: note.id,
                          child: Text(note.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTipoPropiedadId = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Tipo de Propiedad',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value == null ? 'Por favor selecciona un tipo de propiedad' : null,
                    );
                  },
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(_imageFile!, width: 150, height: 150, fit: BoxFit.cover),
                      )
                    : Text('Ninguna imagen seleccionada'),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Seleccionar Imagen'),
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('Guardar'),
                  onPressed: _saveInventario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String? errorMessage, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}
