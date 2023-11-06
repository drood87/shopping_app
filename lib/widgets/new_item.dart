import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';


class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

// Quantity: String '1',
// Type: Category Category.fruit
// Name: String 'Bananas'

class _NewItemState extends State<NewItem> {
  // assigns a global key to save state in the form
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  late Category _enteredType = categories[Categories.fruit]!;
  var _enteredQuantity = 1;

// when executing this method all inputs in the form
//get validated and throw errors if validation fails!
  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //The second arguments defines the 'path', usually what comes after the / [slash],
      //where the data is going to be stored (folder)
      var url = Uri.https(
          'flutter-prep-80f29-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _enteredType.category,
          },
        ),
      );

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // instead of TextField()
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          // ! cause flutter does not know
                          //about the previous condition that it
                          //can't be null
                          return 'Must be a valid, positive number!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _enteredType,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.category)
                              ],
                            ),
                          )
                      ],
                      // the onSaved metod is not necessary there
                      //as the onChanged method already stores the value

                      // onSaved: (value) {
                      //   _enteredType = value!;
                      // },
                      onChanged: (value) {
                        setState(() {
                          _enteredType = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        label: Text('Type'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
