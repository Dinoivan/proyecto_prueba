import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import '../../blocs/register/register_bloc.dart';
import '../../services/sreems/result_service.dart';
import 'emergency_contacts.dart';
import 'home.dart';
import 'package:fl_chart/fl_chart.dart';

class RiskCircularChart extends StatelessWidget {
  final double percentage;
  final String risk;
  final List<Color> riskColors; // Nuevo parámetro para los colores de riesgo

  RiskCircularChart({required this.percentage, required this.risk, required this.riskColors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            height:MediaQuery.of(context).size.width*0.3,
            child: PieChart(
              PieChartData(
                sections: _getSections(mediaQuery: MediaQuery.of(context)),
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 40,
                sectionsSpace: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections({required MediaQueryData mediaQuery}) {
    double chartSize = mediaQuery.size.width * 0.2;
    double sectionRadius = chartSize / 2 -20;
    return [
      PieChartSectionData(
        value: 10,
        color: riskColors[0], // Usar el color correspondiente al primer riesgo
        title: '',
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        radius: sectionRadius,
      ),
      PieChartSectionData(
          value: 20,
          color: riskColors[1], // Usar el color correspondiente al segundo riesgo
          title: '',
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          radius: sectionRadius
      ),
      PieChartSectionData(
          value: 20,
          color: riskColors[2], // Usar el color correspondiente al tercer riesgo
          title: '',
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          radius: sectionRadius
      ),
      PieChartSectionData(
          value: 20,
          color: riskColors[3], // Usar el color correspondiente al cuarto riesgo
          title: '',
          titleStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          radius: sectionRadius
      ),
      PieChartSectionData(
        value: 30,
        color: riskColors[4], // Usar el color correspondiente al quinto riesgo
        title: '',
        titleStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        radius: sectionRadius,
      ),
    ];
  }

}

// Modelo de datos para el gráfico de torta
class RiskData {
  final String risk;
  final int value;

  RiskData(this.risk, this.value);
}

class Result extends StatefulWidget {

  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  // Definir una lista de colores correspondientes a cada riesgo
  final List<Color> _riskColors = [
    Colors.green,
    Colors.lightBlue,
    Colors.orange,
    Colors.red,
    Colors.purple,
  ];

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController imagenController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 3;
  bool _isLoading = true; // Agrega esta variable de estado

  int? userId;
  String? token;
  String? resultadoP;
  String? porcentaje;
  String? riesgo;
  String? valor1;
  String? valor2;

  static const TextStyle optionStyle = TextStyle(fontSize: 30,fontWeight: FontWeight.bold);

  static const List<Widget> widgetOptions = <Widget>[

    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Mi perfil',
      style: optionStyle,
    ),
    Text(
      'Index 2: Contactos',
      style: optionStyle,
    ),
    Text(
      'Index 3: Reportes',
      style: optionStyle,
    ),
    Text(
        'Index 4: Configura'
    )

  ];

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
              transitionDuration: Duration(milliseconds: 5),
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
  void initState() {
    _loadToken();
  }

  Future<void> _loadToken() async {

    setState(() {
      _isLoading = true; // Indica que la información está siendo cargada
    });

    try{

      String? storedToken = await authBloc.getStoraredToken();
      setState(() {
        token = storedToken;

      });

      if(token!=null){
        Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
        print("Token decodificado: $decodedToken");

        if(decodedToken.containsKey("user_id")){
          userId = decodedToken["user_id"];
        }
      }

      List<String>? resultado = await getReportPrediction(userId, token);

      print("Hola soy el token del navbar: $token");
      print("Hola soy el id: $userId");
      print("Resultado: $resultado");

      setState(() {
        if (resultado != null) {
          if (resultado.length >= 2) { // Verificar si hay al menos un elemento en la lista
            // Obtener el porcentaje del primer elemento y eliminar los caracteres adicionales
             porcentaje = resultado[0].replaceAll('"', '').substring(1);
             riesgo = resultado[1].replaceAll('"','').replaceAll(']', '');
            //porcentaje = null;
            //riesgo = null;
            print("Porcentaje: $porcentaje");
          } else {
            print("La lista de resultados está vacía");
          }
        } else {
          print("Error al obtener el resultado");
        }

      });
    }catch(e){
      print("Error al cargar el token: $e");
    } finally{
      setState(() {
        // Puedes guardar el resultado en una variable de estado si quieres utilizarlo en tu interfaz
        // Por ejemplo:
        _isLoading = false;
      });
    }
    // Actualiza el estado para que Flutter repinte la interfaz
  }

  // Lista de riesgos con sus respectivos porcentajes predeterminados
  List<RiskData> riskDataList = [
    RiskData('Riesgo Bajo', 10),
    RiskData('Riesgo Moderado', 30),
    RiskData('Riesgo Alto', 50),
    RiskData('Riesgo Muy Alto', 70),
    RiskData('Riesgo Extremo', 100),
  ];

  @override
  Widget build(BuildContext context) {
    authBloc.saveLastScreem('result');
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            final RegisterBloc registerBloc = RegisterBloc();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Report(registerBloc: registerBloc),
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

      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Nivel de Riesgo',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Form(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Conoce los resultados del test de identificación de patrones:',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color(0xFFCA4A4A4),
                            fontFamily: 'SF Pro Text',
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                        SizedBox(height: 5.0,),

                        // Reemplazar la imagen con RiskChart
                         RiskCircularChart(
                            risk: riesgo ?? '',
                           percentage: porcentaje != null ? double.tryParse(porcentaje!.replaceAll(RegExp(r'%|\D'), '')) ?? 0.0 / 100.0 : 0.0,
                            riskColors: _riskColors,
                          ),

                        // Muestra el indicador de carga o los resultados según el estado de _isLoading
                        _isLoading
                            ? CircularProgressIndicator() // Si isLoading es verdadero, muestra un CircularProgressIndicator
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if(porcentaje != null && riesgo != null)
                                Text(
                                  '$porcentaje',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: _getRiskColor(double.parse(porcentaje!.replaceAll('%', ''))),// Obtén el color correspondiente al riesgo
                                ),
                              ),

                              if(porcentaje != null && riesgo != null)
                                Text(
                                  '$riesgo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: _getRiskColor(double.parse(porcentaje!.replaceAll('%', ''))), // Obtén el color correspondiente al riesgo
                                ),
                              ),

                              if(porcentaje == null && riesgo == null)
                                Text('55.8%', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,// Obtén el color correspondiente al riesgo
                                  ),
                                ),
                              if(porcentaje == null && riesgo == null)
                                Text('Riesgo muy alto', textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,// Obtén el color correspondiente al riesgo
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Column(
                        children: riskDataList.map((riskData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    riskData.risk,
                                    style: TextStyle(fontWeight: FontWeight.normal,fontFamily: 'Roboto',fontSize: 14.0),
                                  ),
                                  Text(
                                    '<= ${riskData.value}%',
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                    color: _getRiskColor(riskData.value.toDouble()
                                    ),
                                   ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                      ),

                    ],
                  ),
                ),
              ),
            ],
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
      // Mostrar el SnackBar cuando _showSuccessMessage sea verdadero

    );


  }

  Color _getRiskColor(double percentage) {
    if(percentage <= 10){
      return _riskColors[0];
    }else if (percentage <= 30){
      return _riskColors[1];
    }else if (percentage <= 50){
      return _riskColors[2];
    }else if (percentage <= 70){
      return _riskColors[3];
    }else{
      return _riskColors[4];
    }
  }
}

