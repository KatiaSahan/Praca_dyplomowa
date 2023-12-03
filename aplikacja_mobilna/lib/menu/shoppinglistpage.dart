import 'package:flutter/material.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  List<ShoppingItem> shoppingItems = [];
  TextEditingController itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista zakupów'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: shoppingItems.length,
              itemBuilder: (context, index) {
                final item = shoppingItems[index];
                return ListTile(
                  title: Text(item.name),
                  leading: Checkbox(
                    value: item.isBought,
                    onChanged: (value) {
                      setState(() {
                        item.isBought = value!;
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        shoppingItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: itemController,
                      decoration: const InputDecoration(
                        hintText: 'Add items',
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final newItemName = itemController.text.trim();
                    if (newItemName.isNotEmpty) {
                      setState(() {
                        shoppingItems.add(ShoppingItem(newItemName, false));
                        itemController.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingItem {
  final String name;
  bool isBought;

  ShoppingItem(this.name, this.isBought);
}
