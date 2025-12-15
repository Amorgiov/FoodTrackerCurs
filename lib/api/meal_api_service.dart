import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal_category.dart';
import 'meal.dart';
import 'meal_details.dart';

class MealApiService {
  static const String _baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/categories.php');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List list = data['categories'];

    return list.map((e) => MealCategory.fromJson(e)).toList();
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse(
        '$_baseUrl/filter.php?c=${Uri.encodeComponent(category)}');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List list = data['meals'];

    return list.map((e) => Meal.fromJson(e)).toList();
  }

  Future<MealDetails> fetchMealDetails(String mealId) async {
    final url = Uri.parse('$_baseUrl/lookup.php?i=$mealId');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal details');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final mealJson = data['meals'][0];

    return MealDetails.fromJson(mealJson);
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search.php?s=${Uri.encodeComponent(query)}');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Search failed');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;

    if (data['meals'] == null) return [];

    final List list = data['meals'];
    return list.map((e) => Meal.fromJson(e)).toList();
  }
}
