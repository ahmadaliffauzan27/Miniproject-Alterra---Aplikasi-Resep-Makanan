import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resep_makanan/views/screens/login/login_screen.dart';
import 'package:resep_makanan/views/screens/register/register_screen.dart';

void main() {
  group('LoginPage Widget Test', () {
    // Create a test widget
    testWidgets('Test if LoginPage widget is rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      expect(find.byType(LoginPage), findsOneWidget);
    });

    // Test the text fields
    testWidgets('Test if email and password text fields are rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Alamat E-mail'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
    });

    // Test the button
    testWidgets('Test if login button is rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));
      expect(find.text('Masuk'), findsOneWidget);
    });

    // Test navigation to RegisterPage
  });
}
