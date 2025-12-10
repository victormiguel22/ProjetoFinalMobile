import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/meal_controller.dart';
import 'meal_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MealController controller = Get.find<MealController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Obx(() {
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum favorito ainda',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione receitas aos favoritos!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final favorite = controller.favorites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  Get.to(() => MealDetailsScreen(mealId: favorite.mealId));
                },
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: favorite.mealThumb,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              favorite.mealName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (favorite.category != null) ...[
                              const SizedBox(height: 8),
                              Chip(
                                label: Text(
                                  favorite.category!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.orange.shade100,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Remover Favorito'),
                            content: const Text(
                              'Deseja remover esta receita dos favoritos?'
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.toggleFavorite(
                                    // Criar objeto Meal básico para remover
                                    controller.meals.firstWhere(
                                      (m) => m.idMeal == favorite.mealId,
                                      orElse: () => controller.meals.first,
                                    ),
                                  );
                                  Get.back();
                                },
                                child: const Text('Remover'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}