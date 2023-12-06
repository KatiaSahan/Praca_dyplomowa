import 'dart:math';

import 'package:aplikacja_mobilna/home/recipe/add_recipe_page.dart';
import 'package:aplikacja_mobilna/home/recipe/recipe_page.dart';
import 'package:aplikacja_mobilna/menu/desert.dart';
import 'package:aplikacja_mobilna/menu/kolacja.dart';
import 'package:aplikacja_mobilna/menu/obiad.dart';
import 'package:aplikacja_mobilna/menu/settings.dart';
import 'package:aplikacja_mobilna/menu/sniadania.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../menu/shoppinglistpage.dart';

class HomeRecipePage extends StatefulWidget {
  final List<Map<String, dynamic>> savedRecipes = [];

  HomeRecipePage({super.key});

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
          updateRandomRecipes();
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

  void updateRandomRecipes() {
    final random = Random();

    allRecipes.shuffle(random);

    final randomRecipesList = allRecipes.take(50).toList();

    setState(() {
      filteredRecipes = List<Map<dynamic, dynamic>>.from(randomRecipesList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Transform.translate(
                offset:
                    const Offset(0, -10), // Зміщуємо текст вгору на 50 пікселів
                child: Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              currentAccountPicture: GestureDetector(
                child: Container(
                    //  decoration: const BoxDecoration(
                    //   color: Color.fromARGB(255, 255, 255, 255),
                    ////   shape: BoxShape.circle,
                    // ),
                    // child: const Icon(
                    //   Icons.account_circle,
                    //   size: 64,
                    //   color: Colors.grey,
                    // ),
                    ),
              ),
              accountName: null,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://kor.ill.in.ua/m/610x385/2805833.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
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
              title: const Text("Lista zakupów"),
              trailing: const Icon(Icons.shopping_cart),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ShoppingListPage(),
                  ),
                );
              },
            ),
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
        title: const Text('YummyYummy', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(248, 103, 16, 216),
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
      body: SafeArea(
        child: Column(
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
      ),
    );
  }
}
