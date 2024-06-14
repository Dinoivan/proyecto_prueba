import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/models/screems/report_model.dart';
import 'package:proyecto_tesis/environment/configuration.dart';

Future<ReportResponse> saveReport(Report_ report, String? token) async {

  final String apiUrl = '${ApiConfig.baseUrl}/v1/report/saveReport';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(report.toJson()),
    );
    if (response.statusCode == 200) {
      return ReportResponse(statusCode: response.statusCode);
      print('Report saved successfully');
    } else {
      return ReportResponse(statusCode: response.statusCode);
      print('Failed to save report. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }catch(e){
    throw Exception("Sucedio un error al guardar: $e");
  }
}