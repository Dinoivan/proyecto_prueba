import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/test.dart';
import 'package:proyecto_tesis/models/screems/report_model.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import '../../services/sreems/report_service.dart';
import 'emergency_contacts.dart';
import 'home.dart';


class DateWidget extends StatefulWidget{

  final RegisterBloc birthdayBloc;

  DateWidget({required this.birthdayBloc});

  @override
  State<DateWidget> createState(){
    return _DateWidgetState();
  }
}

class _DateWidgetState extends State<DateWidget>{
  TextEditingController _dateController = TextEditingController();

  @override
  void initState(){
    super.initState();

    String? currentBirthdayDate = widget.birthdayBloc.getCurrentBirthday();
    if(currentBirthdayDate != null){
      _dateController.text = currentBirthdayDate;
    }
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_today, color: Colors.grey,),
        labelText: _dateController.text.isEmpty ? "Fecha de suceso": "",
        hintText: _dateController.text.isEmpty ? "": "Fecha de suceso",
        labelStyle:TextStyle(fontSize: 15.0,  fontFamily: 'SF Pro Text',
          color: Color(0xFFACACAC),),
        hintStyle:TextStyle(
            color: Color(0xFF79747E),
            fontSize:16.0
        ),
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

        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      readOnly: true,
      onTap: () async{
        DateTime now = DateTime.now();
        DateTime inicialDate = DateTime.now().toLocal();
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: inicialDate,
          firstDate: DateTime(1942),
          lastDate: now,
        );
        if(pickedDate!=null){
          String formmatedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          widget.birthdayBloc.updateBirthdayDate(formmatedDate);
          setState(() {
            _dateController.text = formmatedDate;

          });
        }
      },
      keyboardType: TextInputType.datetime,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese fecha de suceso';
        }

        return null;
      },
    );
  }
}

class Report extends StatefulWidget{

  final RegisterBloc registerBloc;
  
  Report({required this.registerBloc});
  
  @override
  _ReportState createState() => _ReportState();

}

class _ReportState extends State<Report>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();


  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  String? token;


int _selectedIndex = 3;

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
  void initState(){
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });
  }

  @override
  Widget build(BuildContext context){
    authBloc.saveLastScreem('report');
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
                  padding: EdgeInsets.fromLTRB(30, 0, 10, 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Generar reporte',
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
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:16.0,
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
                            labelText: _nameController.text.isEmpty ? "Nombre" : "",
                            labelStyle: const TextStyle(
                              fontFamily: 'SF Pro Text',
                              color: Color(0xFFACACAC),
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: _nameController.text.isEmpty ? "": " Nombre",
                            helperStyle: const TextStyle(
                              fontFamily: 'SF Pro Text',
                              color: Color(0xFFACACAC),
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                          ),
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {

                              return 'Por favor, ingrese su nombre';
                            }
                            final RegExp letterRegex = RegExp(r'[a-zA-Z]');
                            if(!letterRegex.hasMatch(value)){
                              return 'Solo se permiten palabras';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20,),
                        Container(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child:TextFormField(
                              controller: _descriptionController,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              maxLines: 5, // Esto permite un número ilimitado de líneas
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black26,width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black26,width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(color: Colors.black26,width: 2),
                                ),

                                hintText: "Descripción de los hechos",
                                hintStyle: TextStyle(
                                  fontFamily: 'SF Pro Text',
                                  color: Color(0xFFACACAC),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'por favor, ingrese descripcion de reporte';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        DateWidget(birthdayBloc: widget.registerBloc),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 95.0),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:() async {
                              if(_formKey.currentState != null && _formKey.currentState!.validate()){

                                String birthdayDate = widget.registerBloc.getCurrentBirthday()!;
                                DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(birthdayDate);
                                String formattedBirthdayDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                                // Crear un objeto Report con los datos del formulario
                                Report_ report = Report_(
                                  createdDate: DateTime.now().toIso8601String(),
                                  description: _descriptionController.text,
                                  name: _nameController.text,
                                  reportStatus: 'Archivado',
                                  reportingDate: formattedBirthdayDate,
                                );

                                setState(() {
                                  _isLoading = true;
                                });

                                try {

                                  ReportResponse response = await saveReport(report, token);

                                  if(response.statusCode == 200){

                                    print("Resultado de estado correcto: ${response.statusCode}");

                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Test(),
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
                                        content: Text('Se guardo con exito el reporte'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }else{
                                    print("Resultado de estado en else: ${response.statusCode}");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sucedio un error al guardar reporte'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      ),
                                    );

                                  }

                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error de servicio'),
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
                                EdgeInsets.symmetric(vertical:10.0),
                              ),

                            ),

                            child: _isLoading ? CircularProgressIndicator() :  Text(
                              'Guardar',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
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