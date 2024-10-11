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
  String? imagen; // Path de la imagen o URL

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
    this.imagen,
  });

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
      'imagen': imagen,
    };
  }

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
      imagen: map['imagen'],
    );
  }
}
