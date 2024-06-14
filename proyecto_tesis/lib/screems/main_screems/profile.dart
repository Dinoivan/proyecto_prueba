import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/screems/main_screems/configuration.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/services/sreems/citizen_service.dart';
import '../../blocs/register/register_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_tesis/screems/modals/editProfile.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class DateWidget extends StatefulWidget{

  final bool isEditing;
  final String previousBirthdayDate;
  final bool showCalendarIcon;
  final Function(String) updateDateController;// Nuevo estado para controlar la visibilidad del icono de calendario // Agrega una variable para almacenar el valor anterior de la fecha de nacimiento
  final TextEditingController birthdayDateController;

  DateWidget({required this.isEditing, required this.previousBirthdayDate, required this.showCalendarIcon, required this.updateDateController, required this.birthdayDateController});

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
    _dateController.text = widget.previousBirthdayDate;
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: widget.birthdayDateController,
      decoration: InputDecoration(
        suffixIcon: widget.showCalendarIcon ? Icon(Icons.calendar_today,color: Colors.black,): null,
        labelText: _dateController.text.isEmpty ? "Seleccione tu fecha de nacimiento": "",
        hintText: _dateController.text.isEmpty ? "": "Seleccione tu fecha de nacimiento",
        labelStyle:TextStyle(fontSize: 15.0, color: Colors.black),
        hintStyle:TextStyle(
            color: Colors.black,
            fontSize:15.0
        ),
        border: OutlineInputBorder(
          borderRadius:BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide:BorderSide(color: Colors.black26,width: 2.0),
          borderRadius:BorderRadius.circular(5),

        ),
      ),
      readOnly: !widget.isEditing,
      onTap: () async{
      if (widget.showCalendarIcon) {
        DateTime inicialDate = DateTime.now().toLocal();
        print('Fecha inicial: $inicialDate');
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: inicialDate,
          firstDate: DateTime(1942),
          lastDate: DateTime(2025),
        );
        if (pickedDate != null) {
          String formmatedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            _dateController.text = formmatedDate;
          });
          widget.updateDateController(formmatedDate);
        }
      }
      },
      keyboardType: TextInputType.datetime,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su fecha de nacimiento';
        }

        return null;
      },
    );
  }
}


class Profile extends StatefulWidget{

  final AuthBloc authBloc;

  Profile({required this.authBloc});

  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile>{
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? userId;
  String? token;
  late Future<Citizen> _citizenFuture;
  late SharedPreferences _prefs;

  bool _showSnackBar = false;

  File? _profileImage; // Variable para almacenar la imagen de perfil seleccionada

  late CitizenUpdate _citizenData = CitizenUpdate(
    firstname: '',
    lastname: '',
    birthdayDate: '',
    email: '',
  );

  bool _isEditing = false;
  bool _showDateWidget = true;

  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30,fontWeight: FontWeight.bold);

  static const List<Widget> widgetOptions = <Widget>[

    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Contacts',
      style: optionStyle,
    ),
    Text(
      'Index 3: Reports',
      style: optionStyle,
    ),
    Text(
        'Index 4: Settings'
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
          _selectedIndex = index;
          _updateIconColors();
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


  // Actualiza el controlador de fecha del perfil con el valor seleccionado
  void updateBirthdayDateController(String formattedDate) {
    setState(() {
      _birthdayDateController.text = formattedDate;
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
    Colors.grey[700], // Home
    Colors.blue, // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];


  @override
  void initState(){
    super.initState();
    _birthdayDateController.text = _citizenData.birthdayDate;
    _initPrefs();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });

    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      if(decodedToken.containsKey('user_id')){
        userId = decodedToken["user_id"];
        _loadCitizen();
      }
    }
  }

  Future<void> _loadCitizen() async{
    _citizenFuture = citizenById(token!, userId!);
  }


  void _enableEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _birthdayDateController.text = _citizenData.birthdayDate; // Actualiza el controlador con la fecha de cumpleaños actual al iniciar la edición
      }
    });
  }

  // Este es el método que reduce el tamaño de la imagen
  Future<File?> _reduceImageSize(File imageFile) async {
    try {
      // Leer la imagen original como bytes
      List<int> imageBytes = await imageFile.readAsBytes();
      // Decodificar la imagen original
      img.Image originalImage = img.decodeImage(imageBytes)!;
      // Reducir la imagen a 600x600 (puedes ajustar este tamaño según tus necesidades)
      img.Image resizedImage = img.copyResize(originalImage, width: 600);
      // Guardar la imagen reducida en un nuevo archivo
      File reducedImageFile = File('${imageFile.path}');
      await reducedImageFile.writeAsBytes(img.encodeJpg(resizedImage, quality: 85));
      return reducedImageFile;
    } catch (e) {
      print('Error al reducir el tamaño de la imagen: $e');
      return null;
    }
  }

  // Método para desactivar la edición y ocultar el DateWidget
  void _disableEditing() {
    setState(() {
      _isEditing = false;
      _showDateWidget = false;
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadProfileImage();
  }

  Future<File?> _loadProfileImage() async {
    final String? imagePath = _prefs.getString('profile_image_$userId');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
      return _profileImage;
    }
    return null;
  }

  void _showSnackBarIfNeeded(String message, bool isSave) {
    if (_showSnackBar) {
      Color backgroundColor = isSave ? Colors.green : Colors.red;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
          backgroundColor: backgroundColor,
        ),
      );
      setState(() {
        _showSnackBar = false; // Después de mostrar el Snackbar, restablece el estado a false
      });
    }
  }

  Future<void> _saveProfileImage(File imageFile) async {
    await _prefs.setString('profile_image_$userId', imageFile.path);
    setState(() {
      _profileImage = imageFile;
      _showSnackBar = true;
    });
  }

  Future<void> _deleteProfileImage() async {
    try {
      // Eliminar la imagen de perfil guardada de las preferencias compartidas
      await _prefs.remove('profile_image_$userId');
      // Actualizar el estado para mostrar la imagen predeterminada
      setState(() {
        _profileImage = null;
        _showSnackBar = true;
      });
    } catch (e) {
      print('Error al eliminar la imagen de perfil: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);
      await _saveProfileImage(imageFile);
      _showSnackBarIfNeeded('Imagen guardada correctamente.', true); // Llama a _showSnackBarIfNeeded después de guardar la imagen
    }
  }

  Future<void> _showUploadOrDeleteModal() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar acción'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Subir nueva foto'),
                  onTap: () {
                    Navigator.of(context).pop(); // Cierra el modal
                    _pickImage(); // Abre la galería para seleccionar una nueva foto
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Eliminar foto'),
                  onTap: () async {
                    Navigator.of(context).pop(); // Cierra el modal
                   await  _deleteProfileImage(); // Elimina la foto de perfil
                    _showSnackBarIfNeeded('Imagen eliminada correctamente.', false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    authBloc.saveLastScreem('profile');
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
                transitionsBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 5),
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
                padding: EdgeInsets.fromLTRB(32.0,5.0, 20.0, 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mi perfil',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 30.0, top: 15.0),
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    FutureBuilder<File?>(
                      future: _loadProfileImage(),
                      // Carga la imagen de perfil guardada
                      builder: (context, snapshot) {
                        double opacity = snapshot.connectionState ==
                            ConnectionState.waiting ? 0.0 : 1.0;
                        return AnimatedOpacity(
                          opacity: opacity,
                          duration: Duration(milliseconds: 1000),
                          // Duración de la animación en milisegundos
                          child: GestureDetector(
                            onTap: () async {
                              if (snapshot.data != null) {
                                // Si hay una imagen de perfil, muestra un modal para elegir si subir o eliminar la foto
                                await _showUploadOrDeleteModal();
                              } else {
                                // Si no hay una imagen de perfil, abre la galería directamente
                                await _pickImage();
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              // Hacer que la imagen sea circular
                              child: snapshot.data != null
                                  ? Image
                                  .file( // Mostrar la imagen de perfil cargada si existe
                                snapshot.data!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Image
                                  .asset( // Mostrar la imagen predeterminada si no hay ninguna imagen cargada
                                "assets/Perfil.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          var profileImage = await _loadProfileImage();
                          if (profileImage != null) {
                            // Si hay una imagen de perfil, muestra un modal para elegir si subir o eliminar la foto
                            await _showUploadOrDeleteModal();

                          } else {
                            // Si no hay una imagen de perfil, abre la galería directamente
                            await _pickImage();

                          }
                        },
                        icon: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),

              FutureBuilder<Citizen>(
                future: _citizenFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final Citizen citizen = snapshot.data!;

                    _fullnameController.text = citizen.firstname;
                    _lastNameController.text = citizen.lastname;
                    String cumple = citizen.birthdayDate;

                    // Convierte el valor de milisegundos a un objeto DateTime
                    DateTime birthdayDateTime = DateTime
                        .fromMillisecondsSinceEpoch(int.tryParse(cumple) ?? 0);

                    birthdayDateTime = birthdayDateTime.add(Duration(days: 1));

                    // Formatea el objeto DateTime en el formato de fecha deseado
                    _birthdayDateController.text =
                        DateFormat('dd/MM/yyyy').format(birthdayDateTime);

                    _emailController.text = citizen.email;

                    return Form(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 32.0,
                            horizontal: 30), // Solo
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _fullnameController,
                              readOnly: !_isEditing,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]')), // Permite letras y espacios, incluyendo acentos
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                labelText: "Nombres",
                                hintText: " Nombres",
                                helperStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                              ),

                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _lastNameController,
                              readOnly: !_isEditing,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                labelText: "Apellidos",
                                hintText: " Apellidos",
                                helperStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z,áéíóúÁÉÍÓÚ\s]')), // Permite letras, coma y espacios
                              ],
                            ),

                            SizedBox(height: 20,),

                            // Muestra el DateWidget si _isEditing es verdadero y _showDateWidget es verdadero
                            if (_isEditing && _showDateWidget)
                              DateWidget(
                                isEditing: _isEditing,
                                previousBirthdayDate: citizen.birthdayDate,
                                showCalendarIcon: true,
                                updateDateController: updateBirthdayDateController,
                                birthdayDateController: _birthdayDateController,

                              ),
                            if(!_isEditing)
                              TextFormField(
                                controller: _birthdayDateController,
                                readOnly: !_isEditing,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                        color: Colors.black26, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                        color: Colors.black26, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2.0),
                                    borderSide: BorderSide(
                                        color: Colors.black26, width: 2.0),
                                  ),
                                  labelText: "Fecha de nacimiento",
                                  hintText: " Fecha de nacimiento",
                                  helperStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z,áéíóúÁÉÍÓÚ\s]')), // Permite letras, coma y espacios
                                ],
                              ),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: _emailController,
                              readOnly: !_isEditing,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.black26, width: 2.0),
                                ),
                                labelText: "Correo",
                                hintText: " Correo",
                                helperStyle: const TextStyle(
                                  color: Color(0xFFACACAC),
                                  fontFamily: 'SF Pro Text',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z,áéíóúÁÉÍÓÚ\s]')), // Permite letras, coma y espacios
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 45.0),
                            ),

                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  //Obtener la fecha de nacimiento del controlador y convertirla al formato requerido
                                  print("En al función _updateCitizen: $token");
                                  print(
                                      "Datos actualizados: ${_fullnameController.text}, ${_lastNameController.text}, ${_birthdayDateController.text}, ${_emailController.text}");
                                  String formatedBirthdayDate = DateFormat(
                                      'yyyy-MM-dd').format(birthdayDateTime);
                                  print(
                                      "Fecha formateada: $formatedBirthdayDate");


                                  CitizenUpdate updated = CitizenUpdate(
                                    firstname: _fullnameController.text,
                                    lastname: _lastNameController.text,
                                    birthdayDate: _birthdayDateController.text,
                                    email: _emailController.text,
                                  );

                                  CitizenUpdate updatedContact = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return EditCitizenModal(citizen: updated);
                                    },
                                  );
                                  // Si updatedContact no es nulo, significa que se guardaron cambios, así que actualiza la lista
                                  if (updatedContact != null) {
                                    await _loadToken();
                                  }
                                  // Imprimir la respuesta del servicio
                                },

                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(Color(0xFF7A72DE)),
                                  shape: MaterialStateProperty.all<
                                      OutlinedBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              40.0))
                                  ),

                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(vertical: 10.0),
                                  ),

                                ),
                                child: Center(
                                  child: Text(
                                    _isEditing ? 'Guardar' : 'Editar',
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
                    );
                  }
                  return SizedBox();
                },
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



    );

  }

}


