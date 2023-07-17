class Recipe {
  String title;
  List<String> ingredients;
  String instructions;
  String photoUrl;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.photoUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'photoUrl': photoUrl,
    };
  }
}
