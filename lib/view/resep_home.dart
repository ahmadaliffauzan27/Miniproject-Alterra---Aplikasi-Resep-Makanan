import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/detail_resep.dart';
import 'package:resep_makanan/view/edit_resep.dart';
import 'package:resep_makanan/view/search_widget.dart';
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
          title: Text(
            'Edit Resep',
            style: blackFontStyle1,
          ),
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
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
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
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: mainColor,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SearchWidget(),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Hallo Ahmad Alif Fauzan!',
                            style: blackFontStyle2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 200,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                          ),
                          items: [
                            'assets/banner1.jpg',
                            'assets/banner2.jpg',
                            'assets/banner3.jpg',
                          ].map((item) {
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(item),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 26, horizontal: 16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Daftar ResepKu',
                                  style: blackFontStyle2,
                                ),
                              ),
                            ),
                            Center(
                              child: Consumer<DbManager>(
                                builder: (context, manager, child) {
                                  final reseptModel = manager.reseps;
                                  if (manager.reseps.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 1,
                                        ),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: reseptModel.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final resepFinal =
                                              manager.reseps[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailResep(
                                                          resep: resepFinal),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              child: Stack(children: [
                                                // Gambar dan Nama Resep
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    8.0),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: MemoryImage(
                                                                resepFinal
                                                                    .picture!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8,
                                                              left: 8,
                                                              top: 8),
                                                      color: Colors.white,
                                                      child: Text(
                                                        resepFinal.name,
                                                        style: blackFontStyle2
                                                            .copyWith(
                                                                fontSize: 12),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8,
                                                              bottom: 8,
                                                              top: 8),
                                                      color: Colors.white,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: mainColor,
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                // manager.toggleFavorite(resepFinal);
                                                              },
                                                              icon: const Icon(
                                                                Icons.favorite,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: mainColor,
                                                            ),
                                                            child: IconButton(
                                                              onPressed:
                                                                  () async {
                                                                _showEditDialog(
                                                                    resepFinal);
                                                              },
                                                              icon: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              iconSize:
                                                                  15, // sesuaikan ukuran ikon dengan ukuran container
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: mainColor,
                                                            ),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          side:
                                                                              BorderSide(color: mainColor)),
                                                                      title: const Text(
                                                                          'Konfirmasi'),
                                                                      content:
                                                                          const Text(
                                                                              'Bunda yakin ingin menghapus resep ini?'),
                                                                      actions: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(backgroundColor: mainColor),
                                                                          child:
                                                                              const Text('Tidak'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(backgroundColor: mainColor),
                                                                          child:
                                                                              const Text('Ya'),
                                                                          onPressed:
                                                                              () {
                                                                            final resepToDelete = Resep(
                                                                                id: resepFinal.id,
                                                                                name: resepFinal.name,
                                                                                ingredients: resepFinal.ingredients,
                                                                                step: resepFinal.step,
                                                                                picture: resepFinal.picture);
                                                                            Provider.of<DbManager>(context, listen: false).deleteResep(
                                                                              resepFinal.id!,
                                                                            );

                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              const SnackBar(
                                                                                content: Text('Resep Berhasil Dihapus!'),
                                                                                backgroundColor: Colors.green,
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
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              iconSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                // Icon Favorite

                                                // Icon Edit
                                              ]),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 300),
                                        Center(
                                          child: Text(
                                            'Belum ada resep yang bunda tulis :(',
                                            style: blackFontStyle3,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
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
      ),
    );
  }
}
