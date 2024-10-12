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
  final _superficieController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nroHabitacionesController = TextEditingController();
  final _nroBanosController = TextEditingController();
  File? _imageFile;
  int? _selectedTipoPropiedadId;
  String? _selectedEstado;
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.inventario != null) {
      _direccionController.text = widget.inventario?.direccion ?? '';
      _precioController.text = widget.inventario?.precio?.toString() ?? '';
      _superficieController.text = widget.inventario?.superficie?.toString() ?? '';
      _descripcionController.text = widget.inventario?.descripcion ?? '';
      _nroHabitacionesController.text = widget.inventario?.nroHabitaciones?.toString() ?? '';
      _nroBanosController.text = widget.inventario?.nroBanos?.toString() ?? '';
      _selectedTipoPropiedadId = widget.inventario?.tipoPropiedadId;
      _selectedEstado = widget.inventario?.estado;
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
        estado: _selectedEstado,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inventario guardado correctamente')),
      );

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
                _buildCard(
                  child: _buildTextField(_direccionController, 'Dirección', 'Por favor ingresa la dirección', Icons.location_on),
                ),
                _buildCard(
                  child: _buildTextField(_precioController, 'Precio', 'Por favor ingresa el precio', Icons.attach_money, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildEstadoDropdown(), // Usamos el nuevo Dropdown para Estado
                ),
                _buildCard(
                  child: _buildTextField(_superficieController, 'Superficie', 'Por favor ingresa la superficie', Icons.square_foot, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildTextField(_descripcionController, 'Descripción', null, Icons.description, maxLines: 3),
                ),
                _buildCard(
                  child: _buildTextField(_nroHabitacionesController, 'Número de Habitaciones', 'Por favor ingresa el número de habitaciones', Icons.bed, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildTextField(_nroBanosController, 'Número de Baños', 'Por favor ingresa el número de baños', Icons.bathtub, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: FutureBuilder<List<Note>>(
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
                ),
                SizedBox(height: 20),
                _buildImagePicker(),
                SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String? errorMessage, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
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

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }

  Widget _buildEstadoDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedEstado,
      items: ['Libre', 'Vendido', 'Alquilado', 'Anticretico'].map((String estado) {
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
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null ? 'Por favor selecciona un estado' : null,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
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
    );
  }
}
