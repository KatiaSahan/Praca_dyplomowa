import 'package:aplikacja_mobilna/home/add_recipe_page.dart';
import 'package:aplikacja_mobilna/menu/desert.dart';
import 'package:aplikacja_mobilna/menu/kolacja.dart';
import 'package:aplikacja_mobilna/menu/obiad.dart';
import 'package:aplikacja_mobilna/menu/settings.dart';
import 'package:aplikacja_mobilna/menu/sniadania.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference recipeRef =
      FirebaseDatabase.instance.ref().child('recipes');

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо Firebase
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // меню бокове
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              //accountName: const Text("Marina Clark"),
              accountEmail: Text(user.email!),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 10, 0, 116),
                child: Text("C"),
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
              decoration: const InputDecoration(
                hintText: 'Search for recipes',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {},
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: recipeRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                final recipeData = snapshot.value as Map<dynamic, dynamic>?;
                if (recipeData != null) {
                  return ListTile(
                    title: Text(recipeData['title'] ?? ''),
                    leading: Image.network(recipeData['photoUrl'] ?? ''),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Додайте код для переходу до сторінки з деталями рецепту
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
