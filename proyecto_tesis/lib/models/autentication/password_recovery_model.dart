class PasswordRecoveryModel{
  final String email;

  PasswordRecoveryModel({
    required this.email,
  });

  Map<String,dynamic>toJson(){
    return {
      'email': email,
    };
  }
}
class PasswordRecoveryResponse{
  final int statusCode;
  final String message;
  PasswordRecoveryResponse({required this.statusCode, required this.message});

  factory PasswordRecoveryResponse.fromJson(Map<String,dynamic>json){
    return PasswordRecoveryResponse(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}