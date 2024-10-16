import 'package:flutter/material.dart';
import 'package:inmoviva/components/components.dart';
import 'package:inmoviva/screens/cliente/perfil_page.dart';
import 'package:inmoviva/screens/screens.dart';
import 'package:inmoviva/screens/tipopropiedad/save_page.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:inmoviva/screens/inventario/inventario_list_page.dart' as inventario; // Importa la página de lista de inventarios
import 'package:inmoviva/screens/inventario/inventario_form_page.dart'; // Importa la página del formulario de inventario

import 'package:inmoviva/screens/busqueda/filtro_busqueda_page.dart';
import 'package:inmoviva/screens/busqueda/inventario_page.dart';
import 'package:inmoviva/screens/busqueda/detalles_inventario.dart';
import 'package:inmoviva/screens/propiedad/propiedad_form_page.dart'; // Asegúrate de usar la ruta correcta
import 'package:inmoviva/screens/propiedad/propiedad_list_page.dart' as propiedad; 
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

void main() {
  tz.initializeTimeZones();
  runApp(const AppState());
}

// Función para obtener la hora de Bolivia
DateTime obtenerHoraBolivia() {
  final laPaz = tz.getLocation('America/La_Paz');
  final horaBolivia = tz.TZDateTime.now(laPaz);
  return horaBolivia;
}

// Función para formatear la hora de Bolivia
String formatearHoraBolivia() {
  final horaBolivia = obtenerHoraBolivia();
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(horaBolivia);
}

class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // para consumir todos los servicios
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto SI2..',
      initialRoute: 'splash',
      routes: {
        'home': (_) => const HomeScreen(),
        /* ruta*/
        'splash': (_) => const SplashScreen(),
        /* ruta*/
        'login': (_) => const LoginScreen(),
        /* ruta*/

        'inicio': (_) => const Inicio(),

        '/save': (_) => SavePage(),

        'perfil': (_) => const PerfilPage(),

        // Añadimos las rutas para Inventario
        '/inventario_list': (_) => inventario.InventarioListPage(),
        '/inventario_form': (_) => InventarioFormPage(),

        '/propiedad_list': (_) => propiedad.PropiedadListPage(),
        '/propiedad_form': (_) => PropiedadFormPage(),
        // Añadimos las rutas para Búsqueda
        '/filtro_busqueda': (_) => FiltroBusquedaPage(),
        '/inventario_page': (_) => InventarioPage(),
        '/detalles_inventario': (context) => DetallesInventarioPage(),

        
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[400],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.red)),
    );
  }
}
