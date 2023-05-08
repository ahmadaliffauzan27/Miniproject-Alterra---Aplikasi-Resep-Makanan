import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resep_makanan/views/screens/register/register_screen.dart';

void main() {
  group('RegisterPage Widget Test', () {
    // Create a test widget
    testWidgets('Test if RegisterPage widget is rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    // Test the text fields
    testWidgets('Test if forms are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Nama Lengkap'), findsOneWidget);
      expect(find.text('Alamat E-mail'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
    });

    // Test the button
    testWidgets('Test if Register button is rendered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterPage()));
      expect(find.text('Daftar'), findsOneWidget);
    });
  });
}
