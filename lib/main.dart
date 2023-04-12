import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/register_page.dart';
import 'package:resep_makanan/view_model/db_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DbManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
