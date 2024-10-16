import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inmoviva/models/propiedad.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:inmoviva/models/note.dart';
import 'package:inmoviva/db/operation.dart';
import 'package:inmoviva/db/db_helper.dart';

class PropiedadFormPage extends StatefulWidget {
  final Propiedad? propiedad;

  PropiedadFormPage({this.propiedad});

  @override
  _PropiedadFormPageState createState() => _PropiedadFormPageState();
}

class _PropiedadFormPageState extends State<PropiedadFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _precioController = TextEditingController();
  final _superficieController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nroHabitacionesController = TextEditingController();
  final _nroBanosController = TextEditingController();
  File? _imageFile; // Solo una imagen
  int? _selectedTipoPropiedadId;
  String? _selectedEstado;
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    if (widget.propiedad != null) {
      _nombreController.text = widget.propiedad?.nombre ?? '';
      _direccionController.text = widget.propiedad?.direccion ?? '';
      _precioController.text = widget.propiedad?.precio?.toString() ?? '';
      _superficieController.text = widget.propiedad?.superficie?.toString() ?? '';
      _descripcionController.text = widget.propiedad?.descripcion ?? '';
      _nroHabitacionesController.text = widget.propiedad?.nroHabitaciones?.toString() ?? '';
      _nroBanosController.text = widget.propiedad?.nroBanos?.toString() ?? '';
      _selectedTipoPropiedadId = widget.propiedad?.tipoPropiedadId;
      _selectedEstado = widget.propiedad?.estado;
      if (widget.propiedad?.imagen != null) {
        _imageFile = File(widget.propiedad!.imagen!);
      }
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false, // Solo permitir una imagen
    );

    if (result != null) {
      setState(() {
        _imageFile = File(result.paths.first!);
      });
    }
  }

  Future<List<Note>> _getTiposDePropiedad() async {
    return await Operation.notes();
  }

  Future<void> _savePropiedad() async {
    if (_formKey.currentState?.validate() ?? false) {
      final propiedad = Propiedad(
        id: widget.propiedad?.id,
        nombre: _nombreController.text,
        direccion: _direccionController.text,
        precio: double.tryParse(_precioController.text),
        estado: _selectedEstado,
        superficie: double.tryParse(_superficieController.text),
        descripcion: _descripcionController.text,
        nroHabitaciones: int.tryParse(_nroHabitacionesController.text),
        nroBanos: int.tryParse(_nroBanosController.text),
        imagen: _imageFile?.path, // Almacena la ruta de la imagen
        tipoPropiedadId: _selectedTipoPropiedadId,
        fecha: DateTime.now().toIso8601String(),
      );

      if (propiedad.id != null) {
        await _dbHelper.updatePropiedad(propiedad.id!, propiedad.toMap()); // Asegúrate de que `propiedad.toMap()` exista.
      } else {
        await _dbHelper.addPropiedad(propiedad.toMap()); // Asegúrate de que `propiedad.toMap()` exista.
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Propiedad guardada correctamente')),
      );

      Navigator.pop(context, propiedad);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propiedad != null ? 'Editar Propiedad' : 'Nueva Propiedad'),
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
                  child: _buildTextField(_nombreController, 'Nombre', 'Por favor ingresa el nombre', Icons.title),
                ),
                _buildCard(
                  child: _buildTextField(_direccionController, 'Dirección', 'Por favor ingresa la dirección', Icons.location_on),
                ),
                _buildCard(
                  child: _buildTextField(_precioController, 'Precio', 'Por favor ingresa el precio', Icons.attach_money, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildEstadoDropdown(),
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
                child: Image.file(
                  _imageFile!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            : Text('Ninguna imagen seleccionada'),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.image),
          label: Text('Seleccionar Imagen',style: TextStyle(color: Colors.black)),
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 223, 220, 19),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _savePropiedad,
      child: Text('Guardar Propiedad',style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 223, 220, 19),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
