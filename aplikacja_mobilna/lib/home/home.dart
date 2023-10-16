import 'package:aplikacja_mobilna/home/recipe/add_recipe_page.dart';
import 'package:aplikacja_mobilna/home/recipe/recipe_page.dart';
import 'package:aplikacja_mobilna/home/user/user_page.dart';
import 'package:aplikacja_mobilna/menu/desert.dart';
import 'package:aplikacja_mobilna/menu/kolacja.dart';
import 'package:aplikacja_mobilna/menu/obiad.dart';
import 'package:aplikacja_mobilna/menu/settings.dart';
import 'package:aplikacja_mobilna/menu/sniadania.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeRecipePage extends StatefulWidget {
  final List<Map<String, dynamic>> savedRecipes = [];

  HomeRecipePage({Key? key}) : super(key: key);

  @override
  State<HomeRecipePage> createState() => _HomeRecipePageState();
}

class _HomeRecipePageState extends State<HomeRecipePage> {
  TextEditingController searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference recipeRef =
      FirebaseDatabase.instance.ref().child('recipes');

  List<Map<dynamic, dynamic>> allRecipes = [];
  List<Map<dynamic, dynamic>> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();

    recipeRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          allRecipes = List<Map<dynamic, dynamic>>.from(
              (event.snapshot.value as Map).values);
          updateFilteredRecipes();
        });
      }
    });
  }

  void updateFilteredRecipes() {
    final searchValue = searchController.text.toLowerCase();
    setState(() {
      if (searchValue.isEmpty) {
        filteredRecipes = List<Map<dynamic, dynamic>>.from(allRecipes);
      } else {
        filteredRecipes = allRecipes.where((recipe) {
          final title = recipe['title'].toString().toLowerCase();
          return title.contains(searchValue);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(user.email!),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const UserPage(
                        savedRecipes: [],
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  child: Text("C"),
                ),
              ),
              accountName: null,
            ),
            ListTile(
              title: const Text("Sniadania"),
              trailing: const Icon(Icons.bakery_dining_outlined),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Sniadania(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Obiad"),
              trailing: const Icon(Icons.lunch_dining_outlined),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Obiad(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Kolacja"),
              trailing: const Icon(Icons.dinner_dining),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Kolacja(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Desert"),
              trailing: const Icon(Icons.cake),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Desert(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Settings"),
              trailing: const Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const Settings("Settings"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('YummyYummy'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRecipePage()),
              );
            },
            child: const Text('+'),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search for recipes',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                updateFilteredRecipes();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipeData = filteredRecipes[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        recipeData['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            recipeData['photoUrl'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipePage(
                                title: recipeData['title'],
                                imageUrl: recipeData['photoUrl'],
                                ingredients:
                                    List.from(recipeData['ingredients']),
                                instructions: recipeData['instructions'],
                                recipeType: recipeData['recipeType'],
                                comments: const [],
                              ),
                            ),
                          );
                        },
                        child: const Text('View'),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
