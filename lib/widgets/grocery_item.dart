import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class ShoppingItem extends StatelessWidget {
  const ShoppingItem({required this.groceryItem, super.key});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: groceryItem.category.color,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          groceryItem.name,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        Text(
          groceryItem.quantity.toString(),
        )
      ],
    );
  }
}
