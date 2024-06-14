import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:proyecto_tesis/screems/main_screems/add_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/chatGPT.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/keyword.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/modals/getContact.dart';
import 'package:proyecto_tesis/services/sreems/emergency_contacts_service.dart';
import 'package:proyecto_tesis/screems/modals/editContact.dart';
import 'package:proyecto_tesis/services/sreems/keyword_service.dart';
import 'home.dart';

class EmergencyContacts extends StatefulWidget{

  @override
  _EmergencyContactsState createState() => _EmergencyContactsState();

}

class _EmergencyContactsState extends State<EmergencyContacts>{

  String? token;
  List<Map<String, dynamic>>? contactosDeEmergencia;
  bool _isLoading = false;
  String? keyword;

  @override
  void initState(){
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async{
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });

    await _getContactosEmergencia();
    await _getKeyword();
    if(keyword == null){
      _addKeywordModal();
    }
  }

  Future<void> _getContactosEmergencia() async{
    setState(() {
      _isLoading = true;
    });
    try{
      List<Map<String, dynamic>>? contactos = await GetContactEmergency(token);
      setState(() {
        contactosDeEmergencia = contactos;
        _isLoading = false;
      });
    }catch(e){
      print('Error al obtener contactos de emergencia: $e');
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _selectedIndex = 2;

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
      _iconColors[_selectedIndex] = Colors.grey[700];
    });
  }


  List<Color?> _iconColors = [
    Colors.grey[700], // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];

  //Obtener palabra clave
  Future<void> _getKeyword() async{
    try{
      getKeywordCitizen? palabraClave = await getKeyWordService(token);
      setState(() {
        keyword = palabraClave?.keyword;
      });
    }catch(e){
      print("Error al obtener palabra clave: $e");
    }
  }

  //Modal para informacion palabra clave
  void _addKeywordModal(){
    if(mounted){
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¡Atención!',style: TextStyle(fontSize: 20.0),),
            content: Text('Ahora ingresa una palabra clave para activar la alerta mediante reconocimiento de voz.',
            textAlign: TextAlign.justify,),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context,
                    PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) => KeyWord(),
                    transitionsBuilder: (context,animation,secondaryAnimation,child){
                      return FadeTransition(
                          opacity: animation,
                      child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 5),
                     ),
                    );
                  },
                  child: Text('Agregar palabra clave'),
              ),
            ],
       ),
     );
    }
  }

  @override
  Widget build(BuildContext context){
    authBloc.saveLastScreem('emergency_contacts');
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
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      alignment: Alignment.center,
                      child: Text(
                        'Mis contactos de emergencia',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'Agrega a tus contactos de confianza para alertarlos cuando decidas activar el botón de emergencia',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'SF Pro Text',
                            color: Color(0xFFAA4A4A4),
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Lista de contactos
                    if (contactosDeEmergencia != null && contactosDeEmergencia!.isNotEmpty)
                      Column(
                        children: contactosDeEmergencia!
                            .map((contacto) => GestureDetector(
                          onTap: () async {
                            Map<String, dynamic>? getContact = await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return GetContactModal(contact: contacto);
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  contacto['fullname'],
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // Muestra el modal para editar el contacto
                                        Map<String, dynamic>? updatedContact = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return EditContactModal(contact: contacto);
                                          },
                                        );
                                        // Si updatedContact no es nulo, significa que se guardaron cambios, así que actualiza la lista
                                        if (updatedContact != null) {
                                          await _getContactosEmergencia();
                                        }
                                      },
                                      child: Icon(
                                          Icons.edit,
                                          color: Color(0xFF7A72DE), // Puedes cambiar el color a tu preferencia
                                          size: 21.0 // Puedes ajustar el tamaño según sea necesario
                                      ),
                                    ),
                                    SizedBox(width: 20.0), // Añade un espacio entre los iconos
                                    GestureDetector(
                                      onTap: () async {
                                        Map<String, dynamic>? getContact = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return GetContactModal(contact: contacto);
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.green,
                                        size: 21.0, // Puedes ajustar el tamaño según sea necesario
                                      ),
                                    ),
                                    SizedBox(width: 20.0), // Añade un espacio entre los iconos
                                    GestureDetector(
                                      onTap: () async {
                                        // Muestra el diálogo de confirmación
                                        bool confirmado = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirmar eliminación",
                                                style: TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),),
                                              content: Text(
                                                "¿Estás seguro de que deseas eliminar este contacto?", textAlign: TextAlign.justify,),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                      },
                                                      child: Text("No"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, true);
                                                      },
                                                      child: Text("Sí"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmado) {
                                          int? idContacto = contacto['id'];
                                          print("id: $idContacto");
                                          try {
                                            // Llama a la función DeleteEmergency para eliminar el contacto de emergencia
                                            final response = await DeleteEmergency(token!, idContacto!);
                                            // Verifica si la eliminación fue exitosa
                                            if (response.statusCode == 200) {
                                              await _getContactosEmergencia();
                                              // Muestra un mensaje de éxito al usuario
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Contacto de emergencia eliminado con éxito'),
                                                ),
                                              );
                                            } else {
                                              // Muestra un mensaje de error al usuario
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Error al eliminar el contacto de emergencia ${response.statusCode} ${token}'),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            // Muestra un mensaje de error genérico al usuario
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Error al eliminar el contacto de emergencia: $e'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 21.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                            .toList(),
                      )

                      else if(_isLoading)
                        Center(
                          child: CircularProgressIndicator(),
                        )
                    else
                      Center(
                       child: Text(
                          'No existen contactos agregados',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      )

                  ],
                ),
              ),
            ),
          ),
          // Botones fijos en la parte inferior
          Form(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:  () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => AddContacts(),
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
                          EdgeInsets.symmetric(vertical:10.0),
                        ),

                      ),

                      child: const Center(
                        child: Text(
                          'Agregar contactos',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),

                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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