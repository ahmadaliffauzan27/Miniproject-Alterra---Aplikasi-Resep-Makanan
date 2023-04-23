import 'package:flutter/material.dart';
import '../model/resep_model.dart';

class FavoriteManager extends ChangeNotifier {
  List<Resep> _favoriteRecipes = [];
  List<Resep> get favoriteRecipes => _favoriteRecipes;

  void addFavorite(Resep resep) {
    if (!_favoriteRecipes.contains(resep)) {
      _favoriteRecipes.add(resep);
      notifyListeners();
    }
  }

  void removeFavorite(Resep resep) {
    _favoriteRecipes.remove(resep);
    notifyListeners();
  }
}
