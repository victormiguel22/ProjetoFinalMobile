class Meal {
  final String idMeal;
  final String strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String strMealThumb;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    required this.strMealThumb,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    // A API retorna ingredientes e medidas em campos separados (strIngredient1, strIngredient2, etc)
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return Meal(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strMealThumb: json['strMealThumb'],
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
    };
  }
}

class Category {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'],
      strCategory: json['strCategory'],
      strCategoryThumb: json['strCategoryThumb'],
      strCategoryDescription: json['strCategoryDescription'],
    );
  }
}

class FavoriteMeal {
  final int? id;
  final String mealId;
  final String mealName;
  final String mealThumb;
  final String? category;
  final DateTime savedAt;

  FavoriteMeal({
    this.id,
    required this.mealId,
    required this.mealName,
    required this.mealThumb,
    this.category,
    required this.savedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealId': mealId,
      'mealName': mealName,
      'mealThumb': mealThumb,
      'category': category,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory FavoriteMeal.fromMap(Map<String, dynamic> map) {
    return FavoriteMeal(
      id: map['id'],
      mealId: map['mealId'],
      mealName: map['mealName'],
      mealThumb: map['mealThumb'],
      category: map['category'],
      savedAt: DateTime.parse(map['savedAt']),
    );
  }
}