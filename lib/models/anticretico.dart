class Anticretico {
  int? id;
  int? inventarioId; // Foránea a la tabla inventarios
  String? arrendatario; // Persona que recibe la propiedad en anticrético
  double? montoAnticretico; // Monto pagado por adelantado (anticrético)
  String? metodoPago; // Método de pago
  String? fechaInicio; // Fecha de inicio del anticrético
  String? fechaFin; // Fecha de finalización del anticrético
  String? contratoPdf; // Ruta del contrato en PDF (si aplica)

  Anticretico({
    this.id,
    this.inventarioId,
    this.arrendatario,
    this.montoAnticretico,
    this.metodoPago,
    this.fechaInicio,
    this.fechaFin,
    this.contratoPdf,
  });

  // Convertir a mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inventario_id': inventarioId,
      'arrendatario': arrendatario,
      'monto_anticretico': montoAnticretico,
      'metodo_pago': metodoPago,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'contrato_pdf': contratoPdf,
    };
  }

  // Constructor para convertir desde un mapa
  factory Anticretico.fromMap(Map<String, dynamic> map) {
    return Anticretico(
      id: map['id'],
      inventarioId: map['inventario_id'],
      arrendatario: map['arrendatario'],
      montoAnticretico: map['monto_anticretico'],
      metodoPago: map['metodo_pago'],
      fechaInicio: map['fecha_inicio'],
      fechaFin: map['fecha_fin'],
      contratoPdf: map['contrato_pdf'],
    );
  }
}
