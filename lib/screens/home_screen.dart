import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';
import '../widgets/category_card.dart';
import '../widgets/meal_card.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'shopping_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MealController controller = Get.put(MealController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal App',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const SearchScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.to(() => const FavoritesScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => const ShoppingListScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner com botão de receita aleatória
              _buildRandomMealBanner(controller),
              
              // Seção de Categorias
              _buildSectionTitle('Categorias'),
              _buildCategoriesSection(controller),
              
              // Seção de Receitas (se uma categoria foi selecionada)
              if (controller.selectedCategory.isNotEmpty) ...[
                _buildSectionTitle(
                  'Receitas - ${controller.selectedCategory.value}'
                ),
                _buildMealsSection(controller),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRandomMealBanner(MealController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Não sabe o que cozinhar?',
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              final meal = await controller.getRandomMeal();
              if (meal != null) {
                Get.toNamed('/details', arguments: meal.idMeal);
              }
            },
            icon: const Icon(Icons.shuffle),
            label: const Text('Receita Aleatória'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(MealController controller) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return CategoryCard(
            category: category,
            onTap: () => controller.loadMealsByCategory(category.strCategory),
          );
        },
      ),
    );
  }

  Widget _buildMealsSection(MealController controller) {
    if (controller.isLoading.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      );
    }

    if (controller.meals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Nenhuma receita encontrada'),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: controller.meals.length,
      itemBuilder: (context, index) {
        final meal = controller.meals[index];
        return MealCard(meal: meal);
      },
    );
  }
}