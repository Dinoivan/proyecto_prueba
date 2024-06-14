import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/ubicacation_model.dart';

import 'dart:convert';

Future<Emergency> EnviarEnlace(int? userId,UbicationURL ubicationURL, String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/citizen/activateEmergencyBtn/$userId';

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode(ubicationURL.toJson()),
    );
    if (response.statusCode == 200) {
      return Emergency(statusCode: response.statusCode);
    }else
      {
        return Emergency(statusCode: response.statusCode);
      }
  } catch (e) {
    throw Exception("Error al activar boton de emergencia: $e");
  }
}



