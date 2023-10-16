import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecipePage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final String recipeType;
  final List<Map<String, dynamic>> comments;

  const RecipePage({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.recipeType,
    required this.comments,
  }) : super(key: key);

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  double rating = 0;
  TextEditingController commentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<CommentData> comments = [];
  bool isRecipeSaved = false;
  List<Map<String, dynamic>> savedRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  _loadSavedRecipes() async {
    final preferences = await SharedPreferences.getInstance();
    final savedRecipesJson = preferences.getStringList('savedRecipes');
    if (savedRecipesJson != null) {
      final loadedRecipes = savedRecipesJson
          .map((recipeJson) => Map<String, dynamic>.from(
              json.decode(recipeJson) as Map<String, dynamic>))
          .toList();
      setState(() {
        savedRecipes.addAll(loadedRecipes);
      });
    }
  }

  // Зберегти збережені рецепти при закритті додатку
  @override
  void dispose() {
    _saveRecipes();
    super.dispose();
  }

  bool isRecipeAlreadySaved() {
    return savedRecipes.any((recipe) {
      return recipe['title'] == widget.title;
    });
  }

  _saveRecipes() async {
    final preferences = await SharedPreferences.getInstance();
    final savedRecipesJson =
        savedRecipes.map((recipe) => json.encode(recipe)).toList();
    preferences.setStringList('savedRecipes', savedRecipesJson);
  }

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
          if (isRecipeAlreadySaved()) {
            // Рецепт вже збережено, тому перейдемо до сторінки збережених рецептів
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SavedRecipesListPage(
                  savedRecipes: savedRecipes,
                ),
              ),
            );
          } else {
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

            // Зберегти зміни до списку збережених рецептів
            _saveRecipes();
            // Перейти до сторінки збережених рецептів
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SavedRecipesListPage(
                  savedRecipes: savedRecipes,
                ),
              ),
            );
          }
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

class SavedRecipesListPage extends StatelessWidget {
  final List<Map<String, dynamic>> savedRecipes;

  const SavedRecipesListPage({super.key, required this.savedRecipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
      ),
      body: ListView.builder(
        itemCount: savedRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(savedRecipes[index]['imageUrl'],
                width: 40, height: 40),
            title: Text(savedRecipes[index]['title']),
            onTap: () {
              // Navigate to the recipe page when an item is tapped
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipePage(
                    title: savedRecipes[index]['title'],
                    imageUrl: savedRecipes[index]['imageUrl'],
                    ingredients:
                        List<String>.from(savedRecipes[index]['ingredients']),
                    instructions: savedRecipes[index]['instructions'],
                    recipeType: savedRecipes[index]['recipeType'],
                    comments: List<Map<String, dynamic>>.from(
                        savedRecipes[index]['comments']),
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
