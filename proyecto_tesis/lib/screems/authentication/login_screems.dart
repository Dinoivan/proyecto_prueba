import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:proyecto_tesis/screems/register/register.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/password_recovery_screem.dart';

class LoginPage extends StatefulWidget {

  final AuthBloc authBloc;

  LoginPage({required this.authBloc});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
          minHeight: screenHeight,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
      margin: EdgeInsets.only(left: 33.0,top: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        'Iniciar sesión',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            _buildEmailFormField(),
            SizedBox(height: 18),
            _buildPasswordFormField(),
            SizedBox(height: 2,),
            _buildPasswordRecoveryButton(),
            SizedBox(height: 44,),
            _buildSubmitButton(),
            SizedBox(height: 10.0,),
            _buildRegisterButton(),
            // Campos del formulario...
          ],
        ),
      ),
    );
  }

  Widget _buildEmailFormField() {
    return TextFormField(
      key: Key('email_field'),
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
        labelText: _emailController.text.isEmpty ? "Correo@mail.com": "",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText:  _emailController.text.isEmpty ? "": "Correo@mail.com",
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

  Widget _buildPasswordFormField() {
    return PasswordFormField(passwordControler: _passwordController);
  }

  //Construye un boton utilizado para la recuperación de contraseña
  Widget _buildPasswordRecoveryButton() {
    return TextButton(
      onPressed: () {
        final AuthBloc authBloc = AuthBloc();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PasswordRecovery(authBloc: authBloc),
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
        "¿Olvidaste tu contraseña?",
        style: TextStyle(
          color: Color(0xFF938CDF),
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w500,
          fontSize: 14.7,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        key: Key('login_button'),
        onPressed: _isLoading ? null : _submitForm,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        child: _isLoading ? CircularProgressIndicator() : Text(
          'Ingresar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: '¿Aún no tienes una cuenta? ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Crear cuenta',
                  recognizer: TapGestureRecognizer()
                    ..onTap = _navigateToRegistration,
                  style: TextStyle(
                    color: Color(0xFF938CDF),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {

      final email = _emailController.text;
      final password = _passwordController.text;

      try {

        setState(() {
          _isLoading = true;
        });

        int? resultado = await widget.authBloc.login(email, password);

        print("Resultado: $resultado");

        if (resultado == 200) {
          _navigateToHome();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Su inicio de sesión fue exitoso'),
              duration: Duration(seconds: 4),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al iniciar sesión verifica sus credenciales o correo electrónico'),
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegistration() {
    final RegisterBloc registerBloc = RegisterBloc();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Register(registerBloc: registerBloc,),
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

  void _navigateToHome() {
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
        transitionDuration: Duration(milliseconds: 10),
      ),
    );
  }

}

class PasswordFormField extends StatefulWidget {
  final TextEditingController passwordControler;
  PasswordFormField({required this.passwordControler});

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('password_field'),
      controller: widget.passwordControler,
      obscureText: _obscureText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15.0,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
        ),
        labelText: widget.passwordControler.text.isEmpty ? "Contraseña": "",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText:  widget.passwordControler.text.isEmpty ? "" : "**********",
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese contraseña';
        }

        if(value.length>20){
          return 'La contraseña debe contener como maximo 20 caracteres';
        }

        return null;
      },
    );
  }

}