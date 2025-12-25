import 'dart:io';
import 'package:cosmotiva/data/repositories/product_repository_impl.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([GeminiService, Box])
void main() {
  late ProductRepositoryImpl repository;
  late MockGeminiService mockGeminiService;
  late MockBox<Product> mockProductBox;
  late MockBox<Product> mockFavoritesBox;

  setUp(() {
    mockGeminiService = MockGeminiService();
    mockProductBox = MockBox<Product>();
    mockFavoritesBox = MockBox<Product>();
    repository = ProductRepositoryImpl(mockGeminiService, mockProductBox, mockFavoritesBox);
  });

  final tProduct = Product(
    id: '1',
    name: 'Test Product',
    ingredients: [],
    score: 90,
    riskLevel: 'Low',
    skinCompatibility: [],
    alternatives: [],
    timestamp: DateTime.now(),
  );

  test('analyzeImage should return product and save to history', () async {
    // Arrange
    final tFile = File('test.jpg');
    when(mockGeminiService.analyzeImage(any)).thenAnswer((_) async => tProduct);
    when(mockProductBox.put(any, any)).thenAnswer((_) async => {});

    // Act
    final result = await repository.analyzeImage(tFile);

    // Assert
    expect(result, tProduct);
    verify(mockGeminiService.analyzeImage(tFile));
    verify(mockProductBox.put(tProduct.id, tProduct));
  });
}
