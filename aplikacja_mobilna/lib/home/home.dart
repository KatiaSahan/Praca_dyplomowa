import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(),
      ),
      appBar: AppBar(
        title: const Text('        YummyYummy'),
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
