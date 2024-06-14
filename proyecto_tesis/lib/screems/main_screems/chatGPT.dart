import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/main.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  String? _selectedQuestion;
  bool _isDropdownOpen = false;

  String? token;
  int? userId;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El diálogo no se puede cerrar tocando afuera
      builder: (BuildContext context) {
        return AlertDialog(
          title:Text('¿Salir de ChatGPT?',
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(child: Text('¿Estás seguro de que quieres salir de ChatGPT?')),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo sin salir de la aplicación
                  },
                ),
                TextButton(
                  child: Text('Sí'),
                  onPressed: () async{
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>  Configuration(),
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
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Map<String, String> predefinedResponses = {
    '1. ¿Cómo usar esta aplicación?': 'Para usar esta aplicación, primero debes registrarte e iniciar sesión. Luego puedes explorar las diferentes funcionalidades y características desde el menú principal.',
    '2. ¿Cómo registrarse en la aplicación?': 'Primero debes instalar la aplicación, luego cuado ingresas a la plataforma virtaul seras rediridigo a la pantalla de inicio de sesión y para que puedes registrarte debes presionar el enlace "Crear cuenta".',
    '3. ¿Cómo encuentro mis contactos de emegercia?': 'Primero inicia sesión, luego selecciona la opción mis contactos en la barra de navegación.',
    '4. ¿Cómo puedo encontrar mis contactos?': 'Primero inicia sesión, luego selecciona la opción mis contactos en la barra de navegación.',
    '5. ¿Cómo enviar una alerta de emergencia?': 'Primero debes iniciar sesión, luego debes agregar como mínimo un contacto de emergencia para enviar tu ubicación en tiempo real. Asimismo, tienes dos alternativas para enviar tu alerta  1. presionar el boton en la aplicación, 2. Agregando una palabra clave para activar mediante voz.',
    '6. ¿Donde puedo encontrar los números de ayuda de instituciones públicas?': 'Los números de instituciones publicas lo puede encontrar en la sección de configuraciones, presiona "Número de ayuda" y sera redirigido a la sección esperada',
    '7. ¿Cómo puedo recuperar mi contraseña en caso de haberla olvidado?': 'Esta en la pantalla de iniciar sesión, debes presionar en enlace que dice "¿Olvidaste tú contraseña?", luego sera redirigido a la pantalla de recuperación de contraseña donde tendras que ingresar tu correo electrónico y luego recibaras un código de verificación a tu correo para que puedas cambiar tu contraseña y volver a iniciar sesión',
    '8. ¿Cómo funciona la sección de reportes en la aplicación?': 'La sesión de reportes sirve para que puedes dejar constancia si has sufrido algun tipo de violencia por parte de tu pareja',
    '9. ¿Como funciona el reconocimiento de patrones en casos de feminicidio?': 'En este caso, primero debes completar el reporte, luego serás redirigido a la sección de empezar test de idetinficación de patrones, una vez presionado deberás responder una serie de preguntas que te ayudarán a reconocer el nivel de riesgo de feminicio',
    '10.¿Cómo agregar palabra clave?': 'Primero inicia sesión, luego deberas hacer clic en el boton ver palabra clave y seras redirigido a la pantalla para editar tu palabra clave ya que al inicio la aplicación misma te indica como debes agregar tu palabra clave para el reconocimiento de voz',
    '11.¿Cuál es el propósito de la aplicación?': 'El principal propósito de la aplicación es salvar vidas de mujeres cuando se encuentra en peligro',
    '12.¿Cómo se llama la aplicación?': 'La aplicación se llama Ms SoS',
    '13.¿Para que sirve la aplicación?': 'La aplicación sirve para identificar patrones en caso de femincidio a traves de Big Data. Asimismo, permite enviar tu ubicación en tiempo real a tu constactos de emergencia cuando te encuentras en peligro lo que permitirá que puedan saber en que parte estas y asi poder ayudarte',
    '14.¿Cómo editar mi perfil de usuario?': 'Primero debes haber iniciado sesión, luego presionar el boton de barra de navegación en la parte inferior llamado "Mi Perfil". Asimismo, una vez dentro de la pantalla del perfil de usuario presionar el boton "Editar" y automáticamente se abrirá un modal listo para actualizar tus datos ',
    '15.¿Quiénes son los autores del proyecto proyecto': 'Los autores son Dino Iván Pérez Vásquez y Antonio José Ferrandiz Bendezú',
    '16.¿Cuál es el objetivo de este proyecto': 'El proyecto tiene como finalidad ayudar a las mujeres en situaciones de peligro',
    // Agrega más preguntas y respuestas aquí según tus necesidades
  };

  // Función para encontrar la pregunta más similar usando la distancia de Levenshtein
  String findMostSimilarQuestion(String input) {
    int minDistance = input.length;
    String closestMatch = input;

    predefinedResponses.keys.forEach((question) {
      int distance = levenshteinDistance(input, question);
      if (distance < minDistance) {
        minDistance = distance;
        closestMatch = question;
      }
    });

    return closestMatch;
  }
  // Función para realizar la búsqueda fuzzy
  // Función para realizar la búsqueda fuzzy
  int levenshteinDistance(String a, String b) {
    int n = a.length;
    int m = b.length;
    List<List<int>> dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));

    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= m; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((value, element) => value > element ? element : value);
        }
      }
    }
    return dp[n][m];
  }

// Función para realizar la búsqueda fuzzy
  Future<void> _sendMessage(String text) async {
    try {

      setState(() {
        _messages.insert(0, {'sender':'ChatGPT', 'message': 'Cargando...'});
        _messages.insert(1, {'sender': 'User','message': text});
        _controller.clear();
      });

      if (_selectedQuestion != null) {
        String closestQuestion = findMostSimilarQuestion(text);
        // Busca la respuesta correspondiente a la pregunta seleccionada
        String? predefinedResponse = predefinedResponses[closestQuestion];
        if (predefinedResponse != null) {
          // Si se encuentra la respuesta, agrégala a los mensajes
          setState(() {
            _messages.removeAt(0); // Elimina el mensaje "Cargando..."
            _messages.insert(0, {'sender': 'ChatGPT', 'message': predefinedResponse});
          });
          _selectedQuestion = null;
          return; // Sale de la función para evitar enviar una solicitud a ChatGPT
        }
      }
        // Si no se encuentra una pregunta predefinida similar, realiza la solicitud al servicio de ChatGPT
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '', // Reemplaza con tu clave de API
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo-0125', // Modelo de ChatGPT
            'messages': [
              {'role': 'user', 'content': text}, // El mensaje del usuario
            ],
            'max_tokens': 150,
            'temperature': 0.7,
            'top_p': 1,
            'frequency_penalty': 0,
            'presence_penalty': 0,
          }),
        );

        if (response.statusCode == 200) {
          // Extrae el texto generado por ChatGPT de la respuesta y decodifica los caracteres especiales
          final data = jsonDecode(response.body);
          final generatedText = utf8.decode(data['choices'][0]['message']['content'].codeUnits);

          // Agrega el mensaje del usuario al principio de la lista
          setState(() {
            // Limpia el texto del TextField después de enviar el mensaje
            _messages.removeAt(0); // Elimina el mensaje "Cargando..."
            _messages.insert(0, {'sender': 'ChatGPT', 'message': generatedText});
          });
        } else {
          throw Exception('Failed to load response');
        }

    } catch (e) {
      print('Error en la solicitud: $e');
      // Maneja el error, por ejemplo, mostrando un mensaje al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    authBloc.saveLastScreem('chatGPT');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Altura personalizada para el AppBar
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/imagen.png'), // Ruta de la imagen de fondo
              fit: BoxFit.cover, // Ajusta la imagen para cubrir el área del Container
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Fondo del AppBar transparente
            elevation: 0, // Sin sombra
            automaticallyImplyLeading: false, // Deshabilita el botón de retorno
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white), // Define el borde blanco
                      borderRadius: BorderRadius.circular(20),
                      // Opcional: Define el radio de borde para que sea redondeado
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(left: 30),
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      height: 35,
                      // Establece un ancho máximo
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Establece el desplazamiento horizontal
                        controller: ScrollController(), // Configura un controlador de desplazamiento
                        child: DropdownButton<String>(
                          value: _selectedQuestion,
                          onChanged: (String? newValue) async {
                            setState(() {
                              _selectedQuestion = newValue;
                              _controller.text = newValue ?? '';
                              _isDropdownOpen = false;
                            });
                            if(newValue!=null){
                              await _sendMessage(newValue);
                            }
                          },
                          onTap: () {
                            setState(() {
                              _isDropdownOpen = !_isDropdownOpen;
                            });
                          },
                          underline: Container(), // Elimina el subrayado
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Row(
                                children: [
                                 // Espacio entre el icono y el texto
                                  Text(
                                    'Seleccione pregunta',
                                    style: TextStyle(
                                      fontFamily: 'SFProText',
                                      color: Colors.black54,
                                      fontSize: 13.0
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black54,
                                  ),

                                ],
                              ),

                            ),
                            ...predefinedResponses.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis, // Trunca el texto si es demasiado largo
                                    style: TextStyle(
                                      color: _selectedQuestion == value ? Colors.black : Colors.black,fontSize: 15
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 35),

                Container(
                  margin: EdgeInsets.only(right: 30),
                  child: InkWell(
                    onTap: () async {
                      await _showExitConfirmationDialog(context);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          left: 2,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Salir', style: TextStyle(color: Colors.black54, fontSize: 13)), // Tamaño del texto "Salir"
                              Icon(Icons.close_rounded, color: Colors.black54, size: 18), // Tamaño del icono "x"
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  final isUser = message['sender'] == 'User';
                  final isChatGPT = message['sender'] == 'ChatGPT';

                  // Agrega un mensaje adicional antes de cada mensaje del usuario o de ChatGPT
                  final userIndicator = isUser ? 'Usuario 🧑‍🎓' : '';
                  final chatGPTIndicator = isChatGPT ? 'ChatGPT respondiendo 🤖' : '';

                  return Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (userIndicator.isNotEmpty || chatGPTIndicator.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4,horizontal: 20),
                          child: Text(
                            isUser ? userIndicator : chatGPTIndicator,
                            style: TextStyle(
                              color: isUser ? Colors.black54 : Colors.grey, // Color del indicador del usuario y de ChatGPT
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        title: Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: isUser ? Color(0xFF7A72DE) : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isUser ? 24 : 4),
                                topRight: Radius.circular(isUser ? 4 : 24),
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            child: Text(
                              message['message']!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                reverse: true, // Invierte el orden de los elementos en el ListView
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300], // Color de fondo para el área de entrada de texto y botones
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Realiza tu pregunta...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white, // Color de fondo del campo de texto
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      await _sendMessage(_controller.text);
                      _controller.clear(); // Limpiar el texto del TextField después de enviar el mensaje
                    }
                  },
                  icon: Icon(Icons.send),
                  color: Color(0xFF7A72DE), // Color del botón de envío
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}