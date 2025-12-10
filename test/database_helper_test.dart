import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_app/services/database_helper.dart';
import 'package:meal_app/models/meal.dart';

void main() {
  group('DatabaseHelper Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
      // Limpar SharedPreferences antes de cada teste
      SharedPreferences.setMockInitialValues({});
    });

    test('Deve adicionar e buscar favorito corretamente', () async {
      // Arrange
      final favorite = FavoriteMeal(
        mealId: '12345',
        mealName: 'Test Meal',
        mealThumb: 'https://test.com/image.jpg',
        category: 'Dessert',
        savedAt: DateTime.now(),
      );

      // Act
      await dbHelper.addFavorite(favorite);
      final favorites = await dbHelper.getFavorites();

      // Assert
      expect(favorites.length, 1);
      expect(favorites[0].mealId, '12345');
      expect(favorites[0].mealName, 'Test Meal');
    });

    test('Deve verificar se uma receita é favorita', () async {
      // Arrange
      final favorite = FavoriteMeal(
        mealId: '12345',
        mealName: 'Test Meal',
        mealThumb: 'https://test.com/image.jpg',
        savedAt: DateTime.now(),
      );
      await dbHelper.addFavorite(favorite);

      // Act
      final isFav = await dbHelper.isFavorite('12345');
      final isNotFav = await dbHelper.isFavorite('99999');

      // Assert
      expect(isFav, true);
      expect(isNotFav, false);
    });

    test('Deve remover favorito corretamente', () async {
      // Arrange
      final favorite = FavoriteMeal(
        mealId: '12345',
        mealName: 'Test Meal',
        mealThumb: 'https://test.com/image.jpg',
        savedAt: DateTime.now(),
      );
      await dbHelper.addFavorite(favorite);

      // Act
      await dbHelper.removeFavorite('12345');
      final favorites = await dbHelper.getFavorites();

      // Assert
      expect(favorites.length, 0);
    });

    test('Deve adicionar item à lista de compras', () async {
      // Act
      await dbHelper.addToShoppingList('Sugar', '1 cup', '12345');
      final list = await dbHelper.getShoppingList();

      // Assert
      expect(list.length, 1);
      expect(list[0]['ingredient'], 'Sugar');
      expect(list[0]['quantity'], '1 cup');
    });

    test('Deve remover item da lista de compras', () async {
      // Arrange
      final id = await dbHelper.addToShoppingList('Sugar', '1 cup', '12345');
      
      // Act
      await dbHelper.removeFromShoppingList(id);
      final list = await dbHelper.getShoppingList();

      // Assert
      expect(list.length, 0);
    });

    test('Deve limpar toda a lista de compras', () async {
      // Arrange
      await dbHelper.addToShoppingList('Sugar', '1 cup', '12345');
      await dbHelper.addToShoppingList('Flour', '2 cups', '12345');
      await dbHelper.addToShoppingList('Eggs', '3', '12345');

      // Act
      await dbHelper.clearShoppingList();
      final list = await dbHelper.getShoppingList();

      // Assert
      expect(list.length, 0);
    });

    test('Deve adicionar múltiplos favoritos', () async {
      // Arrange & Act
      await dbHelper.addFavorite(FavoriteMeal(
        mealId: '1',
        mealName: 'First',
        mealThumb: 'url',
        savedAt: DateTime.now(),
      ));

      await dbHelper.addFavorite(FavoriteMeal(
        mealId: '2',
        mealName: 'Second',
        mealThumb: 'url',
        savedAt: DateTime.now(),
      ));

      final favorites = await dbHelper.getFavorites();

      // Assert
      expect(favorites.length, 2);
    });

    test('Deve retornar lista vazia quando não há favoritos', () async {
      // Act
      final favorites = await dbHelper.getFavorites();

      // Assert
      expect(favorites, isEmpty);
    });

    test('Deve retornar lista vazia quando não há itens na lista de compras', () async {
      // Act
      final list = await dbHelper.getShoppingList();

      // Assert
      expect(list, isEmpty);
    });
  });
}