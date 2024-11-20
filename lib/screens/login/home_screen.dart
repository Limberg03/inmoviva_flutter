import 'package:flutter/material.dart';
import 'package:inmoviva/components/components.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inmoviva/screens/cliente/perfil_page.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    readToken();
    super.initState();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    Provider.of<AuthService>(context, listen: false).trytoken(token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue[700],
        actions: [
          // Círculo que redirecciona al perfil
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Navegar a la página de perfil
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PerfilPage(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.blue[700],
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sección de Propiedades en Venta
            _buildSectionTitle('Propiedades en Venta'),
            _buildHorizontalList([
              'Casa en Santa Cruz ',
              'Departamento en Cochabamba',
            ]),

            // Sección de Propiedades en Alquiler
            _buildSectionTitle('Propiedades en Alquiler'),
            _buildHorizontalList([
              'Casa en Alquiler - Sucre',
              'Departamento en Alquiler - Tarija',
            ]),

            // Sección de Mis Propiedades
            _buildSectionTitle('Mis Propiedades'),
            _buildPropertyList([
              'Mi Casa en La Paz',
              'Mi Terreno en Oruro',
            ]),
          ],
        ),
      ),
    );
  }

  // Widget para crear el título de cada sección
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget para crear una lista horizontal de propiedades
  Widget _buildHorizontalList(List<String> properties) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return Card(
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, size: 40, color: Colors.blue[700]),
                  const SizedBox(height: 8),
                  Text(
                    properties[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget para la lista de propiedades del usuario
  Widget _buildPropertyList(List<String> properties) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.home, color: Colors.blue[700]),
          title: Text(properties[index]),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[700]),
          onTap: () {
            // Acción al presionar una propiedad
          },
        );
      },
    );
  }
}
