import 'package:flutter/material.dart';
import 'package:inmoviva/db/db_helper.dart';
import 'package:inmoviva/models/anticretico.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa para abrir el PDF
import 'package:inmoviva/screens/pago/simulated_payment_page.dart'; 

class AnticreticoListPage extends StatefulWidget {
  @override
  _AnticreticoListPageState createState() => _AnticreticoListPageState();
}

class _AnticreticoListPageState extends State<AnticreticoListPage> {
  List<Anticretico> anticreticos = [];
  final DBHelper _dbHelper = DBHelper();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnticreticos();
  }

  Future<void> _loadAnticreticos() async {
    setState(() {
      isLoading = true;
    });

    List<Anticretico> loadedAnticreticos = await _dbHelper.getAnticreticos();
    print('Anticréticos cargados: ${loadedAnticreticos.length}');
    setState(() {
      anticreticos = loadedAnticreticos;
      isLoading = false;
    });
  }

  void _confirmDelete(BuildContext context, int anticreticoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar este anticrético?"),
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
                await _dbHelper.deleteAnticretico(anticreticoId);
                _loadAnticreticos();
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

  void _navigateToAnticreticoForm() async {
    final result = await Navigator.pushNamed(context, '/anticretico_form');
    if (result != null) {
      _loadAnticreticos(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Anticréticos"),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAnticreticoForm,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : anticreticos.isEmpty
              ? Center(child: Text('No hay anticréticos registrados'))
              : ListView.builder(
                  itemCount: anticreticos.length,
                  itemBuilder: (context, index) {
                    final anticretico = anticreticos[index];
                    return Dismissible(
                      key: Key(anticretico.id.toString()),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _confirmDelete(context, anticretico.id!);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.home_work,
                            color: Colors.blue[800],
                            size: 36.0,
                          ),
                          title: Text(
                            anticretico.arrendatario ?? 'Sin arrendatario',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monto: ${anticretico.montoAnticretico?.toStringAsFixed(2) ?? 'No disponible'} USD',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                              Text(
                                'Método de pago: ${anticretico.metodoPago ?? 'No especificado'}',
                                style: TextStyle(color: Colors.orange[700]),
                              ),
                              Text(
                                'Fecha Inicio: ${anticretico.fechaInicio ?? 'Sin fecha'}',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              Text(
                                'Fecha Fin: ${anticretico.fechaFin ?? 'Sin fecha'}',
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
                                  _confirmDelete(context, anticretico.id!);
                                },
                              ),
                              // Mostrar el botón de PDF si existe el contrato
                              if (anticretico.contratoPdf != null &&
                                  anticretico.contratoPdf!.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.picture_as_pdf, color: Colors.blue),
                                  onPressed: () {
                                    _openPDF(anticretico.contratoPdf!);
                                  },
                                ),
                              // Botón para pagar
                              IconButton(
                                icon: Icon(Icons.payment, color: Colors.green),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SimulatedPaymentPage(
                                        monto: anticretico.montoAnticretico ?? 0.0,
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
