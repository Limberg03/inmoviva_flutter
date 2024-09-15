import 'package:flutter/material.dart';

class loginformprovider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool _isLoading = false; // muy usado, para validación

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() // si el form es correcto (validación)
  {
    return formKey.currentState?.validate() ?? false; // ?? condicion terminario
  }
}
