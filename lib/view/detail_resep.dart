import 'package:flutter/material.dart';
import 'package:resep_makanan/view/home_page.dart';
import 'package:resep_makanan/view/style/theme.dart';

import '../model/resep_model.dart';

class DetailResep extends StatelessWidget {
  final Resep resep;
  DetailResep({required this.resep});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: mainColor,
          ),
          SafeArea(
              child: Container(
            color: Colors.white,
          )),
          SafeArea(
            child: Container(
              height: 300,
              width: double.infinity,
              child: Image.memory(
                resep.picture!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: ListView(),
          ),
          //Back button
          SafeArea(
            child: Column(
              children: [
                //// Back Button
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black12),
                            child: Image.asset('assets/back_arrow_white.png'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black12),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Body
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 180),
                        padding: const EdgeInsets.symmetric(
                            vertical: 26, horizontal: 16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                resep.name,
                                style: blackFontStyle2,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Bahan-bahan:',
                              style: blackFontStyle3,
                            ),
                            SizedBox(
                              child: Text(
                                resep.ingredients,
                                style: greyFontStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Cara memasak:',
                              style: blackFontStyle3,
                            ),
                            SizedBox(
                              child: Text(
                                resep.step,
                                style: greyFontStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
