import 'package:flutter/material.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/main_screems/result.dart';

import '../../models/screems/questionaire_model.dart';
import '../../services/sreems/questionaire_service.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionaireState createState() => _QuestionaireState();
}

class _QuestionaireState extends State<Questionnaire> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaSucesoController = TextEditingController();
  TextEditingController respuestaAbiertaController = TextEditingController();
  FocusNode respuestaAbiertaFocusNode = FocusNode();

  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 0;
  bool _isLoading = true; // Agrega esta variable de estado

  String? token;
  List<String>? Cuestionarios;

  List<Question>? preguntas;
  int preguntaActualIndex = 0;
  int? selectedOptionIndex;
  String respuestaAbierta = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {

    setState(() {
      _isLoading = true; // Indica que la información está siendo cargada
    });

    try {
      String? storedToken = await authBloc.getStoraredToken();
      setState(() {
        token = storedToken;
      });

      print("Token: $token");
      await _getCuestionarios();
    }catch(e){
      print("Error al cargar el token: $e");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCuestionarios() async {
    try {
      List<Question>? cuestionarios = await getAllQuestions(token);
      print("Preguntas: $cuestionarios");

      setState(() {
        preguntas = cuestionarios;
      });
    } catch (e) {
      print('Error al obtener cuestionarios: $e');
    }
  }

  void handleOptionSelected(int? index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  bool isNumericQuestion(int questionIndex) {
    return [1, 2].contains(questionIndex); // Añadir los índices adecuados
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  void handleNextQuestion() async {
    print('selectedOptionIndex: $selectedOptionIndex');
    print('respuestaAbiertaController.text: ${respuestaAbiertaController.text}');

   if(isNumericQuestion(preguntaActualIndex)){
     if(respuestaAbiertaController.text.isEmpty || !_isNumeric(respuestaAbiertaController.text)){
       _showNumericModal();
       return;
     }
   }

    if (selectedOptionIndex == null && respuestaAbiertaController.text.isEmpty) {
      _showSelectionModal();
      return;
    }
    // Realizar trabajo asíncrono fuera del setState
    if (preguntaActualIndex < preguntas!.length) {
      if (preguntaActualIndex == 1 || preguntaActualIndex == 2) {
        await _guardarRespuesta(
          preguntas![preguntaActualIndex].id, 0, respuestaAbiertaController.text,
        );
      } else {
        // Lógica para la pregunta 4
        if (preguntaActualIndex == 3 && selectedOptionIndex == 1) {
          preguntaActualIndex = 4;
          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        } else {
          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        }
      }
      // Verificar si se debe navegar a la pantalla Resultado
      if (preguntaActualIndex == 6) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Result(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 5),
          ),
        );
        print("Fin del cuestionario");
      }else{
        preguntaActualIndex++;
        print("Contador: $preguntaActualIndex");
        print("Total: ${preguntas!.length}");
        print("Hola");
        print("Hola como estas");
        selectedOptionIndex = null;
        respuestaAbiertaController.clear();
      }
    }

    // Actualizar el estado sin código asíncrono
    setState(() {
      // No es necesario realizar ninguna actualización de estado aquí
    });
  }



  void _showSelectionModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Atención!',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
        content: Text('Debe seleccionar una opción antes de continuar.',textAlign: TextAlign.justify,),
        actions: [
             TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),

        ],
      ),
    );
  }

  void _showNumericModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¡Atención!',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
        content: Text('Debe ingresar un número antes de continuar.',textAlign: TextAlign.justify,),
        actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
        ],
      ),
    );
  }

  Future<void>_guardarRespuesta(int questionId,int optionId, String answerText) async{
    try{
      //Llamo al servicio de guardar
      String? result = await Guardar(CuestionarioModel(
        answerText: answerText,
        optionId: optionId,
        questionId: questionId,
      ), token,
      );
      print(result);
    }catch(e){
      print("Error al guardar respuesta: $e");
    }
  }

  // Método para mostrar el modal de confirmación al presionar el botón de salir
  Future<void> _showExitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Desea salir?'),
          content: Text('¿Está seguro de que desea salir del cuestionario?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Si'),
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
                    transitionDuration: Duration(milliseconds: 5),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    respuestaAbiertaController.dispose();
    respuestaAbiertaFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    authBloc.saveLastScreem('questionnaire');
    if(_isLoading){
      return Center(child: CircularProgressIndicator(),
      );
    }

    if (preguntas == null || preguntas!.isEmpty) {
      return Text('No hay preguntas disponibles');
    }

    Question preguntaActual = preguntas![preguntaActualIndex];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Altura personalizada para el AppBar
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/imagen.png'), // Ruta de la imagen de fondo
              fit: BoxFit.cover, // Ajusta la imagen para cubrir el área del Container
            ),
          ),
          child: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent, // Fondo del AppBar transparente para mostrar el Container detrás
            elevation: 0, // Sin sombra
            centerTitle: true,
            automaticallyImplyLeading: false,// Centra el título del AppBar
            actions: [
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Salir', style: TextStyle(color: Color(0xFF7A72DE))),
                          IconButton(
                            onPressed: _showExitConfirmationDialog,
                            icon: Icon(Icons.close, color: Color(0xFF7A72DE),size: 20,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Puedes añadir más opciones de configuración del AppBar aquí
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${preguntaActualIndex + 1} DE ${preguntas!.length}',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,fontFamily: 'Roboto'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "${preguntaActualIndex + 1}. ${preguntaActual.questionText}",
                    style: TextStyle(color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,),
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 0; i < preguntaActual.options.length; i++)
                        InkWell(
                          onTap: () {
                            handleOptionSelected(i);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedOptionIndex == i
                                  ? Colors.blueAccent.withOpacity(0.2)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selectedOptionIndex == i
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${String.fromCharCode(i + 65)}. ${preguntaActual.options[i].optionText}",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                selectedOptionIndex == i
                                    ? Icon(
                                  Icons.check,
                                  color: Colors.blueAccent,
                                )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  // Mostrar input de texto para preguntas sin opciones
                  if (preguntaActual.options.isEmpty)
                    TextFormField(
                      controller: respuestaAbiertaController,
                      focusNode: respuestaAbiertaFocusNode,
                      onChanged: (text) {
                        setState(() {
                          respuestaAbierta = text;
                        });
                      },
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(
                          color: Color(0xFFACACAC),
                          fontFamily: 'SF Pro Text',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                        ),
                        hintText: 'Ingresa tu respuesta (solo números)',
                        helperStyle: const TextStyle(
                          color: Color(0xFFACACAC),
                          fontFamily: 'SF Pro Text',
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: (preguntaActualIndex > 0)
                        ? () {
                      setState(() {
                        preguntaActualIndex--;
                        selectedOptionIndex = null;
                        respuestaAbiertaController.clear();
                      });
                    }
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: (preguntaActualIndex > 0) ? Colors.grey : Colors.grey,
                      ),
                      backgroundColor: (preguntaActualIndex > 0) ? Colors.white : Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'Anterior',
                      style: TextStyle(color: (preguntaActualIndex > 0) ? Colors.black : Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: handleNextQuestion,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.deepPurpleAccent),
                      backgroundColor: Color(0xFFF7A72DE),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text('Siguiente', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}