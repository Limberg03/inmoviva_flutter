class Note {
  int? id; // El signo de interrogación indica que puede ser nulo.
  String nombre; // Puede ser nulo.
  String? descripcion; // Puede ser nulo.

  Note({this.id, required this.nombre, this.descripcion});
  Note.empty() : nombre = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  // Método para convertir un Map en un objeto Note (al obtener desde la base de datos)
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'], // Obtener el id del mapa
      nombre: map['nombre'], // Obtener el nombre
      descripcion: map['descripcion'], // Obtener la descripción si existe
    );
  }
}
