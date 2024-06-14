import'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/autentication/password_change_model.dart';
import 'dart:convert';

Future<PasswordChangeResponse> passwordChangeService(String email,String newPassword, int token) async{

  final passwordChangeModel = PasswordChangeModel(email: email, newPassword: newPassword, token: token);

  try{
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/auth/changePassword'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(passwordChangeModel),
    );

    final String message = response.body;

    if(response.statusCode == 200){
      return PasswordChangeResponse(statusCode: response.statusCode, message: message);
    }else{
      throw Exception(message);
    }

  }catch(e){
    throw Exception("Error $e");
  }
}