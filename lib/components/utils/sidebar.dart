import 'package:flutter/material.dart';
import 'package:inmoviva/screens/screens.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

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
                  //para redireccionar inicio sesion
                }),
          ]);
        } else {
          return ListView(children: [
            UserAccountsDrawerHeader(
              accountName: Text(auth.user.name),
              accountEmail: Text(auth.user.email),
              currentAccountPicture: CircleAvatar(
                // child: ClipOval(
                //   child: Image.network(
                //     'https://c0.klipartz.com/pngpicture/266/82/gratis-png-programador-iconos-de-computadora-programacion-de-computadora-avatar-lenguaje-de-programacion-avatar.png',
                //     width: 90,
                //     height: 90,
                //     fit: BoxFit.cover,
                //   ),
                // ),
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
