import 'package:flutter/material.dart';
import 'package:inmoviva/components/components.dart';
import 'package:inmoviva/screens/cliente/perfil_page.dart';
import 'package:inmoviva/screens/screens.dart';
import 'package:inmoviva/screens/tipopropiedad/save_page.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:inmoviva/screens/inventario/inventario_list_page.dart' as inventario;
import 'package:inmoviva/screens/inventario/inventario_form_page.dart';
import 'package:inmoviva/screens/busqueda/filtro_busqueda_page.dart';
import 'package:inmoviva/screens/busqueda/inventario_page.dart';
import 'package:inmoviva/screens/busqueda/detalles_inventario.dart';

// Importamos las páginas para gestionar ciudades
import 'package:inmoviva/screens/ciudad/save_page_ciudad.dart';
import 'package:inmoviva/screens/ciudad/list_page_ciudad.dart';
import 'package:inmoviva/screens/propiedad/propiedad_form_page.dart'; // Asegúrate de usar la ruta correcta
import 'package:inmoviva/screens/propiedad/propiedad_list_page.dart' as propiedad; 
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:inmoviva/screens/pago/simulated_payment_page.dart';
import 'package:inmoviva/screens/venta/venta_list_page.dart';
import 'package:inmoviva/screens/venta/venta_form_page.dart';
import 'package:inmoviva/screens/anticretico/anticretico_list_page.dart';
import 'package:inmoviva/screens/anticretico/anticretico_form_page.dart';
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
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto SI2..',
      initialRoute: 'splash',
      routes: {
        'home': (_) => const HomeScreen(),
        'splash': (_) => const SplashScreen(),
        'login': (_) => const LoginScreen(),
        'inicio': (_) => const Inicio(),
        '/save': (_) => SavePage(),
        'perfil': (_) => const PerfilPage(),
        
        // Rutas de Inventario
        '/inventario_list': (_) => inventario.InventarioListPage(),
        '/inventario_form': (_) => InventarioFormPage(),

        '/propiedad_list': (_) => propiedad.PropiedadListPage(),
        '/propiedad_form': (_) => PropiedadFormPage(),
        // Rutas de Búsqueda
        '/filtro_busqueda': (_) => FiltroBusquedaPage(),
        '/inventario_page': (_) => InventarioPage(),
        '/detalles_inventario': (context) => DetallesInventarioPage(),
        
        // Añadimos las rutas para gestionar ciudades
        '/ciudad_list': (_) => ListPageCiudad(),
        '/ciudad_save': (_) => SavePageCiudad(),

        // Nueva ruta para simulación de pago
        '/simulated_payment': (_) => SimulatedPaymentPage(),
        '/ventas': (_) => VentaListPage(),
        '/venta_form': (_) => VentaFormPage(),
        '/anticreticos': (_) => AnticreticoListPage(),
        '/anticretico_form': (_) => AnticreticoFormPage(),

        
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[400],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.red)),
    );
  }
}
