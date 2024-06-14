import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';

void main() {

  final AuthBloc authBloc = AuthBloc();

  group('LoginPage widget', () {
    testWidgets('validate email and password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage(authBloc: authBloc,)));

      // Simular entrada de datos en los campos de correo electrónico y contraseña
      await tester.enterText(find.byKey(Key('email_field')), 'flor_1120@hotmail.com');
      await tester.enterText(find.byKey(Key('password_field')), 'Flordino1994&');

      // Enviar el formulario
      await tester.tap(find.byKey(Key('login_button'))); // Utiliza la clave o encuentra el botón de inicio de sesión de manera más precisa
      await tester.pump();


      // Verificar que no haya errores
      expect(find.text('Error al iniciar sesión'), findsNothing);
    });

  });
}