import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<CitizenResponse> saveCitizen(Citizen citizen) async{
  final url = Uri.parse('${ApiConfig.baseUrl}/v1/citizen/saveCitizen');

  try{
    final response = await http.post(url,
    headers: {
      'Content-type': 'application/json',
    },
      body:jsonEncode(citizen.toJson()),
    );

    final String message = response.body;

    if(response.statusCode == 200){
      return CitizenResponse(statusCode: response.statusCode,message:message);
    }else{
      throw Exception(message);
    }
  }catch(e){
    throw Exception('Error al registrase: $e');
  }
}