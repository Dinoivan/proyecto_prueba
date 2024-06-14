  import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<KeywordResponse> keywordService(String keyword, String? token) async{

  final keywordModel_ = KeywordModel(keyword: keyword);

  try{
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/keywordAudio/saveKeywordAudio'),
    headers: {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(keywordModel_),
    );

    if(response.statusCode == 200){
      return KeywordResponse(statusCode: response.statusCode);
    }else{
      return KeywordResponse(statusCode: response.statusCode);
    }

  }catch(e){
    throw Exception('Error al agregar palabra clave');
  }
}

Future<getKeywordCitizen?>getKeyWordService(String? token) async{
  try {
    final response = await http.get(Uri.parse(
        '${ApiConfig.baseUrl}/v1/keywordAudio/getKeywordAudioByCitizen'),
        headers: {
          'Authorization': '$token',
        });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData is Map<String, dynamic>) {
        int? id = responseData['id'];
        String? keyword = responseData['keyword'];
        return getKeywordCitizen(id: id, keyword: keyword);
      }
    }
    return null;
  }catch(e){
    throw Exception('Failed to get keyword data: ${e}');
  }
}

  //Actualizar palabra clave
  Future<String?> updateKeyword(String? keyword, String? token, int? id) async{
    try{
      final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/keywordAudio/updateKeywordAudio/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'keyword': keyword,
        }),
      );
      if(response.statusCode == 200){
        return keyword;
      }else{
        throw Exception('Failed to update palabra clave');
      }
    }catch(e){
      throw Exception('Failed to palabra clave: $e');
    }
  }