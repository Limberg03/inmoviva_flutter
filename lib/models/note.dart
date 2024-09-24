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
}
