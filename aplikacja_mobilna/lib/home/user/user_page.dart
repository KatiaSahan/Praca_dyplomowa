import 'package:flutter/material.dart';

import '../../menu/additional_page/saved_recipe_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key, required List savedRecipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User Profile Content Here'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedRecipesPage(
                      savedRecipes: [],
                    ), // Ваша сторінка "SavedRecipesPage"
                  ),
                );
              },
              child: const Text('Перейти до збережених рецептів'),
            ),
          ],
        ),
      ),
    );
  }
}
