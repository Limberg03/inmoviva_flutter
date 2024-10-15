// models/ciudad.dart

class Ciudad {
  int? id;
  String nombre;
  String? descripcion;

  Ciudad({this.id, required this.nombre, this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  factory Ciudad.fromMap(Map<String, dynamic> map) {
    return Ciudad(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
    );
  }
}
