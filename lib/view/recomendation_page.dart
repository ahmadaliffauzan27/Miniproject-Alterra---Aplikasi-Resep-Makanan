import 'package:flutter/material.dart';
import 'package:resep_makanan/model/apis/api_resep.dart';
import 'package:resep_makanan/model/resep_model_api.dart';
import 'package:resep_makanan/view/style/theme.dart';

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({Key? key}) : super(key: key);

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  Future<List<ResepApi>>? _futureMeals;
  @override
  void initState() {
    super.initState();
    _futureMeals = ApiMeal.getBeefMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
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
                      "Aneka Resep Beef",
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
          FutureBuilder<List<ResepApi>>(
            future: _futureMeals,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final meals = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ListTile(
                            leading: meal.imageUrl.isNotEmpty
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(meal.imageUrl),
                                  )
                                : null,
                            title: Text(meal.name),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
