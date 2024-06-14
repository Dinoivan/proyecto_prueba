import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/screems/ubicacation_model.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import '../../blocs/register/register_bloc.dart';
import 'emergency_contacts.dart';
import 'home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/sreems/send_emergency_contact_service.dart';


class SendLocation extends StatefulWidget{

  @override
  _SendLocationState createState() => _SendLocationState();

}

class _SendLocationState extends State<SendLocation>{

  StreamSubscription<Position>? _positionStreamSubscription;


  double? latitude;
  double? longitud;
  Position? previousPosition;

  String? address = '';

  int? userId;
  String? token;
  late Timer _timer;
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _loadToken();
    _startSendingLocation();
    _timer = Timer.periodic(Duration(seconds: 5), (timer){
      String googleMapsLink = getGoogleMapsLink(); // Obtener el enlace de Google Maps
      _sendLocation(googleMapsLink); // Pasar el enlace de Google Maps a _sendLocation()
    });
  }

  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
    _positionStreamSubscription?.cancel();
    _stopSendingLocation();
  }


  Future<void> _startSendingLocation() async {

    _positionStreamSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    ).listen((Position position) async{
      if(mounted) {
        setState(() {
          latitude = position.latitude;
          longitud = position.longitude;
        });

        address = await _getAddressFromCoordinates(latitude!, longitud!);
        if(address != null) {
          // Si se obtiene una dirección válida, actualizarla en el estado del widget
          setState(() {
            address = address;
          });
        }
        //Obtener la dirección correspondiente a las coordenas
        String googleMapsLink = getGoogleMapsLink(); // Obtener el enlace de Google Maps
        _sendLocation(googleMapsLink);
      }
    });
  }

  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String street = placemark.thoroughfare ?? ''; // Nombre de la calle
        String numero = placemark.street ?? '';
        String subLocality = placemark.subLocality ?? ''; // Sublocalidad o barrio
        String locality = placemark.locality ?? ''; // Localidad o ciudad
        String administrativeArea = placemark.administrativeArea ?? ''; // Área administrativa (estado, provincia, región, etc.)
        String country = placemark.country ?? ''; // País
        String postalCode = placemark.postalCode ?? ''; // Código postal

        // Construir la dirección con los datos disponibles
        return '$street, $numero, $subLocality, $locality, $administrativeArea, $country, $postalCode';
      } else {
        return 'Dirección no disponible';
      }
    } catch (e) {
      print("Error al obtener la dirección: $e");
      return 'Error al obtener la dirección';
    }
  }

  String getGoogleMapsLink(){
    if(latitude!=null && longitud!=null){
      return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitud';
    }else{
      return '';
    }
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

  Future<void>_sendLocation(String googleMapsLink) async {
    print("Enlace generado desde send: $googleMapsLink");
    String  addres = await _getAddressFromCoordinates(latitude!, longitud!);
    if(addres == null || addres.isEmpty){
      addres = 'Dirección no disponible';
    }
    UbicationURL  ubicationURL = UbicationURL(
        dir: addres,
        url: googleMapsLink);
    Emergency resultado = await EnviarEnlace(userId, ubicationURL, token);
    print("Resultado: ${resultado.statusCode}");
  }

  void _stopSendingLocation(){
    if(mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    if(_timer!=null){
      _timer.cancel();
    }
    //Mostrar un SnackBar con un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Dejando de compartir ubicación'),
    duration: Duration(seconds: 3),
    ),
    );

    Future.delayed(Duration(seconds: 3), (){
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

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
      }
    });
  }

  // Actualizar los colores de los íconos basados en el índice seleccionado
  void _updateIconColors() {
    setState(() {
      // Restaurar el color predeterminado para todos los íconos
      _iconColors = List<Color>.filled(5, Colors.grey[700]!);
      // Actualizar el color del ícono seleccionado
      _iconColors[_selectedIndex] = Colors.deepPurple;
    });
  }

  List<Color?> _iconColors = [
    Colors.deepPurple, // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];

  @override
  Widget build(BuildContext context){
    authBloc.saveLastScreem('send_location');
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          // AppBar
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
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
                  child: AppBar(
                    backgroundColor: Colors.transparent, // Hacemos el AppBar transparente
                    elevation: 0, // Quitamos la sombra del AppBar
                    leading: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0), // Margen para el círculo blanco
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Fondo blanco del círculo
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Padding interno para el ícono
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black87, // Color del icono
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //

          Container(
            width: double.infinity,
            color: Color(0xFFB9484B),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150.0), // Agrega espacio arriba del círculo
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Container(
                  width: screenWidth * 1.120,
                  height: screenWidth * 1.120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Color(0xFFCF4D51),
                      width: 87,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.789,
                      height: screenWidth * 0.789,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF55B60),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SOS',
                              style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: screenWidth * 0.13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '¡Necesito ayuda! Esta es mi ',
                              style: TextStyle(
                                fontFamily: 'SF Pro Text',
                                fontSize: 14.0,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'ubicación ',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'en tiempo real.',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro Text',
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
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
                  child: AppBar(
                    backgroundColor: Colors.transparent, // Hacemos el AppBar transparente
                    elevation: 0, // Quitamos la sombra del AppBar
                    leading: Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 0), // Margen para el círculo blanco
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Fondo blanco del círculo
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Padding interno para el ícono
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black87, // Color del icono
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: screenHeight*0.700, // Ajuste la posición vertical del contenedor del círculo
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  Text(
                    '¡Enviado a todos los contactos de emergencia seleccionados!',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      color: Color(0xFF5C5C75),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _stopSendingLocation,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
                        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey.withOpacity(0.5);
                          }
                          return Colors.transparent;
                        }),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 5.0),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                        'Dejar de compartir',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
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