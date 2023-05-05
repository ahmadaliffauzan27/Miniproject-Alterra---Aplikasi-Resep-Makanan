import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/views/home_page.dart';
import 'package:resep_makanan/views/register/register_screen.dart';
import 'package:resep_makanan/views/splash/splash_screen.dart';
import 'package:resep_makanan/view_model/recipe_provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // menambahkan kode berikut untuk mengunci orientasi tampilan
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ChangeNotifierProvider(
      create: (context) => RecipeManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashScreen(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
