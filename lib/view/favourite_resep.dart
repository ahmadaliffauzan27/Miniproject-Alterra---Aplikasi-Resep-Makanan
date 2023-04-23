import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resep_makanan/view/style/theme.dart';
import 'package:resep_makanan/view_model/db_manager.dart';

import 'detail_resep.dart';

class FavouriteRecipes extends StatefulWidget {
  const FavouriteRecipes({super.key});

  @override
  State<FavouriteRecipes> createState() => _FavouriteRecipesState();
}

class _FavouriteRecipesState extends State<FavouriteRecipes> {
  @override
  Widget build(BuildContext context) {
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
                        "Resep Favoritmu",
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Consumer<DbManager>(
          builder: (context, provider, child) {
            if (provider.favoriteRecipes.isEmpty) {
              return Center(
                child: Text('You have no favorite recipes yet.'),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: provider.favoriteRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  final resep = provider.favoriteRecipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailResep(resep: resep),
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                  image: MemoryImage(resep.picture!),
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
                              resep.name,
                              style: subtitleFont.copyWith(fontSize: 11),
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
                                      provider.removeFavorite(resep);
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: provider.favoriteRecipes
                                              .contains(resep)
                                          ? Colors.red
                                          : Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
