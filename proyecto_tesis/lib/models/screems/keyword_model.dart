class KeywordModel{
  final String keyword;

  KeywordModel({
    required this.keyword,
 });

  Map<String,dynamic> toJson(){
    return{
      'keyword': keyword,
    };
  }
}

class KeywordResponse{

  final int statusCode;
  KeywordResponse({required this.statusCode});

  factory KeywordResponse.fromJson(Map<String,dynamic>json){
    return KeywordResponse(
      statusCode: json['statusCode'],
    );
  }
}

class getKeywordCitizen{
  final int? id;
  final String? keyword;

  getKeywordCitizen({this.id, this.keyword});
}

