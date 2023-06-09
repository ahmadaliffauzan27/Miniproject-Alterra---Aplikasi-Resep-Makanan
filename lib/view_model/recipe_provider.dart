import 'package:flutter/material.dart';
import 'package:resep_makanan/model/resep_model.dart';

import '../model/database_helper.dart';
import 'favourite_provider.dart';

class RecipeManager extends ChangeNotifier {
  List<Resep> _reseps = [];
  late DatabaseHelper _dbHelper;
  List<Resep> get reseps => _reseps;
  FavoriteManager favoriteManager = FavoriteManager();

  List<Map<String, dynamic>> resepMakanan = [
    {"image": null, "name": null, "ingredient": null, "step": null}
  ];

  RecipeManager() {
    _dbHelper = DatabaseHelper();
    _getAllReseps();
    notifyListeners();
  }

  void _getAllReseps() async {
    _reseps = await _dbHelper.getResep();
    notifyListeners();
  }

  Future<void> addResep(Resep resep) async {
    await _dbHelper.insertResep(resep);
    _getAllReseps();
    notifyListeners();
  }

  Future<Resep> getResepById(int id) async {
    return await _dbHelper.getResepById(id);
  }

  void updateResep(int id, Resep resep) async {
    await _dbHelper.updateResep(id, resep);
    _getAllReseps();
    notifyListeners();
  }

  void deleteResep(int id) async {
    await _dbHelper.deleteResep(id);
    _getAllReseps();
    notifyListeners();
  }

  void addFavorite(Resep resep) {
    favoriteManager.addFavorite(resep);
    notifyListeners();
  }

  void removeFavorite(Resep resep) {
    favoriteManager.removeFavorite(resep);
    notifyListeners();
  }

  Future<void> searchData(String keyword) async {
    _reseps = await _dbHelper.searchData(keyword);
    notifyListeners();
  }
}
