import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/autentication/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<LoginResponse> loginService(String email, String password) async{

  final loginModel = LoginModel(email: email, password: password);

  try{
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/auth/login'),
    headers: {
      'Content-Type': 'application/json',
    },
      body:jsonEncode(loginModel),
    );

    if(response.statusCode == 200){
      final token = json.decode(response.body)['token'];
      return LoginResponse(token: token, statusCode: response.statusCode);
    }else{
      return LoginResponse(statusCode: response.statusCode);
    }
  }catch(e){
    throw Exception('Error al inicial sesión: $e');
  }
}





