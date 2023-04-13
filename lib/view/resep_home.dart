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
                            return Card(
                              child: ListTile(
                                title: Text(resepFinal.name),
                                subtitle: Text(resepFinal.ingredients),
                              ),
                            );
                          }),
                    );
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
