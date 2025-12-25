import 'package:cosmotiva/domain/entities/product.dart';
import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ingredients.map((ingredient) {
            return Chip(
              label: Text(ingredient.name),
              backgroundColor: ingredient.isHarmful ? Colors.red[100] : Colors.green[100],
              labelStyle: TextStyle(
                color: ingredient.isHarmful ? Colors.red[900] : Colors.green[900],
              ),
              avatar: ingredient.isHarmful
                  ? Icon(Icons.warning, size: 16, color: Colors.red[900])
                  : Icon(Icons.check, size: 16, color: Colors.green[900]),
            );
          }).toList(),
        ),
      ],
    );
  }
}
