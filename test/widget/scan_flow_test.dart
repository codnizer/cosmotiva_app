import 'dart:io';

import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/repositories/product_repository.dart';
import 'package:cosmotiva/presentation/pages/scan_page.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProductRepository implements ProductRepository {
  @override
  Future<Product> analyzeImage(File image) async {
    return Product(
      id: '1',
      name: 'Test Product',
      ingredients: [],
      score: 90,
      riskLevel: 'Low',
      skinCompatibility: [],
      alternatives: [],
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<List<Product>> getFavorites() async => [];

  @override
  Future<List<Product>> getHistory() async => [];

  @override
  Future<void> saveProduct(Product product) async {}

  @override
  Future<void> toggleFavorite(Product product) async {}
}

void main() {
  testWidgets('ScanPage shows scan buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productRepositoryProvider.overrideWithValue(FakeProductRepository()),
        ],
        child: const MaterialApp(
          home: ScanPage(),
        ),
      ),
    );

    expect(find.text('Scan with Camera'), findsOneWidget);
    expect(find.text('Upload from Gallery'), findsOneWidget);
    expect(find.text('Cosmotiva'), findsOneWidget);
  });
}
