import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/detail_resep.dart';
import 'package:resep_makanan/view/edit_resep.dart';
import 'package:resep_makanan/view/style/theme.dart';
import 'package:resep_makanan/view/tambah_resep.dart';

import '../model/resep_model.dart';
import '../view_model/db_manager.dart';

class ResepHome extends StatefulWidget {
  const ResepHome({super.key});

  @override
  State<ResepHome> createState() => _ResepHomeState();
}

class _ResepHomeState extends State<ResepHome> {
  String name = '';
  String ingredients = '';
  String step = '';
  File? picture;
  List<int> _imageBytes = [];
  File? _image;

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

  void _showEditDialog(Resep resep) async {
    TextEditingController nameController =
        TextEditingController(text: resep.name);
    TextEditingController ingredientsController =
        TextEditingController(text: resep.ingredients);
    TextEditingController stepsController =
        TextEditingController(text: resep.step);

    await showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: mainColor)),
          title: Text('Edit Resep'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: TextFormField(
                  onChanged: (value) {
                    ingredients = value;
                  },
                  controller: ingredientsController,
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
                  onChanged: (value) {
                    step = value;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: greyFontStyle,
                      hintText: 'Masukkan tahapan cara pembuatan'),
                  controller: stepsController,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: TextStyle(color: mainColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: mainColor),
              onPressed: () {
                final updatedResep = Resep(
                  id: resep.id,
                  name: name,
                  ingredients: ingredients,
                  step: step,
                  picture: Uint8List.fromList(_imageBytes),
                );

                Provider.of<DbManager>(context, listen: false)
                    .updateResep(resep.id!, updatedResep);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Resep Berhasil Diedit'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/photo2.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Consumer<DbManager>(builder: (context, manager, child) {
                  final reseptModel = manager.reseps;

                  if (manager.reseps.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Jumlah kolom dalam grid
                            crossAxisSpacing: 8, // Jarak antar kolom
                            mainAxisSpacing: 8, // Jarak antar baris
                            childAspectRatio:
                                1, // Rasio lebar terhadap tinggi tiap item dalam grid
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: reseptModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            final resepFinal = manager.reseps[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailResep(resep: resepFinal),
                                  ),
                                );
                              },
                              child: Card(
                                child: Stack(
                                  children: [
                                    ListTile(
                                      title: Image.memory(
                                        resepFinal.picture!,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          resepFinal.name,
                                          style: blackFontStyle2.copyWith(
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 16,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: mainColor,
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            _showEditDialog(resepFinal);
                                          },
                                          icon: const Icon(Icons.edit),
                                          iconSize:
                                              15, // sesuaikan ukuran ikon dengan ukuran container
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 36,
                                      right: 16,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: mainColor,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: mainColor)),
                                                  title:
                                                      const Text('Konfirmasi'),
                                                  content: const Text(
                                                      'Bunda yakin ingin menghapus resep ini?'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  mainColor),
                                                      child:
                                                          const Text('Tidak'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  mainColor),
                                                      child: const Text('Ya'),
                                                      onPressed: () {
                                                        final resepToDelete = Resep(
                                                            id: resepFinal.id,
                                                            name:
                                                                resepFinal.name,
                                                            ingredients:
                                                                resepFinal
                                                                    .ingredients,
                                                            step:
                                                                resepFinal.step,
                                                            picture: resepFinal
                                                                .picture);
                                                        Provider.of<DbManager>(
                                                                context,
                                                                listen: false)
                                                            .deleteResep(
                                                          resepFinal.id!,
                                                        );

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Resep Berhasil Dihapus!'),
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                        // log(index.toString());
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.delete),
                                          iconSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 300,
                        ),
                        Center(
                            child: Text(
                          'Belum ada resep yang bunda tulis :(',
                          style: blackFontStyle3,
                        )),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahResep(),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
