import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';

Future<List<String>?> getReportPrediction(int? id, String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/pattern-recognition/getReportPrediction';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': id.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      // Dividir la respuesta por la coma para obtener una lista de elementos
      List<String> elementos = responseBody.split(',');
      return elementos;
    } else {
      // En caso de que la solicitud no sea exitosa, devolver nulo
      return null;
    }
  } catch (e) {
    // Capturar cualquier error y devolverlo como una lista con un solo elemento
    return ["Error al obtener el informe de predicción: $e"];
  }
}