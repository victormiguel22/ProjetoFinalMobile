import 'package:flutter_test/flutter_test.dart';
import 'package:meal_app/models/meal.dart';

void main() {
  group('Meal Model Tests', () {
    test('Deve converter JSON para objeto Meal corretamente', () {
      // Arrange
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strInstructions': 'Preheat oven to 350° F...',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        'strIngredient1': 'soy sauce',
        'strIngredient2': 'water',
        'strIngredient3': 'brown sugar',
        'strIngredient4': '',
        'strMeasure1': '3/4 cup',
        'strMeasure2': '1/2 cup',
        'strMeasure3': '1/4 cup',
        'strMeasure4': '',
      };

      // Act
      final meal = Meal.fromJson(json);

      // Assert
      expect(meal.idMeal, '52772');
      expect(meal.strMeal, 'Teriyaki Chicken Casserole');
      expect(meal.strCategory, 'Chicken');
      expect(meal.strArea, 'Japanese');
      expect(meal.ingredients.length, 3);
      expect(meal.ingredients[0], 'soy sauce');
      expect(meal.measures[0], '3/4 cup');
    });

    test('Deve ignorar ingredientes vazios ao converter JSON', () {
      // Arrange
      final json = {
        'idMeal': '12345',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://test.com/image.jpg',
        'strIngredient1': 'ingredient1',
        'strIngredient2': '',
        'strIngredient3': 'ingredient3',
        'strMeasure1': 'measure1',
        'strMeasure2': '',
        'strMeasure3': 'measure3',
      };

      // Act
      final meal = Meal.fromJson(json);

      // Assert
      expect(meal.ingredients.length, 2);
      expect(meal.ingredients, ['ingredient1', 'ingredient3']);
      expect(meal.measures.length, 2);
    });

    test('Deve converter objeto Meal para JSON corretamente', () {
      // Arrange
      final meal = Meal(
        idMeal: '123',
        strMeal: 'Test Meal',
        strCategory: 'Dessert',
        strArea: 'American',
        strInstructions: 'Cook it well',
        strMealThumb: 'https://test.com/image.jpg',
        ingredients: ['sugar', 'flour'],
        measures: ['1 cup', '2 cups'],
      );

      // Act
      final json = meal.toJson();

      // Assert
      expect(json['idMeal'], '123');
      expect(json['strMeal'], 'Test Meal');
      expect(json['strCategory'], 'Dessert');
      expect(json['strArea'], 'American');
    });
  });

  group('FavoriteMeal Model Tests', () {
    test('Deve converter Map para FavoriteMeal corretamente', () {
      // Arrange
      final map = {
        'id': 1,
        'mealId': '52772',
        'mealName': 'Teriyaki Chicken',
        'mealThumb': 'https://test.com/image.jpg',
        'category': 'Chicken',
        'savedAt': '2024-01-15T10:30:00.000',
      };

      // Act
      final favorite = FavoriteMeal.fromMap(map);

      // Assert
      expect(favorite.id, 1);
      expect(favorite.mealId, '52772');
      expect(favorite.mealName, 'Teriyaki Chicken');
      expect(favorite.category, 'Chicken');
      expect(favorite.savedAt.year, 2024);
    });

    test('Deve converter FavoriteMeal para Map corretamente', () {
      // Arrange
      final favorite = FavoriteMeal(
        id: 1,
        mealId: '52772',
        mealName: 'Test Meal',
        mealThumb: 'https://test.com/image.jpg',
        category: 'Dessert',
        savedAt: DateTime(2024, 1, 15),
      );

      // Act
      final map = favorite.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['mealId'], '52772');
      expect(map['mealName'], 'Test Meal');
      expect(map['category'], 'Dessert');
      expect(map['savedAt'], isA<String>());
    });
  });
}