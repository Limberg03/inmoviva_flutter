class Contrato {
  String? nombreComprador;
  String? nombrePropietario;
  double? precio;
  String? metodoPago;
  String? agenteEncargado;

  Contrato({
    this.nombreComprador,
    this.nombrePropietario,
    this.precio,
    this.metodoPago,
    this.agenteEncargado,
  });

  // Método para convertir de un mapa (por ejemplo, desde una base de datos) a un objeto Contrato
  factory Contrato.fromMap(Map<String, dynamic> map) {
    return Contrato(
      nombreComprador: map['nombreComprador'],
      nombrePropietario: map['nombrePropietario'],
      precio: map['precio'],
      metodoPago: map['metodoPago'],
      agenteEncargado: map['agenteEncargado'],
    );
  }

  // Método para convertir el objeto Contrato a un mapa (para guardarlo en una base de datos)
  Map<String, dynamic> toMap() {
    return {
      'nombreComprador': nombreComprador,
      'nombrePropietario': nombrePropietario,
      'precio': precio,
      'metodoPago': metodoPago,
      'agenteEncargado': agenteEncargado,
    };
  }
}
