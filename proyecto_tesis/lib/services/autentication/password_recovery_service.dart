import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/autentication/password_recovery_model.dart';
import 'dart:convert';

Future<PasswordRecoveryResponse> passwordRecoveryService(String email) async{
  final passwordRecoveryModel = PasswordRecoveryModel(email: email);
  try{
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v1/auth/requestPasswordChange/$email'),
      headers:{
        'Content-Type': 'application/json',
      },
      body:jsonEncode(passwordRecoveryModel),
    );

    final String message = response.body;

    if(response.statusCode == 200){
      return PasswordRecoveryResponse(statusCode: response.statusCode, message: message);
    }else{
      throw Exception(message);
    }

  }catch(e){
    throw Exception("Error al enviar codigo: $e");
  }
}