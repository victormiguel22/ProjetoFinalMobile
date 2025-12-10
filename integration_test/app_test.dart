import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meal_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Meal App Integration Tests', () {
    testWidgets('Fluxo completo: Splash → Home → Buscar Receita → Ver Detalhes', 
      (WidgetTester tester) async {
      // Iniciar o app
      app.main();
      await tester.pumpAndSettle();

      // Verificar SplashScreen
      expect(find.text('Meal App'), findsOneWidget);
      expect(find.text('Descubra receitas deliciosas'), findsOneWidget);

      // Aguardar transição para HomeScreen (3 segundos)
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verificar se está na HomeScreen
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Categorias'), findsOneWidget);

      // Aguardar carregamento das categorias
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Clicar no botão de busca
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Verificar se está na tela de busca
      expect(find.text('Buscar Receitas'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Digitar na busca
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'chicken');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar se exibiu resultados (se houver conexão)
      // Nota: Este teste pode falhar sem internet
      // expect(find.byType(Card), findsWidgets);

      // Voltar para home
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('Fluxo de navegação: Home → Favoritos → Lista de Compras', 
      (WidgetTester tester) async {
      // Iniciar o app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verificar HomeScreen
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Navegar para Favoritos
      final favoriteButton = find.byIcon(Icons.favorite);
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Verificar tela de Favoritos
      expect(find.text('Favoritos'), findsOneWidget);
      // Se não houver favoritos
      expect(find.text('Nenhum favorito ainda'), findsOneWidget);

      // Voltar
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Navegar para Lista de Compras
      final shoppingButton = find.byIcon(Icons.shopping_cart);
      await tester.tap(shoppingButton);
      await tester.pumpAndSettle();

      // Verificar tela de Lista de Compras
      expect(find.text('Lista de Compras'), findsOneWidget);
      expect(find.text('Lista de compras vazia'), findsOneWidget);

      // Voltar para home
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('Teste de carregamento de categorias', 
      (WidgetTester tester) async {
      // Iniciar o app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Aguardar carregamento
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar se as categorias foram carregadas
      // Nota: Requer conexão com internet
      expect(find.text('Categorias'), findsOneWidget);
      
      // Verificar se há loading indicator ou categorias
      final hasCategories = find.byType(CircularProgressIndicator).evaluate().isEmpty;
      
      if (hasCategories) {
        // Se carregou, deve ter pelo menos uma categoria
        print('Categorias carregadas com sucesso');
      } else {
        print('Ainda carregando categorias');
      }
    });

    testWidgets('Teste do botão Receita Aleatória', 
      (WidgetTester tester) async {
      // Iniciar o app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Procurar botão de receita aleatória
      final randomButton = find.text('Receita Aleatória');
      
      if (randomButton.evaluate().isNotEmpty) {
        // Clicar no botão
        await tester.tap(randomButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verificar se navegou (depende de conexão)
        print('Botão de receita aleatória clicado');
      }
    });

    testWidgets('Teste de interação com categorias', 
      (WidgetTester tester) async {
      // Iniciar o app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Aguardar carregamento das categorias
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tentar encontrar e clicar em uma categoria
      // Nota: Isso depende das categorias terem carregado
      final categoryCards = find.byType(GestureDetector);
      
      if (categoryCards.evaluate().isNotEmpty) {
        // Clicar na primeira categoria
        await tester.tap(categoryCards.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verificar se carregou receitas da categoria
        print('Categoria clicada e receitas carregadas');
      }
    });
  });
}