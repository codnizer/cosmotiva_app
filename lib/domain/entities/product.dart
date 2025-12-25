import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String? imagePath;
  final List<Ingredient> ingredients;
  final double score; // 0 to 100
  final String riskLevel; // Low, Moderate, High
  final List<String> skinCompatibility;
  final List<ProductSuggestion> alternatives;
  final DateTime timestamp;

  Product({
    required this.id,
    required this.name,
    this.imagePath,
    required this.ingredients,
    required this.score,
    required this.riskLevel,
    required this.skinCompatibility,
    required this.alternatives,
    required this.timestamp,
  });

  Product copyWith({
    String? id,
    String? name,
    String? imagePath,
    List<Ingredient>? ingredients,
    double? score,
    String? riskLevel,
    List<String>? skinCompatibility,
    List<ProductSuggestion>? alternatives,
    DateTime? timestamp,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      score: score ?? this.score,
      riskLevel: riskLevel ?? this.riskLevel,
      skinCompatibility: skinCompatibility ?? this.skinCompatibility,
      alternatives: alternatives ?? this.alternatives,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'ingredients': ingredients.map((x) => x.toMap()).toList(),
      'score': score,
      'riskLevel': riskLevel,
      'skinCompatibility': skinCompatibility,
      'alternatives': alternatives.map((x) => x.toMap()).toList(),
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imagePath: map['imagePath'],
      ingredients: List<Ingredient>.from(
          map['ingredients']?.map((x) => Ingredient.fromMap(x)) ?? []),
      score: (map['score'] ?? 0.0).toDouble(),
      riskLevel: map['riskLevel'] ?? '',
      skinCompatibility: List<String>.from(map['skinCompatibility'] ?? []),
      alternatives: List<ProductSuggestion>.from(
          map['alternatives']?.map((x) => ProductSuggestion.fromMap(x)) ?? []),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

class Ingredient {
  final String name;
  final bool isHarmful;
  final String? description;

  Ingredient({
    required this.name,
    required this.isHarmful,
    this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isHarmful': isHarmful,
      'description': description,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      isHarmful: map['isHarmful'] ?? false,
      description: map['description'],
    );
  }
}

class ProductSuggestion {
  final String name;
  final String reason;

  ProductSuggestion({
    required this.name,
    required this.reason,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'reason': reason,
    };
  }

  factory ProductSuggestion.fromMap(Map<String, dynamic> map) {
    return ProductSuggestion(
      name: map['name'] ?? '',
      reason: map['reason'] ?? '',
    );
  }
}
