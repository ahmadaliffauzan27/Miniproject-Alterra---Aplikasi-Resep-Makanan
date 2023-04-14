import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/register_page.dart';
import 'package:resep_makanan/view/splash_screen.dart';
import 'package:resep_makanan/view_model/db_manager.dart';
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
      create: (context) => DbManager(),
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
