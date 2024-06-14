class Citizen{
  final bool active;
  final String alias;
  final String birthdayDate;
  final String email;
  final String firstname;
  final String fullname;
  final String lastname;
  final String password;
  final DateTime registrationDate;

  Citizen(
  {
    required this.active,
    required this.alias,
    required this.birthdayDate,
    required this.email,
    required this.firstname,
    required this.fullname,
    required this.lastname,
    required this.password,}): registrationDate = DateTime.now();

  Map<String,dynamic> toJson(){
    return{
      'active': active,
      'alias': alias,
      'birthdayDate': birthdayDate,
      'email': email,
      'firstname': firstname,
      'fullname': fullname,
      'lastname': lastname,
      'password': password,
      'registrationDate':registrationDate.toIso8601String(),
    };
  }
}


class CitizenUpdate{
  final String birthdayDate;
  final String email;
  final String firstname;
  final String lastname;

  CitizenUpdate(
      {
        required this.birthdayDate,
        required this.email,
        required this.firstname,
        required this.lastname,});

  Map<String,dynamic> toJson(){
    return{
      'birthdayDate': birthdayDate,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}

class CitizenResponse{
  final int statusCode;
  final String message;

  CitizenResponse({required this.statusCode, required this.message});

  factory CitizenResponse.fromJson(Map<String,dynamic>json){
    return CitizenResponse(
      statusCode: json['statusCode'],
      message: json['message'],
    );
  }
}