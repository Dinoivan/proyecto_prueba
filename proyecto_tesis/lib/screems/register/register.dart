import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/services/register/register_service.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';

class PasswordFormField extends StatefulWidget{

  final TextEditingController passwordcontroller;
  final RegisterBloc registerBloc;
  PasswordFormField({required this.passwordcontroller, required this.registerBloc});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   @override
  _PasswordFormFielState  createState() => _PasswordFormFielState();

}

class _PasswordFormFielState extends State<PasswordFormField>{
  bool _obscureText = true;

  void _togglePasswordVisibility(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordcontroller,
        onChanged: (password){
          widget.registerBloc.updatePassword(password);
        },
        obscureText: _obscureText,
        style: TextStyle(
          color: Colors.black,
          fontSize:15.0
        ),

      decoration: InputDecoration(
        border:OutlineInputBorder(
          borderRadius:BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius:BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        labelText:  widget.passwordcontroller.text.isEmpty ? "Contraseña": "",
          hintText: widget.passwordcontroller.text.isEmpty ? "": "Contraseña",
        labelStyle:TextStyle(fontSize: 15.0, color: Color(0xFFACACAC),
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.normal,),
        hintStyle:TextStyle(
          color: Color(0xFFACACAC),
          fontFamily: 'SF Pro Text',
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscureText ? Icons.visibility_off :Icons.visibility,
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),

      ),
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su contraseña';
        }
        final RegExp specialCharacterRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>_-]');
        final RegExp uppercaseLetterRegex = RegExp(r'[A-Z]');
        final RegExp lowercaseLetterRegex = RegExp(r'[a-z]');
        final RegExp numberRegex = RegExp(r'[0-9]');

        if(value.length < 8){
          return 'contraseña debe contener al menos 8 caracteres';
        }
        if (!specialCharacterRegex.hasMatch(value)) {
          return 'requerido al menos un caracter especial';
        }
        if(!uppercaseLetterRegex.hasMatch(value)){
          return 'reuerido al menos una letra en mayúscula';
        }
        if(!lowercaseLetterRegex.hasMatch(value)){
          return 'requerido al menos una letra en minuscula';
        }
        if(!numberRegex.hasMatch(value)){
          return 'contraseña debe contener al menos un número';
        }
        return null;
      },
    );
  }
}

class DateWidget extends StatefulWidget{

  final RegisterBloc birthdayBloc;

  DateWidget({required this.birthdayBloc});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  State<DateWidget> createState(){
    return _DateWidgetState();
  }
}

class _DateWidgetState extends State<DateWidget>{
  TextEditingController _dateController = TextEditingController();

  @override
  void initState(){
    super.initState();

    String? currentBirthdayDate = widget.birthdayBloc.getCurrentBirthday();
    if(currentBirthdayDate != null){
      _dateController.text = currentBirthdayDate;
    }
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
        labelText: _dateController.text.isEmpty ? "Fecha de nacimiento": "",
        hintText: _dateController.text.isEmpty ? "": "Fecha de nacimiento",
        labelStyle:TextStyle(fontSize: 15.0, color: Color(0xFFACACAC),
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.normal,),
        hintStyle:TextStyle(
            color: Colors.black,
            fontSize:15.0
        ),
        border:OutlineInputBorder(
          borderRadius:BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26, width: 2.0),
        ),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius:BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      readOnly: true,
      onTap: () async{
        DateTime now = DateTime.now();
        DateTime inicialDate = DateTime.now().toLocal();
        print('Fecha inicial: $inicialDate');
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: inicialDate,
            firstDate: DateTime(1942),
            lastDate: now,
        );
        if(pickedDate!=null){
          String formmatedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          widget.birthdayBloc.updateBirthdayDate(formmatedDate);
          setState(() {
            _dateController.text = formmatedDate;

          });
        }
      },
      keyboardType: TextInputType.datetime,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su fecha de nacimiento';
        }

        return null;
      },
    );
  }
}

class Register extends StatefulWidget{

  final RegisterBloc registerBloc;

  Register({required this.registerBloc});

  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    widget.registerBloc.dispose();
    super.dispose();
  }

  String _removeAccents(String text) {
    final Map<String, String> accentMap = {
      'á': 'a', 'Á': 'A',
      'é': 'e', 'É': 'E',
      'í': 'i', 'Í': 'I',
      'ó': 'o', 'Ó': 'O',
      'ú': 'u', 'Ú': 'U',
      'à': 'a', 'À': 'A',
      'è': 'e', 'È': 'E',
      'ì': 'i', 'Ì': 'I',
      'ò': 'o', 'Ò': 'O',
      'ù': 'u', 'Ù': 'U',
      'ä': 'a', 'Ä': 'A',
      'ë': 'e', 'Ë': 'E',
      'ï': 'i', 'Ï': 'I',
      'ö': 'o', 'Ö': 'O',
      'ü': 'u', 'Ü': 'U',
    };

    return text.replaceAllMapped(RegExp('[${accentMap.keys.join()}]'), (match) => accentMap[match.group(0)]!);
  }

  String _accentuateCharacters(String text) {
    // Elimina los caracteres especiales y permite solo letras, espacios y dígitos
    String cleanText = _removeAccents(text); // Elimina los acentos primero
    return cleanText.replaceAll(RegExp(r'[^\w\s]'), '');
  }


  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            final AuthBloc authBloc = AuthBloc();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => LoginPage(authBloc: authBloc),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 5),
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(left: 30.0,top: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Registro',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                   ),
                ),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                    child: Column(

                      children: <Widget>[
                        TextFormField(
                          controller: _fullnameController,
                          onChanged: (fullname){
                            widget.registerBloc.updateFullName(fullname);
                          },
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15.0,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            labelText: _fullnameController.text.isEmpty ? "Nombres ": "",
                            labelStyle: const TextStyle(
                              color: Color(0xFFACACAC),
                              fontFamily: 'SF Pro Text',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: _fullnameController.text.isEmpty ? " ": "Nombres",
                            helperStyle: const TextStyle(
                              color: Color(0xFFACACAC),
                              fontFamily: 'SF Pro Text',
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                          ),
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {

                              return 'Por favor, ingrese su nombre';
                            }
                            final RegExp letterRegex = RegExp(r'[a-zA-Z]');
                            if(!letterRegex.hasMatch(value)){
                              return 'Solo se permiten palabras';
                            }
                            return null;
                          },
                        ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _lastNameController,
                        onChanged: (lastname){
                          widget.registerBloc.updateLastName(lastname);
                        },
                        style: TextStyle(
                          color:Colors.black,
                          fontSize:15.0,
                        ),
                        decoration: InputDecoration(
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26, width: 2.0),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26,width: 2.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26,width: 2.0),
                          ),
                          labelText: _lastNameController.text.isEmpty ? "Apellidos": "",
                          labelStyle: const TextStyle(
                            color: Color(0xFFACACAC),
                            fontFamily: 'SF Pro Text',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText:  _lastNameController.text.isEmpty ? "": " Apellidos",
                          helperStyle: const TextStyle(
                            color: Color(0xFFACACAC),
                            fontFamily: 'SF Pro Text',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                        ),
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su apellido';
                          }
                          final RegExp letterRegex = RegExp(r'[a-zA-Z]');
                          if(!letterRegex.hasMatch(value)){
                            return 'Solo se permiten palabras';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20,),
                      DateWidget(birthdayBloc: widget.registerBloc),

                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailController,
                        onChanged: (email){
                          widget.registerBloc.updateEmail(email);
                        },
                        style: TextStyle(
                          color:Colors.black,
                          fontSize:15.0,
                        ),
                        decoration: InputDecoration(
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26, width: 2.0),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26,width: 2.0),
                          ),
                          focusedBorder:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26,width: 2.0),
                          ),
                          labelText: _emailController.text.isEmpty ? "Correo": "",
                          labelStyle: const TextStyle(
                            color: Color(0xFFACACAC),
                            fontFamily: 'SF Pro Text',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText:  _emailController.text.isEmpty  ? "": "Correo",
                          helperStyle: const TextStyle(
                            color: Color(0xFFACACAC),
                            fontFamily: 'SF Pro Text',
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un correo electrónico';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Ingrese un correo eléctrónico válido';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20,),
                      PasswordFormField(passwordcontroller: _passwordController, registerBloc: widget.registerBloc),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 107),
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(

                          onPressed: () async {
                            if(_formKey.currentState != null && _formKey.currentState!.validate()){

                              setState(() {
                                _isLoading = true;
                              });

                                try{
                                String fullname = _accentuateCharacters(_fullnameController.text);
                                List<String>nameParts = fullname.split(' ');
                                String firstname = nameParts.isNotEmpty ? nameParts[0]: '';
                                String lastname = _accentuateCharacters(_lastNameController.text);
                                String birthdayDate = widget.registerBloc.getCurrentBirthday()!;
                                DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(birthdayDate);
                                String formattedBirthdayDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                                String email = _emailController.text;
                                String password = _passwordController.text;

                                Citizen citizen = Citizen(
                                active: true,
                                alias: firstname,
                                birthdayDate: formattedBirthdayDate,
                                email: email,
                                firstname: fullname,
                                fullname: fullname,
                                lastname: lastname,
                                password: password,);

                                await saveCitizen(citizen);

                                final AuthBloc authBloc = AuthBloc();
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(authBloc: authBloc),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 5),
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Registro exitoso.'),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: Colors.green,),
                                );

                                }catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                    content: Text('Algo salio mal verificar'),
                                    duration: Duration(seconds: 4),
                                    backgroundColor: Colors.red,)
                                    );
                                }finally{
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                            }
                            },
                            style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                            ),

                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical:15.0),
                            ),

                            ),

                          child: _isLoading ? CircularProgressIndicator() :  Text(
                            'Registro',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),

                        ),

                      ),

                    ],
                  ),
                ),
              ),

            ]

        ),
      ),
    ),
    );
  }
}