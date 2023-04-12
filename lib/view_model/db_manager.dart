import 'package:flutter/material.dart';
import 'package:resep_makanan/model/resep_model.dart';

import '../model/database_helper.dart';

class DbManager extends ChangeNotifier {
  List<Resep> _reseps = [];
  late DatabaseHelper _dbHelper;

  List<Resep> get contacts => _reseps;

  DbManager() {
    _dbHelper = DatabaseHelper();
    _getAllReseps();
    notifyListeners();
  }

  void _getAllReseps() async {
    _reseps = await _dbHelper.getResep();
    notifyListeners();
  }

  Future<void> addContact(Resep resep) async {
    await _dbHelper.insertResep(resep);
    _getAllReseps();
    notifyListeners();
  }

  Future<Resep> getContactById(String id) async {
    return await _dbHelper.getResepById(id);
  }

  void updateContact(int id, Resep resep) async {
    await _dbHelper.updateResep(id, resep);
    _getAllReseps();
    notifyListeners();
  }

  void deleteContact(int id, Resep resep) async {
    await _dbHelper.deleteContact(id, resep);
    _getAllReseps();
    notifyListeners();
  }
}
