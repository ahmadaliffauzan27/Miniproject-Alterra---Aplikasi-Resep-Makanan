import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/model/resep_model.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/style/theme.dart';
import '../view_model/db_manager.dart';

class EditResep extends StatefulWidget {
  final Resep? resep;
  const EditResep({super.key, this.resep});

  @override
  State<EditResep> createState() => _EditResepState();
}

class _EditResepState extends State<EditResep> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController inggridientsController = TextEditingController();
  TextEditingController stepController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isUpdate = false;
  List<int> _imageBytes = [];
  File? _image;

  @override
  void dispose() {
    inggridientsController.dispose();
    stepController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _editResep() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resep Berhasil Diedit!'),
          backgroundColor: Colors.green,
        ),
      );

      final id = widget.resep?.id;
      if (id != null) {
        final resepToEdit = Resep(
          id: id,
          name: nameController.text,
          ingredients: inggridientsController.text,
          step: stepController.text,
          picture: Uint8List.fromList(_imageBytes),
        );
        Provider.of<DbManager>(context, listen: false)
            .updateResep(id, resepToEdit);
      }

      nameController.clear();
      inggridientsController.clear();
      stepController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print('File name: $file');

      setState(() {
        _image = file;
        _imageBytes = file.readAsBytesSync();
      });
    } else {
      // User canceled the picker
      // You can show snackbar or fluttertoast
      // here like this to show warning to user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select file'),
      ));
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
                        "Edit resep terbaikmu!",
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
                  onTap: () async {
                    getFile();
                  },
                  child: Container(
                    width: 110,
                    height: 110,
                    margin: const EdgeInsets.only(top: 26),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/photo_border.png'))),
                    child: (_image != null)
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(_image!),
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
                  constraints: const BoxConstraints(
                      maxWidth:
                          500), // membuat lebar maksimal container menjadi 500
                  margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: greyFontStyle,
                        hintText: 'Masukkan tahapan cara pembuatan'),
                    controller: stepController,
                    style: const TextStyle(fontSize: 16.0),
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
                      _editResep();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: mainColor,
                    ),
                    child: Text(
                      'Edit',
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
