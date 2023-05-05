import 'dart:async';

import 'package:flutter/material.dart';
import 'package:resep_makanan/views/home_page.dart';
import 'package:resep_makanan/views/screens/register/register_screen.dart';
import 'package:resep_makanan/utils/const/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => const RegisterPage()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splash.png',
                width: 163,
                height: 140,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
