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
import 'package:shared_preferences/shared_preferences.dart';

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

  late SharedPreferences logindata;
  String username = '';
  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/photo3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang',
                          style: subtitleFont.copyWith(fontSize: 11),
                        ),
                        Text(
                          'Chef $username',
                          style: subtitleFont.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SearchWidget(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
        toolbarHeight: 120,
        backgroundColor: Colors.white,
      ),
      backgroundColor: mainColor,
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: Container(
                //     height: MediaQuery.of(context).size.height / 3.7,
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //       color: mainColor,
                //     ),
                //     child: Center(
                //       child: SizedBox(
                //         height: 200,
                //         child: CarouselSlider(
                //           options: CarouselOptions(
                //             autoPlay: true,
                //             enlargeCenterPage: true,
                //             aspectRatio: 16 / 9,
                //             viewportFraction: 0.7,
                //           ),
                //           items: [
                //             'assets/banner1.jpg',
                //             'assets/banner2.jpg',
                //             'assets/banner3.jpg',
                //           ].map((item) {
                //             return Container(
                //               margin: const EdgeInsets.all(5.0),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(10),
                //                 image: DecorationImage(
                //                   image: AssetImage(item),
                //                   fit: BoxFit.cover,
                //                 ),
                //               ),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding:
                      const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(20),
                    //     topRight: Radius.circular(20)),
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
                            style: blackFontStyle2.copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      Expanded(
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
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reseptModel.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                        child: Stack(children: [
                                          // Gambar dan Nama Resep
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8.0),
                                                      topRight:
                                                          Radius.circular(8.0),
                                                    ),
                                                    image: DecorationImage(
                                                      image: MemoryImage(
                                                          resepFinal.picture!),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8, left: 8, top: 8),
                                                color: Colors.white,
                                                child: Text(
                                                  resepFinal.name,
                                                  style: subtitleFont.copyWith(
                                                      fontSize: 11),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8,
                                                    bottom: 8,
                                                    top: 8),
                                                color: Colors.white,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container()),
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: mainColor,
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          manager.addFavorite(
                                                              resepFinal);
                                                        },
                                                        icon: Icon(
                                                          Icons.favorite,
                                                          size: 15,
                                                          color: manager
                                                                  .favoriteRecipes
                                                                  .contains(
                                                                      resepFinal)
                                                              ? Colors.red
                                                              : Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: mainColor,
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () async {
                                                          // _showEditDialog(
                                                          //     resepFinal);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: ((context) =>
                                                                      EditResepDialog(
                                                                          resep:
                                                                              resepFinal))));
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                        iconSize:
                                                            15, // sesuaikan ukuran ikon dengan ukuran container
                                                      ),
                                                    ),
                                                    Container(
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
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    side: BorderSide(
                                                                        color:
                                                                            mainColor)),
                                                                title: const Text(
                                                                    'Konfirmasi'),
                                                                content: const Text(
                                                                    'Bunda yakin ingin menghapus resep ini?'),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            mainColor),
                                                                    child: const Text(
                                                                        'Tidak'),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            mainColor),
                                                                    child:
                                                                        const Text(
                                                                            'Ya'),
                                                                    onPressed:
                                                                        () {
                                                                      final resepToDelete = Resep(
                                                                          id: resepFinal
                                                                              .id,
                                                                          name: resepFinal
                                                                              .name,
                                                                          ingredients: resepFinal
                                                                              .ingredients,
                                                                          step: resepFinal
                                                                              .step,
                                                                          picture:
                                                                              resepFinal.picture);
                                                                      Provider.of<DbManager>(
                                                                              context,
                                                                              listen: false)
                                                                          .deleteResep(
                                                                        resepFinal
                                                                            .id!,
                                                                      );

                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Resep Berhasil Dihapus!'),
                                                                          backgroundColor:
                                                                              Colors.green,
                                                                        ),
                                                                      );
                                                                      Navigator.pop(
                                                                          context);
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
                                                          color: Colors.white,
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
                              return Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Text(
                                  'Belum ada resep yang ditulis.',
                                  style: subtitleFont.copyWith(
                                      fontSize: 12, color: greyColor),
                                ),
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
          ],
        ),
      ),
    );
  }
}
