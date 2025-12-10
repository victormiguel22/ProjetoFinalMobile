import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../controllers/meal_controller.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  const MealDetailsScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final ApiService _apiService = ApiService();
  final MealController _controller = Get.find<MealController>();
  Meal? meal;
  bool isLoading = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadMealDetails();
    checkFavorite();
  }

  Future<void> loadMealDetails() async {
    try {
      final result = await _apiService.getMealDetails(widget.mealId);
      setState(() {
        meal = result;
        isLoading = false;
      });
      
      // Registrar visualização
      _controller.logMealView(result.idMeal, result.strMeal);
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Erro', 'Falha ao carregar detalhes');
    }
  }

  Future<void> checkFavorite() async {
    final result = await _controller.isFavorite(widget.mealId);
    setState(() => isFavorite = result);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepOrange),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      );
    }

    if (meal == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepOrange),
        body: const Center(child: Text('Receita não encontrada')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 16),
                  _buildInfoChips(),
                  const SizedBox(height: 24),
                  _buildIngredientsSection(),
                  const SizedBox(height: 24),
                  _buildInstructionsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.deepOrange,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: meal!.strMealThumb,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () async {
            await _controller.toggleFavorite(meal!);
            await checkFavorite();
          },
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      meal!.strMeal,
      style: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoChips() {
    return Wrap(
      spacing: 8,
      children: [
        if (meal!.strCategory != null)
          Chip(
            avatar: const Icon(Icons.category, size: 18),
            label: Text(meal!.strCategory!),
            backgroundColor: Colors.orange.shade100,
          ),
        if (meal!.strArea != null)
          Chip(
            avatar: const Icon(Icons.public, size: 18),
            label: Text(meal!.strArea!),
            backgroundColor: Colors.blue.shade100,
          ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredientes',
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _addAllToShoppingList(),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Adicionar Todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(meal!.ingredients.length, (index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text(meal!.ingredients[index]),
              subtitle: Text(meal!.measures[index]),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  _controller.addToShoppingList(
                    meal!.ingredients[index],
                    meal!.measures[index],
                    meal!.idMeal,
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo de Preparo',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              meal!.strInstructions ?? 'Instruções não disponíveis',
              style: GoogleFonts.roboto(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  void _addAllToShoppingList() {
    for (int i = 0; i < meal!.ingredients.length; i++) {
      _controller.addToShoppingList(
        meal!.ingredients[i],
        meal!.measures[i],
        meal!.idMeal,
      );
    }
    Get.snackbar(
      'Adicionado',
      'Todos os ingredientes adicionados à lista de compras',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}