import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(imageUrl),
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
                    children: ingredients
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
                  Text(instructions),
                  const SizedBox(height: 16),
                  const Text(
                    'Recipe Type:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(recipeType),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
