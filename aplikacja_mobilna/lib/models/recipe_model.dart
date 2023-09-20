class Recipe {
  String title;
  List<String> ingredients;
  String instructions;
  String imageUrl;
  String recipeType;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.recipeType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      imageUrl: json['imageUrl'],
      recipeType: json['recipeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'recipeType': recipeType,
    };
  }
}
