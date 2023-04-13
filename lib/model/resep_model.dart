import 'dart:typed_data';

class Resep {
  late int? id;
  late String name;
  late String ingredients;
  late String step;
  late Uint8List? picture;

  Resep(
      {this.id,
      required this.name,
      required this.ingredients,
      required this.step,
      this.picture});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'step': step,
      'picture': picture,
    };
  }

  Resep.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    ingredients = map['ingredients'];
    step = map['step'];
    picture = map['picture'];
  }
}
