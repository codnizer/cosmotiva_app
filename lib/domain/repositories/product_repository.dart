import 'dart:io';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';

abstract class ProductRepository {
  Future<Product> analyzeImage(File image, UserProfile user);
  Future<void> saveProduct(Product product);
  Future<List<Product>> getHistory();
  Future<void> toggleFavorite(Product product);
  Future<List<Product>> getFavorites();
}
