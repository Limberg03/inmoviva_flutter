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

void main() {
  runApp(const AppState());
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

        // Rutas de Búsqueda
        '/filtro_busqueda': (_) => FiltroBusquedaPage(),
        '/inventario_page': (_) => InventarioPage(),
        '/detalles_inventario': (context) => DetallesInventarioPage(),
        
        // Añadimos las rutas para gestionar ciudades
        '/ciudad_list': (_) => ListPageCiudad(),
        '/ciudad_save': (_) => SavePageCiudad(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[400],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.red)),
    );
  }
}
