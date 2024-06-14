import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/questionaire_model.dart';


Future<List<String>?> GetCuestionarios(String? token) async {
  try {
    final response = await http.
    get(Uri.parse('${ApiConfig.baseUrl}/v1/questionnaire/getAllQuestions'),
        headers: {
          'Authorization': '$token',
        });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData is List && responseData.isNotEmpty) {
        var questionText = responseData.map((
            cuestionario) => cuestionario['questionText']).toList();
        print("Datos: $questionText");
        return questionText.cast<String>();
      }
    }
  } catch (e) {
    return null;
  }
}

Future<List<Question>?> getAllQuestions(String? token) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v1/questionnaire/getAllQuestions'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes); // Utilizar utf8.decode
      var responseData = json.decode(responseBody);

      if (responseData is List && responseData.isNotEmpty) {
        var questions = responseData.map((jsonQuestion) {
          var optionsJson = jsonQuestion['options'] as List<dynamic>;
          var options = optionsJson.map((jsonOption) {
            return Option(
              jsonOption['id'],
              jsonOption['optionText'],
              jsonOption['order'],
            );
          }).toList();

          return Question(
            jsonQuestion['id'],
            jsonQuestion['questionText'],
            jsonQuestion['order'],
            options,
          );
        }).toList();

        return questions;
      }
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


Future<String?> Guardar(CuestionarioModel cuestionarioModel,String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/questionnaire/saveUserAnswer';
  final Map<String, dynamic>requestBody = cuestionarioModel.toJson();

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      return "Se agrego la respuesta correctamente.";
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['mensaje'];
      return "Error al agregar una respuesta: $errorMessage";
    }
  } catch (e) {
    return "Error al agregar una respeusta: $e";
  }
}