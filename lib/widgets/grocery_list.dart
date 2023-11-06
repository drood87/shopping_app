import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-prep-80f29-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (category) => category.value.category == item.value['category'],
          )
          .value;

      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void _addItem() async {
    final newShoppingItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newShoppingItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newShoppingItem);
    });
  }

  void _removeShoppingItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: _groceryItems.isEmpty
            ? const Center(
                child: Text(
                  'Such empty, you don\'t need groceries?!',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _groceryItems.length,
                itemBuilder: (ctx, index) {
                  return Dismissible(
                    onDismissed: (direction) {
                      _removeShoppingItem(_groceryItems[index]);
                    },
                    key: ValueKey(_groceryItems[index].id),
                    child: ListTile(
                      title: Text(_groceryItems[index].name),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: _groceryItems[index].category.color,
                      ),
                      trailing: Text(
                        _groceryItems[index].quantity.toString(),
                      ),
                    ),
                  );
                },
              ));
  }
}
