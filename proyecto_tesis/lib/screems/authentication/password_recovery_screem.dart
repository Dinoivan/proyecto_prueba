import 'package:flutter/material.dart';
import 'package:proyecto_tesis/models/autentication/password_recovery_model.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/password_change_screem.dart';

class PasswordRecovery extends StatefulWidget {

  final AuthBloc authBloc;

  PasswordRecovery({required this.authBloc});

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildImage(),
              _buildTitle(),
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(){
    return Row(
      children: [
        Expanded(
          child: Image(
            image: AssetImage("assets/principal_.png"),
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(){
    return Container(
      margin: EdgeInsets.only(left: 40.0,top: 20.0), // Agrega un margen a la izquierda
      alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
      child: Text(
        'Recuperar contraseña',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0,),
            _buildEmailFormField(),
            SizedBox(height: 25.0,),
            _buildSubmitButton(),
            SizedBox(height: 20.0,),
            _buildLoginPageButton()
            // Campos del formulario...
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFormField() {
    return  TextFormField(
      controller: _emailController,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26,width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.black26, width: 2.0),
        ),
        labelText:  _emailController.text.isEmpty ? "Correo": "",
        hintText: _emailController.text.isEmpty ? "": "Correo",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese un correo electrónico';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Ingrese un correo eléctrónico válido';
        }
        return null;
      },
    );
  }


  void _validateForm() async{

    if(_formKey.currentState != null && _formKey.currentState!.validate()){
      final email = _emailController.text;

      try{
        setState(() {
          _isLoading = true;
        });

        PasswordRecoveryResponse response = await widget.authBloc.passwordRecovery(email);
        final message = response.message;
        final AuthBloc authBloc = AuthBloc();

        if(response.statusCode == 200){
          _navigateToPasswordChange(authBloc, email);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$message'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
          ),
          );
        }
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error intente nuevamente'),
              duration: Duration(seconds: 4),
              backgroundColor: Colors.red,)
        );

      }finally{
        setState(() {
          _isLoading = false;
        });

      }

    }

  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _validateForm,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        child: _isLoading ? CircularProgressIndicator() : Text(
          'Enviar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  //Construye un boton utilizado para la recuperación de contraseña
  Widget _buildLoginPageButton() {
    return TextButton(
      onPressed: () {
        final AuthBloc authBloc = AuthBloc();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginPage(authBloc: authBloc),
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
      child: Text(
        "Acceder cuenta",
        style: TextStyle(
          color: Color(0xFF938CDF),
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
        ),
      ),
    );
  }

  // Define un método para construir la ruta de navegación
  void _navigateToPasswordChange(AuthBloc authBloc, String email) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PasswordChange(authBloc: authBloc, email: email),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 10), // Ajusta la duración de la transición según sea necesario
      ),
    );
  }

}