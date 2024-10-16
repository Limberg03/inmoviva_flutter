class Propiedad {
  int? id;
  String? nombre;
  String? fecha;
  String? direccion;
  double? precio;
  String? estado;
  double? superficie;
  String? descripcion;
  int? nroHabitaciones;
  int? nroBanos;
  String? imagen; // Almacena solo una imagen
  int? tipoPropiedadId;

  Propiedad({
    this.id,
    this.nombre,
    this.fecha,
    this.direccion,
    this.precio,
    this.estado,
    this.superficie,
    this.descripcion,
    this.nroHabitaciones,
    this.nroBanos,
    this.imagen, // Inicializamos con una imagen
    this.tipoPropiedadId,
  });

  // Método para convertir una propiedad a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fecha': fecha,
      'direccion': direccion,
      'precio': precio,
      'estado': estado,
      'superficie': superficie,
      'descripcion': descripcion,
      'nro_habitaciones': nroHabitaciones,
      'nro_banos': nroBanos,
      'imagen': imagen,
      'tipo_propiedad_id': tipoPropiedadId,
    };
  }

  // Constructor para convertir un mapa a una propiedad
  factory Propiedad.fromMap(Map<String, dynamic> map) {
    return Propiedad(
      id: map['id'],
      nombre: map['nombre'],
      fecha: map['fecha'],
      direccion: map['direccion'],
      precio: map['precio'],
      estado: map['estado'],
      superficie: map['superficie'],
      descripcion: map['descripcion'],
      nroHabitaciones: map['nro_habitaciones'],
      nroBanos: map['nro_banos'],
      imagen: map['imagen'],
      tipoPropiedadId: map['tipo_propiedad_id'],
    );
  }
}

