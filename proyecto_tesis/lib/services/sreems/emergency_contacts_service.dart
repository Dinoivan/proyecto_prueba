import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/emergency_contacts_model.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>?> GetContactEmergency(String? token) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v1/emergencyContacts/getAllEmergencyContactsByCitizenId'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData is List && responseData.isNotEmpty) {
        return List<Map<String, dynamic>>.from(responseData);
      }
    }
  } catch (e) {
    return null;
  }
}

Future<Map<String,dynamic>?> updateEmergencyContacts(EmergencyContacts emergencyContacts, String? token, int? id) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v1/emergencyContacts/updateEmergencyContacts/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode({
        'fullname': emergencyContacts.fullname,
        'phonenumber': emergencyContacts.phonenumber,
        'relationship': emergencyContacts.relationship,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Error al actualizar el contactos: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Errro al actualizar el contacto: $e');
  }
}


Future<EmergencyResponse>DeleteEmergency(String? token, int? id) async{
  try{
    final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/v1/emergencyContacts/deleteEmergencyContactByCitizen/$id'),
        headers: {
          'Authorization': '$token',
        },
    );
    if(response.statusCode == 200){
      return EmergencyResponse(statusCode: response.statusCode);
    }else{
      return EmergencyResponse(statusCode: response.statusCode);
    }
  }catch(e){
    throw Exception('Error al eliminar contacto ${e}');
  }
}
