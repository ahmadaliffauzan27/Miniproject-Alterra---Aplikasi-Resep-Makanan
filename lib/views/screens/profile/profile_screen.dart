import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resep_makanan/views/screens/favourite_recipe/favourite_recipe_screen.dart';
import 'package:resep_makanan/views/screens/register/register_screen.dart';
import 'package:resep_makanan/utils/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences logindata;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username').toString();
      email = logindata.getString('email').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              //// Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                height: 300,
                margin: EdgeInsets.only(bottom: defaultMargin),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      margin: const EdgeInsets.only(top: 26),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/photo_border.png'))),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/photo_profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      username,
                      style: titleFont,
                    ),
                    Text(
                      email,
                      style: subtitleFont,
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                margin: EdgeInsets.only(bottom: defaultMargin),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouriteRecipes()));
                      },
                      child: Container(
                        height: 55,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Resep Tersimpan',
                                style: subtitleFont,
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        logindata.setBool('daftar', true);
                        logindata.remove('username');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Container(
                        height: 55,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Keluar',
                                style: subtitleFont,
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ),
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
