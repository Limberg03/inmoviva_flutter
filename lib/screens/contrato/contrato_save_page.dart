import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class ContratoSavePage extends StatefulWidget {
  const ContratoSavePage({Key? key}) : super(key: key);

  @override
  _ContratoSavePageState createState() => _ContratoSavePageState();
}

class _ContratoSavePageState extends State<ContratoSavePage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCompradorController = TextEditingController();
  final _nombrePropietarioController = TextEditingController();
  final _precioController = TextEditingController();
  final _metodoPagoController = TextEditingController();
  final _agenteEncargadoController = TextEditingController();
  final _direccionInmuebleController = TextEditingController();

  // Método para crear el PDF del contrato
  Future<void> _crearPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Contrato de Compra-Venta',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Nombre del Comprador: ${_nombreCompradorController.text}'),
              pw.Text(
                  'Nombre del Propietario: ${_nombrePropietarioController.text}'),
              pw.Text('Precio: ${_precioController.text}'),
              pw.Text('Método de Pago: ${_metodoPagoController.text}'),
              pw.Text('Agente Encargado: ${_agenteEncargadoController.text}'),
              pw.Text(
                  'Dirección del Inmueble: ${_direccionInmuebleController.text}'),
              pw.SizedBox(height: 20),
              pw.Text('Firma del Comprador: ___________________'),
              pw.Text('Firma del Propietario: ___________________'),
              pw.SizedBox(height: 20),
              // Justificar el texto con RichText
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Expanded(
                  child: pw.RichText(
                    text: pw.TextSpan(
                      style: pw.TextStyle(fontSize: 12),
                      text:
                          'Nota: Este es un contrato provisional para hacerlo legal y establecerlo como tal le rogamos apersonarse por la empresa INMOBILIARIA INMOVIVA S.A. para establecer el acuerdo entre ambas partes tanto como comprador y vendedor de acuerdo en lo establecido ala ley de Transacciones de INMUEBLES art. 46 parrafo 16.',
                    ),
                    textAlign: pw.TextAlign.justify, // Justificar el texto
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory(); // Directorio adecuado para guardar el archivo
    final file = File("${directory.path}/contrato_compra_venta.pdf");

    await file.writeAsBytes(await pdf.save());
    print("PDF guardado en: ${file.path}");
  }

  // Método para imprimir el contrato
  void _imprimirContrato() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Contrato de Compra-Venta',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(
                  'Nombre del Comprador: ${_nombreCompradorController.text}'),
              pw.Text(
                  'Nombre del Propietario: ${_nombrePropietarioController.text}'),
              pw.Text('Precio: ${_precioController.text}'),
              pw.Text('Método de Pago: ${_metodoPagoController.text}'),
              pw.Text('Agente Encargado: ${_agenteEncargadoController.text}'),
              pw.Text(
                  'Dirección del Inmueble: ${_direccionInmuebleController.text}'),
              pw.SizedBox(height: 20),
              pw.Text('Firma del Comprador: ___________________'),
              pw.Text('Firma del Propietario: ___________________'),
              pw.Text(
                  'Nota: Este es un contrato provisional para hacerlo legal y establecerlo como tal le rogamos apersonarse por la empresa INMOBILIARIA INMOVIVA S.A. para establecer el acuerdo entre ambas partes tanto como comprador y vendedor de acuerdo en lo establecido ala ley de Transacciones de INMUEBLES art. 46 parrafo 16'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Contrato Compra-Venta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombreCompradorController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Comprador',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del comprador';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _nombrePropietarioController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Propietario',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del propietario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _precioController,
                        decoration: InputDecoration(
                          labelText: 'Precio',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el precio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _metodoPagoController,
                        decoration: InputDecoration(
                          labelText: 'Método de Pago',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el método de pago';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _agenteEncargadoController,
                        decoration: InputDecoration(
                          labelText: 'Agente Encargado',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el nombre del agente encargado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _direccionInmuebleController,
                        decoration: InputDecoration(
                          labelText: 'Dirección del Inmueble',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese la dirección del inmueble';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _crearPDF(); // Guardar como PDF
                    _imprimirContrato(); // Imprimir contrato
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Contrato guardado e impreso')),
                    );
                  }
                },
                icon: const Icon(Icons.print),
                label: const Text('Generar Contrato'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors
                      .blueAccent, // Usar backgroundColor en lugar de primary
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
