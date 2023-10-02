import 'package:flutter/material.dart';

import '../../menu/additional_page/saved_recipe_page.dart';

class RecipePage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String recipeType;

  const RecipePage({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.recipeType,
    required List<Map<String, dynamic>> comments,
  }) : super(key: key);

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static List<Map<String, dynamic>> savedRecipes = [];
  double rating = 0;
  TextEditingController commentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<CommentData> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.ingredients
                        .map((ingredient) => Text('- $ingredient'))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.instructions),
                  const SizedBox(height: 16),
                  const Text(
                    'Recipe Type:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.recipeType),

                  // Add a rating widget
                  const Text('Rate this recipe:'),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        IconButton(
                          icon: const Icon(Icons.star),
                          color: rating >= i ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              rating = i.toDouble();
                            });
                          },
                        ),
                    ],
                  ),

                  // Add a comment input field
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: 'Your Name'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: commentController,
                          decoration:
                              const InputDecoration(labelText: 'Add a comment'),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final name = nameController.text;
                      final comment = commentController.text;
                      setState(() {
                        comments.add(CommentData(name, comment, rating));
                        nameController.clear();
                        commentController.clear();
                        rating = 0;
                      });
                    },
                    child: const Text('Submit Comment'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Comments:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: comments
                        .asMap()
                        .map((index, commentData) => MapEntry(
                              index,
                              _buildCommentWidget(index, commentData),
                            ))
                        .values
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
// Додавання рецепту до списку збережених рецептів
          final savedRecipe = {
            'title': widget.title,
            'imageUrl': widget.imageUrl,
            'ingredients': widget.ingredients,
            'instructions': widget.instructions,
            'recipeType': widget.recipeType,
            'rating': rating,
            'comments': comments
                .map((commentData) => {
                      'name': commentData.name,
                      'comment': commentData.comment,
                      'rating': commentData.rating,
                    })
                .toList(),
          };
          savedRecipes.add(savedRecipe);

          // Показ повідомлення про збереження рецепту
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe saved')),
          );
          // Перехід до сторінки "SavedRecipesPage"

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SavedRecipesPage(
                savedRecipes: [],
              ),
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildCommentWidget(int index, CommentData commentData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(commentData.comment),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By: ${commentData.name}'),
            Row(
              children: [
                Row(
                  children: List.generate(
                    commentData.rating.toInt(),
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      comments.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentData {
  final String name;
  final String comment;
  final double rating;

  CommentData(this.name, this.comment, this.rating);
}
