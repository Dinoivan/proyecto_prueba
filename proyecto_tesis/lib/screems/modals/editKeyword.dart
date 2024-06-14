import 'package:flutter/material.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/sreems/keyword_service.dart';


class EditKeywordModal extends StatefulWidget {
  String? palabraClave;

  EditKeywordModal({required this.palabraClave});

  @override
  _EditKeywordModalState createState() => _EditKeywordModalState();
}

class  _EditKeywordModalState  extends State<EditKeywordModal> {

  late TextEditingController _keywordController;

  String? token;
  String? keyword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? userId;
  int? id;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _keywordController = TextEditingController(text: widget.palabraClave);
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

    await _getKeyword();
  }

  Future<void> _getKeyword() async{
    try{
      getKeywordCitizen? palabraClave = await getKeyWordService(token);
      setState(() {
        keyword = palabraClave?.keyword;
        id = palabraClave?.id;
        _keywordController.text = keyword ?? "";
      });
    }catch(e){
      print("Error al obtener palabra clave: $e");
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
      title: Text('Editar palabra clave', style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _keywordController,
                decoration: InputDecoration(labelText: 'Palabra clave',labelStyle: TextStyle(fontSize: 18.0)),
                style: TextStyle(fontSize: 14.0),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la palabra clave';
                  }
                  final RegExp letterRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]+$');
                  if (!letterRegex.hasMatch(value)) {
                    return 'Solo se permiten letras y espacios, sin caracteres especiales ni números';
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
      // El formulario es válido, procede a actualizar el contacto
      String keyword = _accentuateCharacters(_keywordController.text);
      print('Datos a enviar para actualizar:');
      print('Palabra clave: $keyword');

      try {
        print('Datos a enviar para actualizar:');
        print('Palabra clave: $keyword');
        print("Id de la usuaria: $id");
        print("Token: $token");

        final updateKeyword_ = await updateKeyword(keyword.toLowerCase(), token, id);
        Navigator.of(context).pop(updateKeyword_);
      } catch (e) {
        print('Error al actualizar el contacto: $e');
      }
    } else {
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
    _keywordController.dispose();
    super.dispose();
  }
}
