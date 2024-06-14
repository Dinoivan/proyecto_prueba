import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/add_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/chatGPT.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/head_map.dart';
import 'package:proyecto_tesis/screems/main_screems/help.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/screems/main_screems/keyword.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/screems/main_screems/questionnaire.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/main_screems/result.dart';
import 'package:proyecto_tesis/screems/main_screems/send_location.dart';
import 'package:proyecto_tesis/screems/main_screems/test.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tesis/screems/main_screems/shakeDetector.dart';

final authBloc = AuthBloc();
final registerBloc = RegisterBloc();

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ShakeDetector()),
    ],
        child: const MyApp()

    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Map<String, WidgetBuilder> routes = {
      'login_screems': (context) => LoginPage(authBloc: authBloc),
      'home': (context) => Home(),
      'add_contacts': (context) => AddContacts(),
      'chatGPT':  (context) => ChatScreen(),
      'configuration': (context) => Configuration(),
      'emergency_contacts': (context) => EmergencyContacts(),
      'help': (context) => Help(),
      'help_map': (context) => HeadMap(),
      'keyword': (context) => KeyWord(),
      'profile': (context) => Profile(authBloc: authBloc),
      'questionnaire': (context) => const Questionnaire(),
      'report': (context) => Report(registerBloc: registerBloc,),
      'result': (context) => const Result(),
      'send_location': (context) => SendLocation(),
      'test': (context) => Test(),
      // Agrega más rutas según sea necesario
    };
    return ShakeListenerWidget(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'SFProText'),
        ),
      ),
      home: const ProviderDemoScreen(),
      routes: routes,
     ),
    );
  }
}

class ProviderDemoScreen extends StatefulWidget {

  const ProviderDemoScreen({Key? key}) : super(key: key);

  @override
  _ProviderDemoScreenState createState() => _ProviderDemoScreenState();
}

class _ProviderDemoScreenState extends State<ProviderDemoScreen> {

  @override
  void initState() {
    super.initState();
    redirectToLastScreen();
  }

  Widget _getPage(String lastScreen) {
    switch (lastScreen) {
      case 'login_screems':
        return LoginPage(authBloc: authBloc);
      case 'home':
        return Home();
      case 'add_contacts':
        return AddContacts();
      case 'chatGPT':
        return ChatScreen();
      case 'configuration':
        return Configuration();
      case 'emergency_contacts':
        return EmergencyContacts();
      case 'help':
        return Help();
      case 'help_map':
        return HeadMap();
      case 'keyword':
        return KeyWord();
      case 'profile':
        return Profile(authBloc: authBloc);
      case 'questionnaire':
        return Questionnaire();
      case 'report':
        return Report(registerBloc: registerBloc);
      case 'result':
        return Result();
      case 'send_location':
        return SendLocation();
      case 'test':
        return Test();
    // Agrega más casos según sea necesario
      default:
        throw Exception("Ruta desconocida: $lastScreen");
    }
  }

  Future<void> redirectToLastScreen() async {
    // Espera un poco antes de redirigir, simulando algún proceso asíncrono
    await Future.delayed(const Duration(seconds: 3));

    // Verifica si hay un token almacenado
    final token = await authBloc.getStoraredToken();

    print("Esto es el token del main: $token");

    if (token != null) {
      // Si hay un token, intenta recuperar el nombre de la última pantalla visitada
      final lastScreen = await authBloc.getLastSCreem();

      print("Pantalla recuperada: $lastScreen");

      if (lastScreen != null) {
        // Si se recuerda la última pantalla visitada, redirige al usuario a esa pantalla
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => _getPage(lastScreen),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 5), // Ajusta la duración de la transición según sea necesario
          ),
        );
      } else {
        // Si no se recuerda la última pantalla, redirige al usuario a la pantalla principal
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
      }
    } else {
      // Si no hay un token, redirige al usuario a la pantalla de inicio de sesión
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
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/Frame.png"),
            ),
          ],
        ),
      ),
    );
  }
}

class ShakeListenerWidget extends StatelessWidget {
  final Widget child;

  const ShakeListenerWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShakeDetector>(
      builder: (context, shakeDetector, child) {
        if (shakeDetector.shook) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Dispositivo Sacudido"),
                  content: Text("¡Has sacudido el dispositivo!"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cerrar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ).then((_) {
              // Resetea el flag después de que se cierra el modal
              shakeDetector.resetShake();
            });
          });
        }
        return child!;
      },
      child: child,
    );
  }
}
