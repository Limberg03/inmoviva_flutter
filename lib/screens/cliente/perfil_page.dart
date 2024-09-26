import 'package:flutter/material.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<AuthService>(
          builder: (context, auth, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Contenedor que ocupa todo el ancho y centra el contenido
                Container(
                  width: double.infinity, // Ocupa todo el ancho de la pantalla
                  alignment: Alignment.topCenter, // Centra los elementos horizontalmente
                  child: Column(
                    children: [
                      // Contenedor con borde circular azul alrededor de la foto de perfil
                      Container(
                        width: 120, // Aumenta el tamaño total de la imagen
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue, // Color del borde
                            width: 4.0, // Grosor del borde
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 54, // Tamaño de la imagen dentro del marco
                          backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyXeKDN29AmZgZPLS7n0Bepe8QmVappBwZCeA3XWEbWNdiDFB',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nombre del usuario en negrita y más grande
                      Text(
                        auth.user.name,
                        style: const TextStyle(
                          fontSize: 22, // Tamaño de letra más grande
                          fontWeight: FontWeight.bold, // Texto en negrita
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Correo electrónico del usuario con tono más oscuro
                      Text(
                        auth.user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 60, 60, 60), // Tono más oscuro
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      // Botones adicionales en columnas
                      Column(
                        children: [
                          _buildProfileOptionButton(
                            icon: Icons.credit_card,
                            label: 'Métodos de Pago',
                            onPressed: () {}, // Acción vacía
                          ),
                          const SizedBox(height: 10),
                          _buildProfileOptionButton(
                            icon: Icons.camera_alt,
                            label: 'Subir Foto de Perfil',
                            onPressed: () {}, // Acción vacía
                          ),
                          const SizedBox(height: 10),
                          _buildProfileOptionButton(
                            icon: Icons.notifications,
                            label: 'Notificaciones y Preferencias',
                            onPressed: () {}, // Acción vacía
                          ),
                          const SizedBox(height: 10),
                          _buildProfileOptionButton(
                            icon: Icons.delete_forever,
                            label: 'Eliminar Cuenta',
                            onPressed: () => _showDeleteConfirmationDialog(context), // Acción para mostrar el diálogo de confirmación
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Método para construir los botones de opciones
  Widget _buildProfileOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: const TextStyle(color: Colors.blue), // Texto en azul
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Fondo blanco
        minimumSize: const Size(double.infinity, 50), // Ancho total y altura fija
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes menos ovalados
        ),
        alignment: Alignment.centerLeft, // Icono y texto alineados a la izquierda
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación de eliminación
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Está seguro de eliminar su cuenta?'),
          content: const Text(
            'Al aceptar, se eliminarán los datos almacenados en su cuenta.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                // Aquí puedes agregar la lógica para eliminar la cuenta del usuario
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }
}
