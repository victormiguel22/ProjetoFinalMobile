import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/meal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  DatabaseHelper._init();

  // Chaves para SharedPreferences
  static const String _favoritesKey = 'favorites';
  static const String _shoppingListKey = 'shopping_list';

  // CRUD para Favoritos
  Future<int> addFavorite(FavoriteMeal meal) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.add(meal);
    
    final favoritesJson = favorites.map((f) => f.toMap()).toList();
    await prefs.setString(_favoritesKey, json.encode(favoritesJson));
    
    return favorites.length;
  }

  Future<List<FavoriteMeal>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString(_favoritesKey);
    
    if (favoritesString == null) return [];
    
    final List<dynamic> favoritesList = json.decode(favoritesString);
    return favoritesList.map((f) => FavoriteMeal.fromMap(f)).toList();
  }

  Future<bool> isFavorite(String mealId) async {
    final favorites = await getFavorites();
    return favorites.any((f) => f.mealId == mealId);
  }

  Future<int> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((f) => f.mealId == mealId);
    
    final favoritesJson = favorites.map((f) => f.toMap()).toList();
    await prefs.setString(_favoritesKey, json.encode(favoritesJson));
    
    return 1;
  }

  // CRUD para Lista de Compras
  Future<int> addToShoppingList(String ingredient, String? quantity, String? mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingList = await getShoppingList();
    
    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'ingredient': ingredient,
      'quantity': quantity,
      'mealId': mealId,
      'addedAt': DateTime.now().toIso8601String(),
    };
    
    shoppingList.add(newItem);
    
    await prefs.setString(_shoppingListKey, json.encode(shoppingList));
    
    return newItem['id'] as int;
  }

  Future<List<Map<String, dynamic>>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? listString = prefs.getString(_shoppingListKey);
    
    if (listString == null) return [];
    
    final List<dynamic> list = json.decode(listString);
    return list.cast<Map<String, dynamic>>();
  }

  Future<int> removeFromShoppingList(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingList = await getShoppingList();
    
    shoppingList.removeWhere((item) => item['id'] == id);
    
    await prefs.setString(_shoppingListKey, json.encode(shoppingList));
    
    return 1;
  }

  Future<int> clearShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_shoppingListKey);
    return 1;
  }

  Future close() async {
  }
}