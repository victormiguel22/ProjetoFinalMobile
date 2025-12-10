import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meal_controller.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MealController controller = Get.find<MealController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              if (controller.shoppingList.isNotEmpty) {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Limpar Lista'),
                    content: const Text(
                      'Deseja limpar toda a lista de compras?'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearShoppingList();
                          Get.back();
                        },
                        child: const Text('Limpar'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.shoppingList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lista de compras vazia',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione ingredientes das receitas!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${controller.shoppingList.length} itens na lista',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.shoppingList.length,
                itemBuilder: (context, index) {
                  final item = controller.shoppingList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(
                          Icons.shopping_basket,
                          color: Colors.deepOrange,
                        ),
                      ),
                      title: Text(
                        item['ingredient'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: item['quantity'] != null &&
                              item['quantity'].toString().isNotEmpty
                          ? Text('Quantidade: ${item['quantity']}')
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.removeFromShoppingList(item['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.shoppingList.isEmpty) return const SizedBox.shrink();
        
        return FloatingActionButton.extended(
          onPressed: () {
            // Aqui você pode adicionar funcionalidade para compartilhar a lista
            Get.snackbar(
              'Lista',
              'Funcionalidade de compartilhar em desenvolvimento',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          backgroundColor: Colors.deepOrange,
          icon: const Icon(Icons.share),
          label: const Text('Compartilhar'),
        );
      }),
    );
  }
}