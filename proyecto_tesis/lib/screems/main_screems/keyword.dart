import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/modals/editKeyword.dart';
import 'package:proyecto_tesis/services/sreems/keyword_service.dart';
import '../../blocs/register/register_bloc.dart';
import 'emergency_contacts.dart';
import 'home.dart';

class KeyWord extends StatefulWidget{

  @override
  _KeyWordState createState() => _KeyWordState();

}

class _KeyWordState extends State<KeyWord>{
  final TextEditingController _keywordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? token;
  String? keyword;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      _updateIconColors();

      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Home(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
        case 1:
          final AuthBloc authBloc = AuthBloc();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Profile(authBloc: authBloc),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 40),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => EmergencyContacts(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
        case 3:
          final RegisterBloc registerBloc = RegisterBloc();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Report(registerBloc: registerBloc,),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;

        case 4:

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Configuration(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
      }
    });
  }

  // Actualizar los colores de los íconos basados en el índice seleccionado
  void _updateIconColors() {
    setState(() {
      // Restaurar el color predeterminado para todos los íconos
      _iconColors = List<Color>.filled(5, Colors.grey[700]!);
      // Actualizar el color del ícono seleccionado
      _iconColors[_selectedIndex] = Colors.blue;
    });
  }

  List<Color?> _iconColors = [
    Colors.blue, // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];

  @override
  void initState(){
    _loadToken();
    super.initState();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });

    await _getKeyword();

  }

  Future<void> _getKeyword() async{
    try{
      setState(() {
        _isLoading = true;
      });

      getKeywordCitizen? palabraClave = await getKeyWordService(token);
      setState(() {
        keyword = palabraClave?.keyword;
        _keywordController.text = keyword ?? "";
      });
    }catch(e){
      print("Error al obtener palabra clave: $e");
    }finally{
      setState(() {
        _isLoading = false;
      });
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
  Widget build(BuildContext context){
    authBloc.saveLastScreem('keyword');
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Home(),
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
                      keyword == null ? 'Ingrese palabra clave': 'Palabra clave actual',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _keywordController,
                            readOnly: keyword == null ? false : true,
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
                              labelText: _keywordController.text.isEmpty ? " Palabra clave": "",
                              labelStyle: const TextStyle(
                                color: Color(0xFFACACAC),
                                fontFamily: 'SF Pro Text',
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                              hintText: _keywordController.text.isEmpty ? "": " Palabra clase",
                              helperStyle: const TextStyle(
                                color: Color(0xFFACACAC),
                                fontFamily: 'SF Pro Text',
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                              fillColor: keyword!=null ? Colors.grey[50]: null,
                              filled: keyword!=null,

                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                            ),
                            keyboardType: TextInputType.text,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {

                                return 'Por favor, ingrese la palabra clave';
                              }
                              final RegExp letterRegex = RegExp(r'[a-zA-Z]');
                              if(!letterRegex.hasMatch(value)){
                                return 'Solo se permiten palabras';
                              }
                              return null;
                            },

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z,áéíóúÁÉÍÓÚ\s]')), // Permite letras, coma y espacios
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 224),
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState != null && _formKey.currentState!.validate()){

                                  final palabraclave = _accentuateCharacters(_keywordController.text);

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try{
                                    if(keyword == null){
                                      KeywordResponse response =  await keywordService(palabraclave.toLowerCase(), token);

                                      if(response.statusCode == 200 && token!=null){
                                        await _getKeyword();
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => Home(),
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
                                            content: Text('Se agrego correctamente la palabra clave.'),
                                            duration: Duration(seconds: 4),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Sucedio un error vuelve a intentar.'),
                                            duration: Duration(seconds: 4),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }

                                    }else if(keyword!=null){

                                      //Si exite palabra clave existente, muestra el modal de edición
                                      String? keywordCitizenUpdate = await  showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return EditKeywordModal(palabraClave: keyword);
                                          },
                                      );

                                    if(keywordCitizenUpdate != null){
                                      await _getKeyword();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Palabra clave modificado correctamente.'),
                                          duration: Duration(seconds: 4),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                    }
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sucedio un error en el servicio.'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      ),
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
                                overlayColor: MaterialStateProperty.resolveWith<Color>((states){
                                  if(states.contains(MaterialState.disabled)){
                                    return Colors.grey.withOpacity(0.5);
                                  }
                                  return Colors.transparent;
                                }),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                                ),


                                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(vertical:15.0),
                                ),

                              ),

                              child: _isLoading && keyword ==null ? CircularProgressIndicator() :  Text(
                                keyword == null ? 'Guardar' : 'Editar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(Icons.home_outlined),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Mi perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_comment_outlined),
            label: 'Reportes',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Configura',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF7A72DE), // Color del ícono seleccionado
        unselectedItemColor:  Color(0xFF9BAEB8),
        onTap: _onItemTapped,
      ),
    );
  }
}