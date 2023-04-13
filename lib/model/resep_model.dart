class Resep {
  late int? id;
  late String name;
  late String ingredients;
  late String step;

  Resep(
      {this.id,
      required this.name,
      required this.ingredients,
      required this.step});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'step': step,
    };
  }

  Resep.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    ingredients = map['ingredients'];
    step = map['step'];
  }
}
