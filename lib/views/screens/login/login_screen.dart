import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep_makanan/views/home_page.dart';
import 'package:resep_makanan/utils/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../register/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences logindata;
  late bool newUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    logindata = await SharedPreferences.getInstance();
    newUser = logindata.getBool('daftar') ?? true;

    if (newUser == false) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0.1, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ResepKu',
                      style: blackFontStyle1,
                    ),
                    Text(
                      "Login dan mulai menulis resep!",
                      style: greyFontStyle.copyWith(
                          fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                    defaultMargin, 16, defaultMargin, 6),
                child: Text(
                  "Alamat E-mail",
                  style: blackFontStyle2,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: greyFontStyle,
                      hintText: 'Masukkan alamat e-mail'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                    defaultMargin, 16, defaultMargin, 6),
                child: Text(
                  "Kata Sandi",
                  style: blackFontStyle2,
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: greyFontStyle,
                      hintText: 'Buat kata sandi'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24),
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
                child: ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    logindata.setBool('daftar', false);
                    logindata.setString('email', email);
                    // saveImageToSharedPreferences(image!);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: mainColor,
                  ),
                  child: Text(
                    'Masuk',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                    defaultMargin, 16, defaultMargin, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum mempunyai akun?",
                      style: blackFontStyle2,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Text(
                        " Daftar",
                        style: blackFontStyle2.copyWith(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
