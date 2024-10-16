import 'package:flutter/material.dart';
import 'package:inmoviva/screens/screens.dart';
import 'package:inmoviva/screens/tipopropiedad/list_page.dart';
import 'package:inmoviva/screens/tipopropiedad/save_page.dart';
import 'package:inmoviva/screens/propiedad/propiedad_list_page.dart';
//import 'package:inmoviva/screens/propiedad/propiedad_save_page.dart'; // Asegúrate de importar la página de lista de propiedades
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:inmoviva/screens/busqueda/inventario_page.dart';
import 'package:inmoviva/screens/busqueda/filtro_busqueda_page.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(builder: (context, auth, child) {
        if (!auth.authentificated) {
          return ListView(children: [
            ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesion'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                  // para redireccionar inicio sesion
                }),
          ]);
        } else {
          return ListView(children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.user.name),
              accountEmail: Text(auth.user.email),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/utils/perfil.png', // Ruta de la imagen en los assets locales
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/utils/sidebar.jpg'),
                fit: BoxFit.cover,
              )),
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Inicio()));
                }),
            const Divider(
              thickness: 3,
              indent: 15, // izq
              endIndent: 15, // derecha
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                }),
            ExpansionTile(
              leading: const Icon(Icons.person),
              title: const Text('Módulo de Usuario'),
              children: [
                ListTile(
                  leading: const Icon(Icons.manage_accounts),
                  title: const Text('Gestionar Usuarios'),
                  onTap: () {
                    print('Gestionar Usuarios');
                    // Navegar a la página de gestión de usuarios
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people_alt),
                  title: const Text('Gestionar Clientes'),
                  onTap: () {
                    print('Gestionar Clientes');
                    // Navegar a la página de gestión de clientes
                  },
                ),
              ],
            ),
            ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('Gestionar Formulario'),
                onTap: () {
                  print('Click Formulario');
                }),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Gestionar Tipo de Propiedad'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory), // Icono de inventario
              title: const Text('Gestionar Inventario'),
              onTap: () {
                // Navegar a la lista de inventarios usando la ruta que definimos en el main
                Navigator.pushNamed(context, '/inventario_list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_alt),
              title: const Text('Búsqueda Avanzada'),
              onTap: () {
                // Navegar a la página de búsqueda avanzada
                Navigator.pushNamed(context, '/inventario_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.house), // Icono para propiedades
              title: const Text('Gestionar Propiedades'), // Título de la opción
              onTap: () {
                // Navegar a la lista de propiedades usando la ruta que definimos en el main
                Navigator.pushNamed(context, '/propiedad_list'); // Cambia esta ruta según corresponda
              },
            ),
            ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir'),
                onTap: () {
                  print('Click compartido');
                }),
          ]);
        }
      }),
    );
  }
}
