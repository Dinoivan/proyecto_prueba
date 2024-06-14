import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'home.dart';

class Help extends StatefulWidget{

  @override
  _HelpState createState() => _HelpState();

}

class _HelpState extends State<Help>{

  String? token;
  List<Map<String, dynamic>>? contactosDeEmergencia = [
    {
      'name': 'Centros Emergencia Mujer (CEM)',
      'icon': Icons.person,
    },
    {
      'name': 'Central policial',
      'icon': Icons.group,
    },
    {
      'name': 'EsSalud',
      'icon': Icons.lock,
    },
  ];

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

  }


  int _selectedIndex = 4;

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

  void _resetToken(){
    setState(() {
      token = null;
    });
  }



  List<Color?> _iconColors = [
    Colors.grey[700], // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];


  Future<void> _showInformationModal(BuildContext context, String nombreInstitucion, String descripcion, String numeroTelefono) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre de la institución: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(nombreInstitucion),
                SizedBox(height: 10),
                Text(
                  'Descripción: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(descripcion, textAlign: TextAlign.justify),
                SizedBox(height: 10,),
                Text(
                  'Número telefónico: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(numeroTelefono),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context){
    authBloc.saveLastScreem('help');
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
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
                        'Números de ayuda',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'En esta categoría, verás números de emergencia de instituciones públicas',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFFAA4A4A4),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15.0,),
                    // Lista de contactos
                    if (contactosDeEmergencia != null && contactosDeEmergencia!.isNotEmpty)
                      Column(
                        children: contactosDeEmergencia!
                            .map((contacto) => Container(
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
                                contacto['name'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Row(
                                children: [
                                  // Añade un espacio entre los iconos
                                  GestureDetector(
                                    onTap: () async {

                                      switch(contacto['name']){
                                        case 'Centros Emergencia Mujer (CEM)':
                                          _showInformationModal(
                                            context,
                                            contacto['name'],
                                            "Son servicios públicos especializados y gratuitos, de atención integral y multidisciplinaria, para víctimas de violencia contra las mujeres y los integrantes del grupo familiar y personas afectadas por violencia sexual. Permite acceder a asesoría legal, contención emocional y apoyo social a nivel nacional. En todo el Perú, los 245 CEM regulares y un CEM en centro de salud (Santa Julia, Piura) atienden de lunes a viernes de 8:00 a. m. a 4:15 p. m., y los 185 CEM en comisarías, las 24 horas del día, los 365 días del año",
                                            "(01) 4197260",
                                          );

                                        case 'Central policial':
                                          _showInformationModal(
                                            context,
                                            contacto['name'],
                                            "La Central 105 monitorea y vigila a la ciudadanía, a través de 1,500 cámaras de seguridad y un moderno videowall, integrado por 24 monitores de 50 pulgadas, para lo cual cuenta con un equipo de vigilancia de manifestaciones, inteligencia policial, policía de turismo, entre otros",
                                            "105",
                                          );

                                        case 'EsSalud':
                                          _showInformationModal(
                                              context,
                                              contacto['name'],
                                              "En el marco del Día Internacional de La Mujer, el Seguro Social de Salud (EsSalud) lanzó la línea telefónica EsSalud en Línea 4118000, opción 6, puesta al servicio de las mujeres víctimas de violencia, permitiendo agilizar su atención médica en los hospitales de la seguridad social",
                                              "4118000, opción 6"
                                          );
                                      }
                                      // Si updatedContact no es nulo, significa que se guardaron cambios, así que actualiza la lista
                                    },
                                    child: Icon(
                                      Icons.insert_comment_outlined,
                                      color: Color(0xFF7A72DE),
                                      size: 21.0, // Puedes ajustar el tamaño según sea necesario
                                    ),
                                  ),
                                  SizedBox(width: 15.0),
                                ],
                              ),
                            ],
                          ),
                        ))
                            .toList(),
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