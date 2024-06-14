import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/services/sreems/citizen_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:intl/intl.dart';

class EditCitizenModal extends StatefulWidget {
  final CitizenUpdate citizen;

  EditCitizenModal({required this.citizen});

  @override
  _EditCitizenModalState createState() => _EditCitizenModalState();
}

class _EditCitizenModalState extends State<EditCitizenModal> {
  late TextEditingController _birthdayDateController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? token;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _birthdayDateController = TextEditingController(text: widget.citizen.birthdayDate);
    _emailController = TextEditingController(text: widget.citizen.email);
    _firstNameController = TextEditingController(text: widget.citizen.firstname);
    _lastNameController = TextEditingController(text: widget.citizen.lastname);
  }

  Future<void> _loadToken() async{
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });
    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      if(decodedToken.containsKey('user_id')){
        userId = decodedToken["user_id"];
      }
    }
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar información de usuario',
        style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Nombre',  labelStyle: TextStyle(fontSize: 18.0),),
                style: TextStyle(fontSize: 14.0),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  final RegExp letterRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]+$');
                  if (!letterRegex.hasMatch(value)) {
                    return 'Solo se permiten letras y espacios, sin caracteres especiales ni números';
                  }
                  return null;
                  },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Apellidos',labelStyle: TextStyle(fontSize: 18.0),),
                style: TextStyle(fontSize: 14.0),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  final RegExp letterRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]+$');
                  if (!letterRegex.hasMatch(value)) {
                    return 'Solo se permiten letras y espacios, sin caracteres especiales ni números';
                  }
                  return null;
                  },
              ),
              TextFormField(
                controller: _birthdayDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  labelStyle: TextStyle(fontSize: 18.0),
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectDate(context, _birthdayDateController);
                      },
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                style: TextStyle(fontSize: 14.0),
                keyboardType: TextInputType.datetime,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Por favor, seleccione su fecha de nacimiento';
                  }
                  final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                  if (!dateRegex.hasMatch(value)) {
                    return 'Por favor, ingrese una fecha válida en formato DD/MM/AAAA';
                  }
                  return null;
                  },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo',labelStyle: TextStyle(fontSize: 18.0)),
                style: TextStyle(fontSize: 14.0),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Por favor, ingrese un correo electrónico válido';
                  }
                  return null;
                  },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal sin guardar cambios
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Verifica la validez del formulario antes de intentar guardar
                if (_formKey.currentState?.validate() ?? false) {
                  // El formulario es válido, procede a actualizar el contacto
                  _updateContact();
                } else {
                  // El formulario no es válido, muestra un mensaje de advertencia
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, complete el formulario correctamente.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Guardar'),
            )

          ],
        )
      ],
    );
  }

  void _updateContact() async {

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Obtén los nuevos valores de los campos
      //String firtsName = _firstNameController.text;
      //String lastName = _lastNameController.text;
      String firtsName = _accentuateCharacters(_firstNameController.text);
      String lastName = _accentuateCharacters(_lastNameController.text);
      //Formatear la fecha de nacimiento al formato deseado
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(
          _birthdayDateController.text);
      String birthdayDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      String email = _emailController.text;

      // Imprime los datos que estás enviando al servicio de actualización
      print('Datos a enviar para actualizar:');
      print('Nombre: $firtsName');
      print('Apellidos: $lastName');
      print('Fecha de nacimiento: $birthdayDate');
      print("Correo: $email");

      // Llama al servicio de actualización
      try {
        print('Datos a enviar para actualizar:');
        print('Nombre: $firtsName');
        print('Apellidos: $lastName');
        print('Fecha de nacimiento: $birthdayDate');
        print("Correo: $email");
        print("Id de la usuaria: $userId");
        print("Token: $token");

        final updatedCitizen = await updateCitizen(
            CitizenUpdate(
                firstname: firtsName,
                lastname: lastName,
                birthdayDate: birthdayDate,
                email: email
            ),
            token,
            userId
        );

        // Si la actualización fue exitosa, muestra el SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Información de perfil guardada exitosamente'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green, // Color de fondo del SnackBar
          ),
        );

        Navigator.of(context).pop(updatedCitizen);
      } catch (e) {
        print('Error al actualizar el contacto: $e');
      }
    }else{
      // El formulario no es válido, muestra un mensaje de advertencia
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete el formulario correctamente.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayDateController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Fecha inicial
    firstDate: DateTime(1900), // Fecha mínima permitida
    lastDate: DateTime.now(), // Fecha máxima permitida (hoy)
  );
  if (pickedDate != null) {
    controller.text = DateFormat('dd/MM/yyyy').format(pickedDate); // Actualiza el valor del campo de entrada
  }
}