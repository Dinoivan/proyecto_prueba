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
  import 'package:url_launcher/url_launcher.dart';

  class HeadMap extends StatefulWidget{

    @override
    _HeadMapState createState() => _HeadMapState();

  }

  class _HeadMapState extends State<HeadMap>{

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
      authBloc.saveLastScreem('help_map');
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
                          'Mapa de calor',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 15.0,),
                      _buildImage(),
                      SizedBox(height: 40,),

                      GestureDetector(
                        onTap: () {
                           print('Enlace clicado');
                          _launchURL('http://savelife-upc-f0dee3255ae0.herokuapp.com/get-heat-map');
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          alignment: Alignment.center,
                          child: Text(
                            'http://savelife-upc-f0dee3255ae0.herokuapp.com/get-heat-map',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, // Agrega un subrayado para indicar que es un enlace
                            ),
                          ),
                        ),
                      ),
                      // Lista de contactos

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
              icon:Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Mi perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Contactos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_comment_outlined),
              label: 'Reportes',

            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
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


    Widget _buildImage(){
      return Row(
        children: [
          Expanded(
            child: Image(
              image: AssetImage("assets/mapa_calor.png"),
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }

    Future<void> _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'No se pudo abrir la URL: $url';
      }
    }
  }