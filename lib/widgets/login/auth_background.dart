import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [_PurpleBox(), _HeaderIcon(), child],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30), // margen superior del ícono
          Center(
            child: SizedBox(
              width: 150,
              child: Image(
                image: AssetImage('assets/utils/inmobiliaria.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 70, left: 30, child: _Bubble(size: 100, color: Colors.white.withOpacity(0.2))),
          Positioned(top: -40, left: -30, child: _Bubble(size: 80, color: Colors.white.withOpacity(0.15))),
          Positioned(top: -50, right: 20, child: _Bubble(size: 60, color: Colors.white.withOpacity(0.15))),
          Positioned(bottom: -50, left: 10, child: _Bubble(size: 90, color: Colors.white.withOpacity(0.2))),
          Positioned(bottom: -30, right: 90, child: _Bubble(size: 70, color: Colors.white.withOpacity(0.2))),
          Positioned(bottom: 120, right: 30, child: _Bubble(size: 50, color: Colors.white.withOpacity(0.1))),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
    gradient: LinearGradient(colors: [
      Color(0xFF002B5B),
      Color(0xFF4285F4),
    ]),
  );
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({Key? key, required this.size, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
    );
  }
}
