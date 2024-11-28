import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inmoviva/models/anticretico.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class AnticreticoFormPage extends StatefulWidget {
  final Anticretico? anticretico;

  AnticreticoFormPage({this.anticretico});

  @override
  _AnticreticoFormPageState createState() => _AnticreticoFormPageState();
}

class _AnticreticoFormPageState extends State<AnticreticoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _metodoPagoController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  String? _selectedArrendatario;
  int? _selectedInventarioId;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  String? _selectedContratoPdf;

  @override
  void initState() {
    super.initState();
    if (widget.anticretico != null) {
      _montoController.text = widget.anticretico?.montoAnticretico?.toString() ?? '';
      _metodoPagoController.text = widget.anticretico?.metodoPago ?? '';
      _fechaInicio = widget.anticretico?.fechaInicio != null
          ? DateTime.parse(widget.anticretico!.fechaInicio!)
          : null;
      _fechaFin = widget.anticretico?.fechaFin != null
          ? DateTime.parse(widget.anticretico!.fechaFin!)
          : null;
      _selectedInventarioId = widget.anticretico?.inventarioId;
      _selectedContratoPdf = widget.anticretico?.contratoPdf;
      _selectedArrendatario = widget.anticretico?.arrendatario;
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedContratoPdf = result.files.single.path;
      });
    }
  }

  Future<void> _selectFechaInicio() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _fechaInicio = selectedDate;
      });
    }
  }

  Future<void> _selectFechaFin() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _fechaFin = selectedDate;
      });
    }
  }

  Future<void> _saveAnticretico() async {
    if (_formKey.currentState?.validate() ?? false) {
      final anticretico = Anticretico(
        id: widget.anticretico?.id,
        inventarioId: _selectedInventarioId,
        arrendatario: _selectedArrendatario,
        montoAnticretico: double.tryParse(_montoController.text),
        metodoPago: _metodoPagoController.text,
        fechaInicio: _fechaInicio?.toIso8601String(),
        fechaFin: _fechaFin?.toIso8601String(),
        contratoPdf: _selectedContratoPdf,
      );

      await _dbHelper.insertAnticretico(anticretico);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anticrético guardado correctamente')),
      );

      Navigator.pop(context, anticretico);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.anticretico != null ? 'Editar Anticrético' : 'Nuevo Anticrético'),
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
                  child: _buildArrendatarioDropdown(),
                ),
                _buildCard(
                  child: _buildTextField(
                      _montoController, 'Monto Anticrético', 'Por favor ingresa el monto', Icons.attach_money,
                      keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildTextField(
                      _metodoPagoController, 'Método de Pago', 'Por favor ingresa el método de pago', Icons.payment),
                ),
                _buildCard(
                  child: _buildInventarioDropdown(),
                ),
                _buildCard(
                  child: _buildDatePicker('Fecha de Inicio', _fechaInicio, _selectFechaInicio),
                ),
                _buildCard(
                  child: _buildDatePicker('Fecha de Fin', _fechaFin, _selectFechaFin),
                ),
                _buildCard(
                  child: _buildPdfPicker(),
                ),
                SizedBox(height: 20),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String? errorMessage, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
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

  Widget _buildArrendatarioDropdown() {
    final List<String> arrendatarios = [
      'Pedro López',
      'Claudia Rivera',
      'Fernando Gutiérrez',
      'Lucía Ramírez',
      'Miguel Fernández',
    ];
    return DropdownButtonFormField<String>(
      value: _selectedArrendatario,
      items: arrendatarios.map((arrendatario) {
        return DropdownMenuItem<String>(
          value: arrendatario,
          child: Text(arrendatario),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedArrendatario = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Seleccionar Arrendatario',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null ? 'Por favor selecciona un arrendatario' : null,
    );
  }

  Widget _buildInventarioDropdown() {
    return FutureBuilder<List<Inventario>>(
      future: _dbHelper.getInventarios(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return DropdownButtonFormField<int>(
          value: _selectedInventarioId,
          items: snapshot.data!.map((inventario) {
            return DropdownMenuItem<int>(
              value: inventario.id,
              child: Text(inventario.direccion ?? 'Sin dirección'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedInventarioId = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Seleccionar Propiedad',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value == null ? 'Por favor selecciona una propiedad' : null,
        );
      },
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(date == null ? label : DateFormat('dd/MM/yyyy').format(date)),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget _buildPdfPicker() {
    return Column(
      children: [
        _selectedContratoPdf != null
            ? Text('Contrato PDF seleccionado: ${_selectedContratoPdf!.split('/').last}')
            : Text('No se ha seleccionado un PDF'),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.attach_file),
          label: Text('Seleccionar PDF'),
          onPressed: _pickPdf,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: _saveAnticretico,
    );
  }
}
