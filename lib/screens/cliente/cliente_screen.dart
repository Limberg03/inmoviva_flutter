import 'package:flutter/material.dart';


class ClienteScreen extends StatelessWidget {
  const ClienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter + material'),
      ),
      body: _PerfilView(),
    );
  }
}

class _PerfilView extends StatelessWidget {
  const _PerfilView();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}