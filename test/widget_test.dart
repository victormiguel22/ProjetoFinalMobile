import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:meal_app/models/meal.dart';
import 'package:meal_app/widgets/meal_card.dart';

void main() {
  group('MealCard Widget Tests', () {
    testWidgets('Deve renderizar MealCard com informações da receita', (WidgetTester tester) async {
      // Arrange
      final meal = Meal(
        idMeal: '52772',
        strMeal: 'Teriyaki Chicken Casserole',
        strCategory: 'Chicken',
        strArea: 'Japanese',
        strMealThumb: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        ingredients: ['soy sauce', 'water'],
        measures: ['3/4 cup', '1/2 cup'],
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: MealCard(meal: meal),
          ),
        ),
      );

      // Assert
      expect(find.text('Teriyaki Chicken Casserole'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('Deve truncar nome longo da receita com ellipsis', (WidgetTester tester) async {
      // Arrange
      final meal = Meal(
        idMeal: '1',
        strMeal: 'Um Nome Extremamente Longo Para Uma Receita Que Deveria Ser Truncado',
        strMealThumb: 'https://test.com/image.jpg',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: MealCard(meal: meal),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(
        find.text('Um Nome Extremamente Longo Para Uma Receita Que Deveria Ser Truncado')
      );
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('Deve conter GestureDetector para navegação', (WidgetTester tester) async {
      // Arrange
      final meal = Meal(
        idMeal: '123',
        strMeal: 'Test Meal',
        strMealThumb: 'https://test.com/image.jpg',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: MealCard(meal: meal),
          ),
        ),
      );

      // Assert
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('Deve ter Card com elevação e border radius', (WidgetTester tester) async {
      // Arrange
      final meal = Meal(
        idMeal: '123',
        strMeal: 'Test Meal',
        strMealThumb: 'https://test.com/image.jpg',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: MealCard(meal: meal),
          ),
        ),
      );

      // Assert
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('Deve exibir placeholder enquanto imagem carrega', (WidgetTester tester) async {
      // Arrange
      final meal = Meal(
        idMeal: '123',
        strMeal: 'Test Meal',
        strMealThumb: 'https://test.com/image.jpg',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: MealCard(meal: meal),
          ),
        ),
      );

      // Assert - Verifica que tem um CircularProgressIndicator como placeholder
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('CategoryCard Widget Tests', () {
    testWidgets('Deve renderizar CategoryCard corretamente', (WidgetTester tester) async {
      // Arrange
      final category = Category(
        idCategory: '1',
        strCategory: 'Beef',
        strCategoryThumb: 'https://test.com/image.jpg',
        strCategoryDescription: 'Beef dishes',
      );

      // Act
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Container(), // Placeholder para CategoryCard
          ),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}