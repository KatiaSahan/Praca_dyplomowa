// ignore_for_file: unused_local_variable

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../home/recipe/recipe_page.dart';

class Kolacja extends StatelessWidget {
  const Kolacja({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference recipeRef =
        FirebaseDatabase.instance.ref().child('recipes');

    Query getRecipesQuery() {
      return FirebaseDatabase.instance
          .ref()
          .child('recipes')
          .orderByChild('recipeType')
          .equalTo('Kolacja');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kolacja"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: getRecipesQuery(),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final recipeData = snapshot.value as Map<dynamic, dynamic>?;

                if (recipeData != null) {
                  final recipeTitle = recipeData['title'] as String;
                  final recipePhotoUrl = recipeData['photoUrl'] as String;

                  return ListTile(
                    title: Text(recipeTitle),
                    leading: Image.network(recipePhotoUrl),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(
                              title: recipeData['title'],
                              imageUrl: recipeData['photoUrl'],
                              ingredients: List.from(recipeData['ingredients']),
                              instructions: recipeData['instructions'],
                              recipeType: recipeData['recipeType'],
                              comments: const [],
                            ),
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
