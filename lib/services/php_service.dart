import 'dart:convert';
import 'package:http/http.dart' as http;

class PhpService {
  // URL do servidor XAMPP local
  static const String baseUrl = 'http://localhost:8000'; // Para emulador Android
  // Use 'http://localhost/meal_api' para iOS simulator ou navegador web
  // Use 'http://SEU_IP/meal_api' para dispositivo físico (ex: 'http://192.168.1.100/meal_api')
  // Para descobrir seu IP: Windows use 'ipconfig', Mac/Linux use 'ifconfig'

  // Sincronizar favoritos com servidor
  Future<bool> syncFavorites(List<Map<String, dynamic>> favorites) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sync_favorites.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'favorites': favorites}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao sincronizar favoritos: $e');
      return false;
    }
  }

  // Buscar favoritos do servidor
  Future<List<dynamic>> getFavoritesFromServer() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_favorites.php'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['favorites'] ?? [];
      }
      return [];
    } catch (e) {
      print('Erro ao buscar favoritos do servidor: $e');
      return [];
    }
  }

  // Salvar lista de compras no servidor
  Future<bool> saveShoppingList(List<Map<String, dynamic>> items) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save_shopping_list.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'items': items}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao salvar lista de compras: $e');
      return false;
    }
  }

  // Buscar lista de compras do servidor
  Future<List<dynamic>> getShoppingListFromServer() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_shopping_list.php'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['items'] ?? [];
      }
      return [];
    } catch (e) {
      print('Erro ao buscar lista de compras: $e');
      return [];
    }
  }

  // Registrar visualização de receita
  Future<bool> logMealView(String mealId, String mealName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/log_view.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mealId': mealId,
          'mealName': mealName,
          'viewedAt': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      }
      return false;
    } catch (e) {
      print('Erro ao registrar visualização: $e');
      return false;
    }
  }

  // Buscar histórico de visualizações
  Future<List<dynamic>> getViewHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_history.php'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['history'] ?? [];
      }
      return [];
    } catch (e) {
      print('Erro ao buscar histórico: $e');
      return [];
    }
  }

}
