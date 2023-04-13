import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/model/resep_model.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/db_manager.dart';

class TambahResep extends StatefulWidget {
  final Resep? resep;
  const TambahResep({super.key, this.resep});

  @override
  State<TambahResep> createState() => _TambahResepState();
}

class _TambahResepState extends State<TambahResep> {
  late SharedPreferences logindata;
  int idRandom = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController inggridientsController = TextEditingController();
  TextEditingController stepController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isUpdate = false;

  void generateId() {
    idRandom++;
  }

  @override
  void dispose() {
    inggridientsController.dispose();
    stepController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    generateId();
  }

  void _saveResep() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resep Berhasil Ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      final resepToAdd = Resep(
        id: widget.resep?.id,
        name: nameController.text,
        ingredients: inggridientsController.text,
        step: stepController.text,
      );
      Provider.of<DbManager>(context, listen: false).addResep(resepToAdd);

      nameController.clear();
      inggridientsController.clear();
      stepController.clear();

      generateId();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Nama resep tidak boleh kosong";
    } else {
      return null;
    }
  }

  String? validateIngredients(String? ingredients) {
    if (ingredients == null || ingredients.isEmpty) {
      return "Bahan-bahan tidak boleh kosong";
    } else {
      return null;
    }
  }

  String? validateStep(String? step) {
    if (step == null || step.isEmpty) {
      return "Cara membuat tidak boleh kosong";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var pictureFile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        iconTheme: IconThemeData(
          color: Colors.black, // Ubah warna ikon menjadi hitam
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              color: Colors.white,
              height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'ResepKu',
                        style: blackFontStyle1,
                      ),
                      Text(
                        "Ayo tulis resep terbaikmu!",
                        style: greyFontStyle.copyWith(
                            fontWeight: FontWeight.w300, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
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
                    "Nama Resep",
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
                  child: TextFormField(
                    validator: validateName,
                    controller: nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: greyFontStyle,
                        hintText: 'Masukkan nama resep'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                      defaultMargin, 16, defaultMargin, 6),
                  child: Text(
                    "Bahan-bahan",
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
                  child: TextFormField(
                    validator: validateIngredients,
                    controller: inggridientsController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: greyFontStyle,
                        hintText: 'Masukkan bahan-bahan'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                      defaultMargin, 16, defaultMargin, 6),
                  child: Text(
                    "Cara pembuatan",
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
                  child: TextFormField(
                    validator: validateStep,
                    controller: stepController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: greyFontStyle,
                        hintText: 'Masukkan tahapan cara pembuatan'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24),
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: ElevatedButton(
                    onPressed: () {
                      _saveResep();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: mainColor,
                    ),
                    child: Text(
                      'Buat',
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
