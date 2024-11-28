import 'package:flutter/material.dart';

class SimulatedPaymentPage extends StatefulWidget {
  double monto;

  SimulatedPaymentPage({this.monto = 100.00});

  @override
  _SimulatedPaymentPageState createState() => _SimulatedPaymentPageState();
}

class _SimulatedPaymentPageState extends State<SimulatedPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _montoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = "Pago de ...";
    _montoController.text = widget.monto.toStringAsFixed(2); // Inicializamos el monto
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Pago realizado"),
            content: Text("El pago de ${widget.monto.toStringAsFixed(2)} USD se ha realizado con éxito."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Aceptar"),
              ),
            ],
          );
        },
      );

      // Limpia los campos tras el pago simulado
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pago con Tarjeta"),
        backgroundColor: const Color.fromARGB(255, 29, 36, 225),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo editable para monto
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Monto",
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa un monto.";
                  }
                  double? parsedMonto = double.tryParse(value);
                  if (parsedMonto == null || parsedMonto <= 0) {
                    return "El monto debe ser mayor que 0.";
                  }
                  widget.monto = parsedMonto; // Actualizamos el monto
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Descripción",
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa una descripción.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Número de Tarjeta",
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingresa el número de tarjeta.";
                  }
                  if (value.length < 16) {
                    return "El número de tarjeta debe tener 16 dígitos.";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "Fecha de Vencimiento (MM/AA)",
                        prefixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa la fecha de vencimiento.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "CVV",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa el CVV.";
                        }
                        if (value.length != 3) {
                          return "El CVV debe tener 3 dígitos.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 12, 26),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text("Procesar Pago", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
