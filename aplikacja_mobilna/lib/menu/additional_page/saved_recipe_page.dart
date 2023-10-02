import 'package:flutter/material.dart';
import '../../home/recipe/recipe_page.dart';

class SavedRecipesPage extends StatelessWidget {
  final List<Map<String, dynamic>> savedRecipes;

  const SavedRecipesPage({
    Key? key,
    required this.savedRecipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Збережені рецепти'),
      ),
      body: ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = savedRecipes[index];
          return ListTile(
            title: Text(recipe['title']),
            // Додайте код для відображення інших даних рецепту (фото, інгредієнти тощо)
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipePage(
                    title: recipe['title'],
                    imageUrl: recipe['imageUrl'],
                    ingredients:
                        (recipe['ingredients'] as List<String>).cast<String>(),
                    instructions: recipe['instructions'],
                    recipeType: recipe['recipeType'],
                    comments: (recipe['comments'] as List)
                        .cast<Map<String, dynamic>>(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
