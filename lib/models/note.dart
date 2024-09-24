class Note {
  final int id;
  final String nombre;
  final String descripcion;

  Note({ required this.id, required this.nombre, required this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
