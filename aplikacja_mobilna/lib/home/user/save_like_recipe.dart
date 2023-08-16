import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SavedRecipesList extends StatelessWidget {
  final String userId;

  const SavedRecipesList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('saved_recipes')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Отримати дані зі снепшоту та відобразити список збережених рецептів
          final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            final savedRecipes = data.values.toList();

            return Column(
              children: [
                const Text('Saved Recipes:'),
                // Відобразити список збережених рецептів
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: savedRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = savedRecipes[index];
                    return ListTile(
                      title: Text(recipe['title'] ?? ''),
                      // Відобразити деталі рецепта та інше за потребою
                    );
                  },
                ),
              ],
            );
          }
        }

        // Якщо немає даних, показати пустий список або спінер завантаження
        return const CircularProgressIndicator();
      },
    );
  }
}

class MyRecipesList extends StatelessWidget {
  final String userId;

  const MyRecipesList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('my_recipes')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Отримати дані зі снепшоту та відобразити список власних рецептів
          final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            final myRecipes = data.values.toList();

            return Column(
              children: [
                const Text('My Recipes:'),
                // Відобразити список власних рецептів
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: myRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = myRecipes[index];
                    return ListTile(
                      title: Text(recipe['title'] ?? ''),
                      // Відобразити деталі рецепта та інше за потребою
                    );
                  },
                ),
              ],
            );
          }
        }

        // Якщо немає даних, показати пустий список або спінер завантаження
        return const CircularProgressIndicator();
      },
    );
  }
}
