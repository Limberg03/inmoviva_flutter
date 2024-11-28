import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inmoviva/models/venta.dart';
import 'package:inmoviva/models/inventario.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

class VentaFormPage extends StatefulWidget {
  final Venta? venta;

  VentaFormPage({this.venta});

  @override
  _VentaFormPageState createState() => _VentaFormPageState();
}

class _VentaFormPageState extends State<VentaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _precioController = TextEditingController();
  final _metodoPagoController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  DateTime? _fechaTransaccion; // Para almacenar la fecha de la transacción
  String? _selectedDocumentoPdf; // Ruta del archivo PDF
  int? _selectedInventarioId; // Para seleccionar el inventario
  String? _selectedComprador; // El comprador seleccionado

  // Lista de compradores predefinidos (puedes modificarla como desees)
  final List<String> _compradores = [
    'Juan Pérez',
    'María García',
    'Carlos Rodríguez',
    'Ana López',
    'Luis Martínez',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.venta != null) {
      _precioController.text = widget.venta?.precio?.toString() ?? '';
      _metodoPagoController.text = widget.venta?.metodoPago ?? '';
      _fechaTransaccion = DateTime.parse(widget.venta?.fechaTransaccion ?? '');
      _selectedInventarioId = widget.venta?.inventarioId;
      _selectedDocumentoPdf = widget.venta?.documentoPdf;
      _selectedComprador = widget.venta?.comprador;
    }
  }

  // Método para seleccionar el PDF de la venta
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedDocumentoPdf = result.files.single.path;
      });
    }
  }

  // Método para mostrar el selector de fecha
  Future<void> _selectFechaTransaccion() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _fechaTransaccion ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _fechaTransaccion) {
      setState(() {
        _fechaTransaccion = selectedDate;
      });
    }
  }

  // Método para guardar la venta
  Future<void> _saveVenta() async {
    if (_formKey.currentState?.validate() ?? false) {
      final venta = Venta(
        id: widget.venta?.id,
        inventarioId: _selectedInventarioId,
        comprador: _selectedComprador,
        precio: double.tryParse(_precioController.text),
        metodoPago: _metodoPagoController.text,
        fechaTransaccion: _fechaTransaccion?.toIso8601String(),
        documentoPdf: _selectedDocumentoPdf,
      );

      await _dbHelper.insertVenta(venta);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venta guardada correctamente')),
      );

      Navigator.pop(context, venta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venta != null ? 'Editar Venta' : 'Nueva Venta'),
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
                  child: _buildCompradorDropdown(),
                ),
                _buildCard(
                  child: _buildTextField(_precioController, 'Precio', 'Por favor ingresa el precio', Icons.attach_money, keyboardType: TextInputType.number),
                ),
                _buildCard(
                  child: _buildTextField(_metodoPagoController, 'Método de Pago', 'Por favor ingresa el método de pago', Icons.payment),
                ),
                _buildCard(
                  child: _buildInventarioDropdown(),
                ),
                _buildCard(
                  child: _buildDatePicker(),
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

  Widget _buildTextField(TextEditingController controller, String labelText, String? errorMessage, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
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

  // Dropdown para seleccionar el comprador
  Widget _buildCompradorDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedComprador,
      items: _compradores.map((comprador) {
        return DropdownMenuItem<String>(
          value: comprador,
          child: Text(comprador),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedComprador = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Seleccionar Comprador',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null ? 'Por favor selecciona un comprador' : null,
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

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_fechaTransaccion == null
            ? 'Fecha de Transacción'
            : DateFormat('dd/MM/yyyy').format(_fechaTransaccion!)),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _selectFechaTransaccion,
        ),
      ],
    );
  }

  Widget _buildPdfPicker() {
    return Column(
      children: [
        _selectedDocumentoPdf != null
            ? Text('Documento PDF seleccionado: ${_selectedDocumentoPdf!.split('/').last}')
            : Text('No se ha seleccionado un PDF'),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: Icon(Icons.attach_file),
          label: Text('Seleccionar Documento PDF'),
          onPressed: _pickPdf,
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
      label: Text('Guardar Venta'),
      onPressed: _saveVenta,
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
