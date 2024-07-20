import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Aquí debes implementar tu lógica de autenticación contra la base de datos
  Future<bool> login(String username, String password) async {
    // Simulación de la verificación de credenciales en la base de datos
    await Future.delayed(Duration(seconds: 2)); // Simulación de una llamada a la base de datos

    if (username == 'sansomon' && password == '2017') {
      return true;
    } else {
      return false;
    }
  }
}
