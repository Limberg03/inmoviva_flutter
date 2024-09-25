import 'package:flutter/material.dart';
import 'package:inmoviva/screens/login/home_screen.dart';
import 'package:inmoviva/screens/login/inicio.dart';

//clase principal
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//lo que se visualizará
class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    var d = const Duration(seconds: 2);

    Future.delayed(d, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const Inicio();
        }),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('INMOVIVA'),
        backgroundColor: const Color.fromARGB(255, 68, 101, 128),
      ),
      body: const Center(
        child: Image(
          image: AssetImage('assets/utils/splash.png'),
          fit: BoxFit.cover, //para  que se acomode ?
          width: 200, // ancho
          height: 200, //altura
        ),
      ),
    );
  }
}
