import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  const Category(this.category, this.color);

  final String category;
  final Color color;
}

class ShoppingItem {
  const ShoppingItem({
    this.quantity = '1',
    required this.category,
    required this.name,
  });

  final String quantity;
  final Category category;
  final String name;
}
