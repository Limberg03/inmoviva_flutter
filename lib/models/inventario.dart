class Inventario {
  int? id;
  String? fechaPublicacion;
  String? direccion;
  double? precio;
  String? estado;
  double? superficie;
  String? descripcion;
  int? nroHabitaciones;
  int? nroBanos;
  List<String>? imagenes; // List<String> para manejar varias imágenes
  int? tipoPropiedadId;

  Inventario({
    this.id,
    this.fechaPublicacion,
    this.direccion,
    this.precio,
    this.estado,
    this.superficie,
    this.descripcion,
    this.nroHabitaciones,
    this.nroBanos,
    this.imagenes, // Inicializamos con una lista de imágenes
    this.tipoPropiedadId,
  });

  // Método para convertir un inventario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_publicacion': fechaPublicacion,
      'direccion': direccion,
      'precio': precio,
      'estado': estado,
      'superficie': superficie,
      'descripcion': descripcion,
      'nro_habitaciones': nroHabitaciones,
      'nro_banos': nroBanos,
      'imagenes': imagenes?.join(','), // Almacenamos como una cadena separada por comas
      'tipo_propiedad_id': tipoPropiedadId,
    };
  }

  // Constructor para convertir un mapa a un inventario
  factory Inventario.fromMap(Map<String, dynamic> map) {
    return Inventario(
      id: map['id'],
      fechaPublicacion: map['fecha_publicacion'],
      direccion: map['direccion'],
      precio: map['precio'],
      estado: map['estado'],
      superficie: map['superficie'],
      descripcion: map['descripcion'],
      nroHabitaciones: map['nro_habitaciones'],
      nroBanos: map['nro_banos'],
      imagenes: (map['imagenes'] as String?)?.split(','), // Convertimos la cadena de nuevo a una lista
      tipoPropiedadId: map['tipo_propiedad_id'],
    );
  }
}
