import 'dart:async';

class RegisterBloc{

  final _fullNameController =StreamController<String>();
  final _lastNameController =StreamController<String>();
  final _aliasController =StreamController<String>();
  final _birthdayDateController = StreamController<String>();
  final _emailController = StreamController<String>();
  final _firstNameController = StreamController<String>();
  final _passwordController =StreamController<String>();

  Stream<String> get fullNameStream => _fullNameController.stream;
  Stream<String> get lastNameController => _lastNameController.stream;
  Stream<String> get aliasController => _aliasController.stream;
  Stream<String> get birthdayDateController => _birthdayDateController.stream;
  Stream<String> get emailController => _emailController.stream;
  Stream<String> get firstNameController => _firstNameController.stream;
  Stream<String> get passwordController => _passwordController.stream;

  String? _CurrentFullName;
  String? _CurrentLastName;
  String? _CurrentAlias;
  String? _CurrentBirhdayDate;
  String? _CurrentEmail;
  String? _CurrentFirstName;
  String? _CurrentPassword;

  void updateFullName(String fullname){
    _CurrentFullName = fullname;
    _fullNameController.sink.add(fullname);
  }

  String ? getCurrentFullName(){
    return _CurrentFullName ?? "";
  }

  void updateLastName(String lastname){
    _CurrentLastName = lastname;
    _lastNameController.sink.add(lastname);
  }

  String ? getCurrentLastName(){
    return _CurrentLastName ?? "";
  }

  void updateAlias(String alias){
    _CurrentAlias = alias;
    _aliasController.sink.add(alias);
  }

  String ? getCurrentAlias(){
    return _CurrentAlias ?? "";
  }

  void updateBirthdayDate(String birthday){
    _CurrentBirhdayDate = birthday;
    _birthdayDateController.sink.add(birthday);
  }

  String ? getCurrentBirthday(){
    return _CurrentBirhdayDate ?? "";
  }


  void updateFirstName(String firstname){
    _CurrentFirstName = firstname;
    _firstNameController.sink.add(firstname);
  }

  String ? getCurrentFirstName(){
    return _CurrentFirstName ?? "";
  }

  void updateEmail(String email){
    _CurrentEmail = email;
    _emailController.sink.add(email);
  }

  String ? getCurrentEmail(){
    return _CurrentEmail ?? "";
  }

  void updatePassword(String password){
    _CurrentPassword = password;
    _passwordController.sink.add(password);
  }

  String ? getCurrentPassword(){
    return _CurrentPassword ?? "";
  }

  void dispose(){
    _fullNameController.close();
    _lastNameController.close();
    _aliasController.close();
    _birthdayDateController.close();
    _emailController.close();
    _firstNameController.close();
    _passwordController.close();
  }

}