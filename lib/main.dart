import 'package:flutter/material.dart';
import 'package:inmoviva/components/components.dart';
import 'package:inmoviva/screens/cliente/perfil_page.dart';
import 'package:inmoviva/screens/screens.dart';
import 'package:inmoviva/screens/tipopropiedad/save_page.dart';
import 'package:inmoviva/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

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
        'login': (_) => const LoginScreen(), /* ruta*/

        'inicio': (_) => const Inicio(),

        '/save': (_) =>  SavePage(),
        'perfil': (_)=> const PerfilPage(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[400],
          appBarTheme: const AppBarTheme(elevation: 0, color: Colors.red)),
    );
  }
}
