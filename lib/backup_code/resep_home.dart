import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                    SizedBox(
                      height: 50,
                      child: Image.asset('assets/photo.png'),
                    ),
                  ],
                ),
              ),
              Center(
                child: Consumer<DbManager>(builder: (context, manager, child) {
                  final reseptModel = manager.reseps;

                  if (manager.reseps.isNotEmpty) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: reseptModel.length,
                        // itemCount: manager.contacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final resepFinal = manager.reseps[index];
                          final color = mainColor;
                          // final item = manager.contacts;
                          return ListTile(
                            title: Text(resepFinal.name),
                            subtitle: Text(resepFinal.ingredients),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: mainColor,
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: mainColor)),
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda ingin mengedit kontak ini?'),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor),
                                                child: const Text('Tidak'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor),
                                                child: const Text('Ya'),
                                                onPressed: () {
                                                  // Navigator.pop(context);
                                                  // _showEditDialog(contact);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }),
                                IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: mainColor,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: mainColor)),
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin menghapus kontak ini?'),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor),
                                                child: const Text('Tidak'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: mainColor),
                                                child: const Text('Ya'),
                                                onPressed: () {
                                                  final resepToDelete = Resep(
                                                      id: resepFinal.id,
                                                      name: resepFinal.name,
                                                      ingredients: resepFinal
                                                          .ingredients,
                                                      step: '');
                                                  Provider.of<DbManager>(
                                                          context,
                                                          listen: false)
                                                      .deleteResep(
                                                          resepFinal.id!,
                                                          resepToDelete);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Kontak Berhasil Dihapus!'),
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
                                    })
                              ],
                            ),
                          );
                        });
                  } else {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 300,
                        ),
                        Center(
                            child: Text('Belum ada resep yang kamu tulis :(')),
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
