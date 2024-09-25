import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool isEditing = false; // Controla si el perfil está en modo edición o visualización
  TextEditingController nameController = TextEditingController(text: 'Nombre del Cliente');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Contenedor que ocupa todo el ancho y centra el contenido
            Container(
              width: double.infinity, // Ocupa todo el ancho de la pantalla
              alignment: Alignment.topCenter, // Centra los elementos horizontalmente
              child: Column(
                children: [
                  // Foto de perfil
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwyXeKDN29AmZgZPLS7n0Bepe8QmVappBwZCeA3XWEbWNdiDFB',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre editable o no editable según el modo
                  isEditing
                      ? TextField(
                          controller: nameController,
                          textAlign: TextAlign.center, // Centra el texto dentro del TextField
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          nameController.text,
                          textAlign: TextAlign.center, // Centra el texto
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                  const SizedBox(height: 10),

                  // Correo electrónico (no editable)
                  const Text(
                    'cliente@correo.com',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 116, 116, 116),
                    ),
                    textAlign: TextAlign.center, // Centra el correo
                  ),

                  const SizedBox(height: 30),

                  // Botón para alternar entre editar o guardar perfil
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing; // Cambiar entre edición y visualización
                      });
                    },
                    icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.black), // Ícono negro
                    label: Text(
                      isEditing ? 'Guardar' : 'Editar Perfil',
                      style: const TextStyle(color: Colors.black), // Texto negro
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
