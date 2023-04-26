import 'package:aplikacja_mobilna/menu/desert.dart';
import 'package:aplikacja_mobilna/menu/kolacja.dart';
import 'package:aplikacja_mobilna/menu/obiad.dart';
import 'package:aplikacja_mobilna/menu/sniadania.dart';
import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // меню бокове
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Marina Clark"),
              accountEmail: Text("marinaclark@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 0, 229, 255),
                child: Text("M"),
              ),
            ),
            ListTile(
                title: const Text("Sniadania"),
                trailing: const Icon(Icons.bakery_dining_outlined),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const Sniadania("Sniadania")));
                }),
            ListTile(
                title: const Text("Obiad"),
                trailing: const Icon(Icons.lunch_dining_outlined),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const Obiad("Obiad")));
                }),
            ListTile(
                title: const Text("Kolacja"),
                trailing: const Icon(Icons.dinner_dining),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const Kolacja("Kolacja")));
                }),
            ListTile(
                title: const Text("Desert"),
                trailing: const Icon(Icons.cake),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const Desert("Desert")));
                }),
            const Divider(),
            const ListTile(
              title: Text("Setting"),
              trailing: Icon(Icons.settings),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('YummyYummy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
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
            child: ListView.builder(
              itemCount: 10, // replace with actual number of recipes
              itemBuilder: (context, index) {
                return ListTile(
                  //  leading: Image.network(
                  //     'https://via.placeholder.com/150x150.png?text=Recipe+Image'),
                  title: const Text('Recipe Title'),
                  subtitle: const Text('Preparation time: 30 minutes'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
