class UbicationURL {
  final String? dir;
  final String url;

  UbicationURL({required this.dir,required this.url});

  Map<String, dynamic> toJson() {
    return {
      'dir': dir,
      'url': url,
    };
  }
}

class Emergency{
  final int statusCode;

  Emergency({required this.statusCode});

  factory Emergency.fromJson(Map<String,dynamic>json){
    return Emergency(
      statusCode: json['statusCode'],
    );
  }
}