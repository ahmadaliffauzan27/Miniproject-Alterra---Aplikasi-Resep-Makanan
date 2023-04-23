import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/style/theme.dart';

import '../model/resep_model.dart';
import '../view_model/db_manager.dart';

class EditResepDialog extends StatefulWidget {
  final Resep resep;

  EditResepDialog({required this.resep});

  @override
  _EditResepDialogState createState() => _EditResepDialogState();
}

class _EditResepDialogState extends State<EditResepDialog> {
  String name = '';
  String ingredients = '';
  String step = '';
  File? picture;
  List<int> _imageBytes = [];

  late TextEditingController nameController;
  late TextEditingController ingredientsController;
  late TextEditingController stepsController;
  File? _image;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.resep.name);
    ingredientsController =
        TextEditingController(text: widget.resep.ingredients);
    stepsController = TextEditingController(text: widget.resep.step);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select file'),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dbManager = Provider.of<DbManager>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          toolbarHeight: 100,
          iconTheme: IconThemeData(
            color: Colors.black, // Ubah warna ikon menjadi hitam
          ),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                // color: Colors.white,
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
                          "Silahkan edit resepmu!",
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
        body: SingleChildScrollView(
          child: Consumer<DbManager>(builder: (context, dbManager, child) {
            final resep = dbManager.reseps;

            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    getFile();
                    setState(() {});
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
                    onChanged: (value) {
                      name = value;
                    },
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
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black)),
                  child: TextFormField(
                    onChanged: (value) {
                      ingredients = value;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: ingredientsController,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(
                      defaultMargin, 16, defaultMargin, 6),
                  child: Text(
                    "Cara Memasak",
                    style: blackFontStyle2,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black)),
                  child: TextFormField(
                    onChanged: (value) {
                      step = value;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: stepsController,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    widget.resep.name = name;
                    widget.resep.ingredients = ingredients;
                    widget.resep.step = step;
                    if (_image != null) {
                      widget.resep.picture = Uint8List.fromList(_imageBytes);
                    }
                    Provider.of<DbManager>(context, listen: false)
                        .updateResep(widget.resep.id!, widget.resep);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Resep Berhasil Diedit'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text('Simpan Perubahan'),
                  style: ElevatedButton.styleFrom(
                      primary: mainColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 12),
                      textStyle: subtitleFont.copyWith(fontSize: 16)),
                ),
              ],
            );
          }),
        ));
  }
}
