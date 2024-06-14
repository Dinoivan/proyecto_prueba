import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:proyecto_tesis/models/screems/ubicacation_model.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/services/sreems/send_emergency_contact_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/main.dart';
import 'dart:async';

class PanicButtonModal extends StatefulWidget {

  @override
  _PanicButtonModalState createState() => _PanicButtonModalState();

}

class _PanicButtonModalState extends State<PanicButtonModal>{

  StreamSubscription<Position>? _positionStreamSubscription;


  double? latitude;
  double? longitud;
  Position? previousPosition;

  String? address = '';

  int? userId;
  String? token;
  late Timer _timer;
  bool _isLoading = false;
  int? Resultado;

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
        String googleMapsLink = getGoogleMapsLink(); // Obtener el enlace de Google Maps con las coordenadas más recientes
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
    Resultado = resultado.statusCode;
    print("Resultado: ${resultado.statusCode}");
    print("Verificación: ${Resultado}");
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Configuration()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10), // Eliminar el padding interior del AlertDialog
      titlePadding: EdgeInsets.fromLTRB(5, 5, 5, 5), // Eliminar el padding interior del título
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Row(
              children: [
                SizedBox(width: 122),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset('assets/logo-upc.png', height: 30),
                ),
              // Asegúrate de tener un logo en assets
            ],
          ),
        ],
      ),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
            Container(
              decoration: BoxDecoration(
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 5.0,top: 5.0,bottom: 0.0),
              child: Text(
                Resultado == 200 ? 'Enviando ubicación': 'Cargando...',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: 56,
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
                  Resultado == 200 ? 'Dejar de compartir': 'En espera...',
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
    );
  }
}