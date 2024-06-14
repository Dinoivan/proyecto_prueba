import 'package:flutter/material.dart';
import 'package:proyecto_tesis/models/autentication/password_change_model.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';

class PasswordChange extends StatefulWidget {

  final AuthBloc authBloc;
  String email;

  PasswordChange({required this.authBloc,required this.email});

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false;

  String? _nuevoError;


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
      margin: EdgeInsets.only(left: 40.0,top: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        'Cambiar contraseña',
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
            _buildCodigoFormField(),
            const SizedBox(height: 20),
            _buildNewPasswordFormField(),
            const SizedBox(height: 40.0),
            _buildSubmitButton(),
            SizedBox(height: 20.0,),
            _buildLoginPageButton(),
            // Campos del formulario...
          ],
        ),
      ),
    );
  }

  Widget _buildCodigoFormField() {
    return  TextFormField(
      controller: _codigoController,
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
        labelText: _codigoController.text.isEmpty ? "Código": "",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText:  _codigoController.text.isEmpty ? "": "657890",
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese codigo de verificación';
        }
        final RegExp numericRegex = RegExp(r'^[0-9]+$');
        if (!numericRegex.hasMatch(value)) {
          return 'Ingrese sólo números';
        }
        if(value.length != 6){
          return 'El código debe tener exactamente 6 números';
        }

        return null;
      },
    );
  }


  Widget _buildNewPasswordFormField() {
    return  TextFormField(
      controller: _passwordController,
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
        labelText: _passwordController.text.isEmpty ? "Contraseña": "",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText: _passwordController.text.isEmpty ? "": "..........",
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
      ),
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese su nueva contraseña';
        }
        final RegExp specialCharacterRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>_-]');
        final RegExp uppercaseLetterRegex = RegExp(r'[A-Z]');
        final RegExp lowercaseLetterRegex = RegExp(r'[a-z]');
        final RegExp numberRegex = RegExp(r'[0-9]');

        if(value.length < 8){
          return 'La contraseña debe contener al menos 8 caracteres';
        }
        if (!specialCharacterRegex.hasMatch(value)) {
          return 'La contraseña debe contener al menos un caracter especial';
        }
        if(!uppercaseLetterRegex.hasMatch(value)){
          return 'La contraseña debe contener al menos una letra en mayúscula';
        }
        if(!lowercaseLetterRegex.hasMatch(value)){
          return 'La contraseña debe contener al menos una letra en minuscula';
        }
        if(!numberRegex.hasMatch(value)){
          return 'La contraseña debe contener al menos un número';
        }
        return null;
      },
    );
  }

  void _validateForm() async {
    if(_formKey.currentState != null && _formKey.currentState!.validate()){
      final token = int.parse(_codigoController.text);
      final nuevo = _passwordController.text;

      try{
        setState(() {
          _isLoading = true;
        });

        PasswordChangeResponse response = await widget.authBloc.passwordChange(widget.email,nuevo,token);

        final AuthBloc authBloc = AuthBloc();

        if(response.statusCode == 200){
          _navigateToLoginPange(authBloc);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Se cambio correctamente la contraseña'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
          ),
          );
        }
      }catch(e){
        print("Error al cambiar la contraseña: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      height: 55,
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
          'Cambiar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

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

  void _navigateToLoginPange(AuthBloc authBloc) {
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
        transitionDuration: Duration(milliseconds: 10), // Ajusta la duración de la transición según sea necesario
      ),
    );
  }

}