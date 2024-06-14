import 'dart:async';
import 'package:proyecto_tesis/models/autentication/login_model.dart';
import 'package:proyecto_tesis/models/autentication/password_change_model.dart';
import 'package:proyecto_tesis/models/autentication/password_recovery_model.dart';
import 'package:proyecto_tesis/services/autentication/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_tesis/services/autentication/password_recovery_service.dart';
import '../../services/autentication/password_change_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthBloc {

  String? _token;

  Future<int?> login(String email, String password) async {
    LoginResponse response = await loginService(email, password);
    if (response.statusCode == 200 && response.token != null) {
      await _saveTokenToShareddPreferences(response.token!);
    }
    return response.statusCode;
  }

  Future<void> _saveTokenToShareddPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getStoraredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Decodificar el token para obtener la fecha de expiración
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      int? exp = decodedToken['exp'];

      print("Valor del token: $exp");

      // Verificar si el token ha caducado
      if (exp != null) {
        int currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (exp < currentTimeInSeconds) {
          // El token ha caducado, eliminarlo de SharedPreferences
          await prefs.remove('token');
          return null;
        }
      }
    }

    return token;
  }

  Future<void>resetToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<PasswordRecoveryResponse> passwordRecovery(String email) async{

    PasswordRecoveryResponse response = await passwordRecoveryService(email);

    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("Error");
    }
  }

  Future<PasswordChangeResponse> passwordChange(String email,String newPassword, int token) async{
    PasswordChangeResponse response =  await passwordChangeService(email, newPassword, token);

    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("Error");
    }
  }

  // Método para verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    // Si el token ya está guardado en la instancia, el usuario está autenticado
    if (_token != null) {
      return true;
    }
    // Si no, verifica si hay un token almacenado en SharedPreferences
    String? storedToken = await getStoraredToken();
    if (storedToken != null) {
      _token = storedToken;
      return true;
    }
    return false; // Si no hay token almacenado, el usuario no está autenticado
  }

  //Guardar la pantalla
  Future<void> saveLastScreem(String screemName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_screen', screemName);
  }

  Future<String?> getLastSCreem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_screen');
  }

}