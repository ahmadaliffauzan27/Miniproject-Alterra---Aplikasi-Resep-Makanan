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
                      padding: const EdgeInsets.all(16.0),
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
                            final color = mainColor;
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
                                        resepFinal.picture,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(resepFinal.name),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 10,
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: mainColor,
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
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
                                                      'Bunda yakin ingin mengedit resep ini?'),
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
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        EditResep()));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                          iconSize:
                                              15, // sesuaikan ukuran ikon dengan ukuran container
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 32,
                                      right: 10,
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
