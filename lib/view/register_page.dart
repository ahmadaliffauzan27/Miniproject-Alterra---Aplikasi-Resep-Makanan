import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late SharedPreferences logindata;
  late bool newUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
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
    var pictureFile;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar',
          style: titleFont,
        ),
        backgroundColor: mainColor,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () async {},
                child: Container(
                  width: 110,
                  height: 110,
                  margin: const EdgeInsets.only(top: 26),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/photo_border.png'))),
                  child: (pictureFile != null)
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: FileImage(pictureFile),
                                  fit: BoxFit.cover)),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/photo.png'),
                                  fit: BoxFit.cover)),
                        ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                    defaultMargin, 16, defaultMargin, 6),
                child: Text(
                  "Nama Lengkap",
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
                  controller: nameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: greyFontStyle,
                      hintText: 'Masukkan nama lengkap'),
                ),
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
                    String username = nameController.text;
                    String email = emailController.text;
                    logindata.setBool('daftar', false);
                    logindata.setString('username', username);
                    logindata.setString('email', email);
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
                    'Daftar',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
