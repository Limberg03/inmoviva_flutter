class Venta {
  int? id;
  int? inventarioId; // Foránea a la tabla inventarios
  String? comprador;
  double? precio;
  String? metodoPago;
  String? fechaTransaccion;
  String? documentoPdf; // Ruta del PDF adjunto

  Venta({
    this.id,
    this.inventarioId,
    this.comprador,
    this.precio,
    this.metodoPago,
    this.fechaTransaccion,
    this.documentoPdf,
  });

  // Convertir a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inventario_id': inventarioId,
      'comprador': comprador,
      'precio': precio,
      'metodo_pago': metodoPago,
      'fecha_transaccion': fechaTransaccion,
      'documento_pdf': documentoPdf,
    };
  }

  // Constructor para convertir desde un mapa
  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      id: map['id'],
      inventarioId: map['inventario_id'],
      comprador: map['comprador'],
      precio: map['precio'],
      metodoPago: map['metodo_pago'],
      fechaTransaccion: map['fecha_transaccion'],
      documentoPdf: map['documento_pdf'],
    );
  }
}
