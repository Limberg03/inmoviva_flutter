import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/venta.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa para lanzar el URL del PDF
import 'package:inmoviva/screens/pago/simulated_payment_page.dart'; 
class VentaListPage extends StatefulWidget {
  @override
  _VentaListPageState createState() => _VentaListPageState();
}

class _VentaListPageState extends State<VentaListPage> {
  List<Venta> ventas = [];
  final DBHelper _dbHelper = DBHelper();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVentas();
  }

  Future<void> _loadVentas() async {
    setState(() {
      isLoading = true;
    });

    List<Venta> loadedVentas = await _dbHelper.getVentas();
    print('Ventas cargadas: ${loadedVentas.length}');
    setState(() {
      ventas = loadedVentas;
      isLoading = false;
    });
  }

  void _confirmDelete(BuildContext context, int ventaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar esta venta?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () async {
                Navigator.of(context).pop();
                await _dbHelper.deleteVenta(ventaId);
                _loadVentas();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPDF(String pdfUrl) async {
    if (await canLaunch(pdfUrl)) {
      await launch(pdfUrl);
    } else {
      throw 'No se pudo abrir el PDF: $pdfUrl';
    }
  }

  void _navigateToVentaForm() async {
    final result = await Navigator.pushNamed(context, '/venta_form');
    if (result != null) {
      _loadVentas(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Ventas"),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToVentaForm, 
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ventas.isEmpty
              ? Center(child: Text('No hay ventas registradas'))
              : ListView.builder(
                  itemCount: ventas.length,
                  itemBuilder: (context, index) {
                    final venta = ventas[index];
                    return Dismissible(
                      key: Key(venta.id.toString()),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _confirmDelete(context, venta.id!);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.receipt_long,
                            color: Colors.blue[800],
                            size: 36.0,
                          ),
                          title: Text(
                            venta.comprador ?? 'Sin comprador',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio: ${venta.precio?.toStringAsFixed(2) ?? 'No disponible'} USD',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                              Text(
                                'Método de pago: ${venta.metodoPago ?? 'No especificado'}',
                                style: TextStyle(color: Colors.orange[700]),
                              ),
                              Text(
                                'Fecha: ${venta.fechaTransaccion ?? 'Sin fecha'}',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red[700]),
                                onPressed: () {
                                  _confirmDelete(context, venta.id!);
                                },
                              ),
                              // Mostrar el botón de PDF si existe la URL del PDF
                              if (venta.documentoPdf != null && venta.documentoPdf!.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
                                  onPressed: () {
                                    _openPDF(venta.documentoPdf!);
                                  },
                                ),
                              // Botón para redirigir a la página de pago con tarjeta
                              IconButton(
                                icon: Icon(Icons.payment, color: Colors.green),
                                onPressed: () {
                                  //_navigateToPayment(venta.precio ?? 0.0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SimulatedPaymentPage(
                                        monto: venta.precio ?? 0.0,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
