import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/utils/const/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/resep_model.dart';
import '../../../utils/const/animation.dart';
import '../../../view_model/recipe_provider.dart';
import '../add_recipe/add_recipe_screen.dart';
import '../detail_recipe/detail_recipe_screen.dart';
import '../edit_recipe/edit_recipe_screen.dart';
import '../favourite_recipe/favourite_recipe_screen.dart';

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
    final provider = Provider.of<RecipeManager>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 60, right: 16, bottom: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/photo_profile.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FavouriteRecipes(),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.bookmark_added,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Positioned(
                                  top: -2,
                                  right: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Consumer<RecipeManager>(
                                      builder: (context, provider, child) {
                                        return Text(
                                          provider.favoriteManager
                                              .favoriteRecipes.length
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Card(
                        shadowColor: mainColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            provider.searchData(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            suffixIcon: AnimatedSearchIcon(),
                            hintText: 'Cari ResepKu...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Resepku',
                    style: subtitleFont,
                  ),
                  const Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
            Consumer<RecipeManager>(
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
                      physics: const NeverScrollableScrollPhysics(),
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
                            child: Stack(children: [
                              // Gambar dan Nama Resep
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        image: DecorationImage(
                                          image:
                                              MemoryImage(resepFinal.picture!),
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
                                      style:
                                          subtitleFont.copyWith(fontSize: 11),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 8, bottom: 8, top: 8),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mainColor,
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              if (manager.favoriteManager
                                                  .favoriteRecipes
                                                  .contains(resepFinal)) {
                                                manager
                                                    .removeFavorite(resepFinal);
                                              } else {
                                                manager.addFavorite(resepFinal);
                                              }
                                            },
                                            icon: Icon(
                                              Icons.bookmark_add,
                                              size: 15,
                                              color: manager.favoriteManager
                                                      .favoriteRecipes
                                                      .contains(resepFinal)
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
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    mainColor),
                                                        child:
                                                            const Text('Tidak'),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    mainColor),
                                                        child: const Text('Ya'),
                                                        onPressed: () {
                                                          final resepToDelete = Resep(
                                                              id: resepFinal.id,
                                                              name: resepFinal
                                                                  .name,
                                                              ingredients:
                                                                  resepFinal
                                                                      .ingredients,
                                                              step: resepFinal
                                                                  .step,
                                                              picture:
                                                                  resepFinal
                                                                      .picture);
                                                          Provider.of<RecipeManager>(
                                                                  context,
                                                                  listen: false)
                                                              .deleteResep(
                                                            resepFinal.id!,
                                                          );
                                                          // Provider.of<DbManager>(
                                                          //         context,
                                                          //         listen: false)
                                                          //     .removeFavorite(
                                                          //         resepFinal);
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
                    padding: const EdgeInsets.only(top: 250),
                    child: Center(
                      child: Text(
                        'Belum ada resep yang ditulis.',
                        style: subtitleFont.copyWith(
                            fontSize: 12, color: greyColor),
                      ),
                    ),
                  );
                }
              },
            ),
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
