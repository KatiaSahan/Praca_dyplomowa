class SavedRecipe {
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String recipeType;

  SavedRecipe({
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.recipeType,
  });
}
