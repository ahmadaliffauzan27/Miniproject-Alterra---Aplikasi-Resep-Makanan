import 'package:flutter/material.dart';
import 'package:resep_makanan/model/resep_model_api.dart';

class RecomendationProvider extends ChangeNotifier {
  List<ResepApi> _reseps = [];

  List<ResepApi> get reseps => _reseps;

  set reseps(List<ResepApi> value) {
    _reseps = value;
    notifyListeners();
  }

  void addResep(ResepApi resep) {
    _reseps.add(resep);
    notifyListeners();
  }

  void removeResep(ResepApi resep) {
    _reseps.remove(resep);
    notifyListeners();
  }
}
