// ignore_for_file: use_build_context_synchronously

import 'package:aplikacja_mobilna/home/recipe/recipe_page.dart';
import 'package:aplikacja_mobilna/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  EditRecipePageState createState() => EditRecipePageState();
}

class EditRecipePageState extends State<EditRecipePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.recipe.title;
    ingredientsController.text = widget.recipe.ingredients.join(', ');
    instructionsController.text = widget.recipe.instructions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingredients (comma-separated)',
              ),
            ),
            TextFormField(
              controller: instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                saveEditedRecipe();
              },
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  void saveEditedRecipe() async {
    final title = titleController.text;
    final ingredients = ingredientsController.text.split(', ');
    final instructions = instructionsController.text;

    // Оновити дані рецепту в базі даних
    widget.recipe.title = title;
    widget.recipe.ingredients = ingredients;
    widget.recipe.instructions = instructions;

    // Зберегти оновлені дані в SharedPreferences
    final preferences = await SharedPreferences.getInstance();
    final savedRecipesJson = preferences.getStringList('savedRecipes');

    if (savedRecipesJson != null) {
      final updatedRecipes = savedRecipesJson.map((recipeJson) {
        final recipeData = json.decode(recipeJson) as Map<String, dynamic>;
        if (recipeData['title'] == widget.recipe.title) {
          recipeData['title'] = title;
          recipeData['ingredients'] = ingredients;
          recipeData['instructions'] = instructions;
        }
        return json.encode(recipeData);
      }).toList();

      preferences.setStringList('savedRecipes', updatedRecipes);
    }

    // Повернутися на сторінку з рецептом
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecipePage(
          instructions: widget.recipe.instructions,
          title: widget.recipe.title,
          imageUrl: widget.recipe.imageUrl,
          ingredients: widget.recipe.ingredients,
          recipeType: widget.recipe.recipeType,
          comments: const [],
        ),
      ),
    );
  }
}
