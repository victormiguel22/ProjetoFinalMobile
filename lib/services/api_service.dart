import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Buscar categorias
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categories = data['categories'];
        return categories.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar receitas por categoria
  Future<List<Meal>> getMealsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'] ?? [];
        return meals.map((json) => Meal(
          idMeal: json['idMeal'],
          strMeal: json['strMeal'],
          strMealThumb: json['strMealThumb'],
          ingredients: [],
          measures: [],
        )).toList();
      } else {
        throw Exception('Falha ao carregar receitas');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar detalhes da receita
  Future<Meal> getMealDetails(String mealId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lookup.php?i=$mealId')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'];
        if (meals.isEmpty) {
          throw Exception('Receita não encontrada');
        }
        return Meal.fromJson(meals[0]);
      } else {
        throw Exception('Falha ao carregar detalhes');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar receitas por nome
  Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?s=$query')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List? meals = data['meals'];
        
        if (meals == null) return [];
        
        return meals.map((json) => Meal.fromJson(json)).toList();
      } else {
        throw Exception('Falha na busca');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar receita aleatória
  Future<Meal> getRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/random.php')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'];
        return Meal.fromJson(meals[0]);
      } else {
        throw Exception('Falha ao carregar receita aleatória');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Buscar receitas por área (país)
  Future<List<Meal>> getMealsByArea(String area) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?a=$area')
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List meals = data['meals'] ?? [];
        return meals.map((json) => Meal(
          idMeal: json['idMeal'],
          strMeal: json['strMeal'],
          strMealThumb: json['strMealThumb'],
          ingredients: [],
          measures: [],
        )).toList();
      } else {
        throw Exception('Falha ao carregar receitas');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}