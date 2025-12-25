import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:cosmotiva/domain/repositories/product_repository.dart';
import 'package:cosmotiva/services/gemini_service.dart';

class FirestoreProductRepository implements ProductRepository {
  final GeminiService _geminiService;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  FirestoreProductRepository(
    this._geminiService,
    this._firestore,
    this._auth,
    this._storage,
  );

  String? get _userId => _auth.currentUser?.uid;

  @override
  Future<Product> analyzeImage(File image, UserProfile user) async {
    final product = await _geminiService.analyzeImage(image, user);
    
    // Upload image to Firebase Storage
    String? imageUrl;
    try {
      final ref = _storage
          .ref()
          .child('users/${user.uid}/products/${product.id}.jpg');
      
      await ref.putFile(image);
      imageUrl = await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      // Fallback to local path if upload fails, but this won't work cross-device
      imageUrl = image.path;
    }

    final productWithImage = product.copyWith(imagePath: imageUrl);
    
    // Save to user's history using the passed user profile
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .doc(product.id)
        .set(productWithImage.toMap());
        
    return productWithImage;
  }

  @override
  Future<void> saveProduct(Product product) async {
    final uid = _userId;
    if (uid == null) return; // Or throw exception

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .doc(product.id)
        .set(product.toMap());
  }

  @override
  Future<List<Product>> getHistory() async {
    final uid = _userId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }

  @override
  Future<void> toggleFavorite(Product product) async {
    final uid = _userId;
    if (uid == null) return;

    final favoriteRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(product.id);

    final doc = await favoriteRef.get();
    if (doc.exists) {
      await favoriteRef.delete();
    } else {
      await favoriteRef.set(product.toMap());
    }
  }

  @override
  Future<List<Product>> getFavorites() async {
    final uid = _userId;
    if (uid == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }
}
