import 'package:get/get.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import '../services/php_service.dart';

class MealController extends GetxController {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final PhpService _phpService = PhpService();

  var categories = <Category>[].obs;
  var meals = <Meal>[].obs;
  var favorites = <FavoriteMeal>[].obs;
  var shoppingList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadFavorites();
    loadShoppingList();
  }

  // Carregar categorias
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _apiService.getCategories();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar categorias: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar receitas por categoria
  Future<void> loadMealsByCategory(String category) async {
    try {
      isLoading.value = true;
      selectedCategory.value = category;
      meals.value = await _apiService.getMealsByCategory(category);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar receitas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Buscar receitas
  Future<void> searchMeals(String query) async {
    try {
      isLoading.value = true;
      meals.value = await _apiService.searchMeals(query);
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha na busca: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Buscar receita aleatória
  Future<Meal?> getRandomMeal() async {
    try {
      isLoading.value = true;
      return await _apiService.getRandomMeal();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao buscar receita aleatória: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar favoritos
  Future<void> loadFavorites() async {
    try {
      favorites.value = await _dbHelper.getFavorites();
    } catch (e) {
      print('Erro ao carregar favoritos: $e');
    }
  }

  // Adicionar/Remover favorito
  Future<void> toggleFavorite(Meal meal) async {
    try {
      bool isFav = await _dbHelper.isFavorite(meal.idMeal);
      
      if (isFav) {
        await _dbHelper.removeFavorite(meal.idMeal);
        Get.snackbar(
          'Removido',
          '${meal.strMeal} removido dos favoritos',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _dbHelper.addFavorite(FavoriteMeal(
          mealId: meal.idMeal,
          mealName: meal.strMeal,
          mealThumb: meal.strMealThumb,
          category: meal.strCategory,
          savedAt: DateTime.now(),
        ));
        Get.snackbar(
          'Adicionado',
          '${meal.strMeal} adicionado aos favoritos',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      
      await loadFavorites();
      
      // Sincronizar com servidor PHP
      await syncFavoritesWithServer();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao atualizar favoritos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Verificar se é favorito
  Future<bool> isFavorite(String mealId) async {
    return await _dbHelper.isFavorite(mealId);
  }

  // Sincronizar favoritos com servidor
  Future<void> syncFavoritesWithServer() async {
    try {
      final favList = favorites.map((fav) => fav.toMap()).toList();
      await _phpService.syncFavorites(favList);
    } catch (e) {
      print('Erro ao sincronizar com servidor: $e');
    }
  }

  // Lista de compras
  Future<void> loadShoppingList() async {
    try {
      shoppingList.value = await _dbHelper.getShoppingList();
    } catch (e) {
      print('Erro ao carregar lista de compras: $e');
    }
  }

  Future<void> addToShoppingList(String ingredient, String? quantity, String? mealId) async {
    try {
      await _dbHelper.addToShoppingList(ingredient, quantity, mealId);
      await loadShoppingList();
      
      // Sincronizar com servidor
      await _phpService.saveShoppingList(shoppingList);
      
      Get.snackbar(
        'Adicionado',
        '$ingredient adicionado à lista de compras',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao adicionar item: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeFromShoppingList(int id) async {
    try {
      await _dbHelper.removeFromShoppingList(id);
      await loadShoppingList();
      await _phpService.saveShoppingList(shoppingList);
    } catch (e) {
      print('Erro ao remover item: $e');
    }
  }

  Future<void> clearShoppingList() async {
    try {
      await _dbHelper.clearShoppingList();
      await loadShoppingList();
      await _phpService.saveShoppingList(shoppingList);
      Get.snackbar(
        'Limpo',
        'Lista de compras limpa',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Erro ao limpar lista: $e');
    }
  }

  // Registrar visualização
  Future<void> logMealView(String mealId, String mealName) async {
    await _phpService.logMealView(mealId, mealName);
  }
}