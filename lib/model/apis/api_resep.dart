import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resep_makanan/model/resep_model_api.dart';

class ApiMeal {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String beefMeals = '/filter.php?c=beef';

  static Future<List<ResepApi>> getBeefMeals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$beefMeals'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> body = responseBody['meals'];
        final List<ResepApi> meals =
            body.map((e) => ResepApi.fromJson(e)).toList();
        return meals;
      } else {
        throw Exception("Can't get the data");
      }
    } catch (error) {
      print('Error: $error');
      return <ResepApi>[];
    }
  }
}
