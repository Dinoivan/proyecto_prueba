class LoginModel{
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
});

  Map<String,dynamic> toJson(){
    return {
      'email': email,
      'password':password,
    };
  }
}

class LoginResponse{
  final String? token;
  final int statusCode;

  LoginResponse({this.token,required this.statusCode});

  factory LoginResponse.fromJson(Map<String,dynamic>json){
    return LoginResponse(
      token: json['token'],
      statusCode: json['statusCode'],
    );
  }
}


