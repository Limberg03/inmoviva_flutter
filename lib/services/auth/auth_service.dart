import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inmoviva/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:inmoviva/services/services.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggerdIn = false; //no esta logueado al entrar desde el movil
  User? _user; // ? el puede ser nulo, no puede existir
  String? _token;

  bool get authentificated => _isLoggerdIn; //para retonar si esta f o true
  User get user => _user!;
  Servidor servidor = Servidor();

  final _storage =
      const FlutterSecureStorage(); // para guardar la caché del móvil

  // func asincrona ->
  Future<String> login(
      String email, String password, String device_name) async {
    try {
      final response =
          await http.post(Uri.parse('${servidor.printUrl}/sanctum/token'),
              body: ({
                'email': email,
                'password': password,
                'device_name': device_name,
              }));

      if (response.statusCode == 200) {
        String token = response.body.toString();
        trytoken(token);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }

    
  }

  void trytoken(String? token) async {  //notf si existe el token
    if (token == null) {
      return;
    } else {
      try {
        final response = await http.get(Uri.parse('${servidor.printUrl}/user'),
            headers: {'Authorization': 'Bearer $token'});
        print(response.body);
        _isLoggerdIn = true;
        _user = User.fromJson(jsonDecode(response.body));
        _token = token;
        //cache del móvil
        storeToken(token);

        notifyListeners(); //para que el servicio sea ejecutado en todo el py
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken(String token) async {
    _storage.write(key: 'token', value: token);
  }

  //desloguearse
  void logout() async {
    try {
      final response = await http.get(
          Uri.parse('${servidor.printUrl}/user/revoke'),
          headers: {'Authorization': 'Bearer $_token'});
      cleanUp();
      notifyListeners(); //para que el servicio sea ejecutado en todo el py
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async // funcion asincrono
  {
    _user = null;
    _isLoggerdIn = false;
    _user = null;
    //limpiar
    await _storage.delete(key: 'token');
  }
}
