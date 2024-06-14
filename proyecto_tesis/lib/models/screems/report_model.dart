
class Report_ {
  final String createdDate;
  final String description;
  final String name;
  final String reportStatus;
  final String reportingDate;

Report_({
  required this.createdDate,
  required this.description,
  required this.name,
  required this.reportStatus,
  required this.reportingDate,
});

  factory Report_.fromJson(Map<String, dynamic> json) {
  // Puedes manejar la lógica para establecer la fecha de creación aquí
  final createdDate = DateTime.now().toUtc().toIso8601String();

  return Report_(
      createdDate: createdDate,
      description: json['description'],
      name: json['name'],
      reportStatus: 'Archivado', // Siempre será 'Archivado'
      reportingDate: json['reportingDate'],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdDate': createdDate,
      'description': description,
      'name': name,
      'reportStatus': reportStatus,
      'reportingDate': reportingDate,
    };
  }
}

class ReportResponse{
  final int statusCode;

  ReportResponse({required this.statusCode});

  factory ReportResponse.fromJson(Map<String,dynamic>json){
    return ReportResponse(
      statusCode: json['statusCode'],
    );
  }
}






