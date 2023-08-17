import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../recipe/recipe_page.dart';

class UserPage extends StatefulWidget {
  final List<Map<String, dynamic>> savedRecipes;
  final List<Map<String, dynamic>> addedRecipes;

  const UserPage({
    Key? key,
    required this.savedRecipes,
    required this.addedRecipes,
  }) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Account'),
              Tab(text: 'Saved Recipe'),
              Tab(text: 'Added Recipe'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(
              child: Text('Account Tab Content'),
            ),
            SavedRecipesTab(savedRecipes: widget.savedRecipes),
            AddedRecipesTab(addedRecipes: widget.addedRecipes),
          ],
        ),
      ),
    );
  }
}

class SavedRecipesTab extends StatelessWidget {
  final List<Map<String, dynamic>> savedRecipes;

  const SavedRecipesTab({
    Key? key,
    required this.savedRecipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(savedRecipes);
    }
    return ListView.builder(
      itemCount: savedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = savedRecipes[index];
        ListTile(
          title: Row(
            children: [
              Text(recipe['title']),
              const SizedBox(width: 10),
              Image.network(
                recipe['photoUrl'] ?? '',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ],
          ),
          onTap: () {
            // Викликаємо сторінку з деталями рецепту та передаємо йому дані
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(
                  title: recipe['title'],
                  ingredients: recipe['ingredients'],
                  instructions: recipe['instructions'],
                  imageUrl: recipe['imageUrl'],
                  recipeType: recipe['recipeType'],
                ),
              ),
            );
          },
        );
        return null;
      },
    );
  }
}

class AddedRecipesTab extends StatelessWidget {
  final List<Map<String, dynamic>> addedRecipes;

  const AddedRecipesTab({
    Key? key,
    required this.addedRecipes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = addedRecipes[index];
        return ListTile(
          title: Row(
            children: [
              Text(recipe['title']),
              const SizedBox(width: 10),
              Image.network(
                recipe['photoUrl'] ?? '',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(
                  title: recipe['title'],
                  ingredients: recipe['ingredients'],
                  instructions: recipe['instructions'],
                  imageUrl: recipe['imageUrl'],
                  recipeType: recipe['recipeType'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
