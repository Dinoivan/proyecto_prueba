import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';

void main() {
  testWidgets('Main screen smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(authBloc: authBloc),
      ),
    );

    // Wait for the redirection to happen (assuming it takes around 3 seconds based on redirectToLastScreen).
    await tester.pump(const Duration(seconds: 3));

    // Verify that the main screen is displayed.
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget); // Verify that Home screen is displayed

    // Verify that the redirection happens by checking the appearance of some widget from the redirected screen.
    expect(find.byType(CircularProgressIndicator), findsNothing); // Verify that CircularProgressIndicator is not displayed anymore

    // Trigger the logout action (simulated)
    authBloc.resetToken();

    // Wait for the redirection to happen again (assuming it takes around 3 seconds based on redirectToLastScreen).
    await tester.pump(const Duration(seconds: 3));

    // Verify that the login screen is displayed after logout.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}