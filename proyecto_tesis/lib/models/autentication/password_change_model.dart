class PasswordChangeModel{
  final String email;
  final String newPassword;
  final int token;

  PasswordChangeModel({
    required this.email,
    required this.newPassword,
    required this.token,
});

  Map<String,dynamic>toJson(){
    return {
      'email': email,
      'newPassword': newPassword,
      'token': token
    };
  }
}

class PasswordChangeResponse{
  final int statusCode;
  final String message;

  PasswordChangeResponse({
    required this.statusCode,
    required this.message,
  });

  factory PasswordChangeResponse.fromJson(Map<String,dynamic>json){
    return PasswordChangeResponse(
    statusCode: json['statusCode'],
    message: json['message'],
   );
  }
}