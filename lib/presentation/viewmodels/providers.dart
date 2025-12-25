import 'package:cosmotiva/core/constants.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';

import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/repositories/product_repository.dart';
import 'package:cosmotiva/services/gemini_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cosmotiva/services/auth_service.dart';
import 'package:cosmotiva/services/ad_service.dart';
import 'package:cosmotiva/data/repositories/firestore_product_repository.dart';
import 'package:cosmotiva/domain/repositories/user_repository.dart';
import 'package:cosmotiva/data/repositories/firestore_user_repository.dart';

final dioProvider = Provider((ref) => Dio());

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final geminiServiceProvider = Provider((ref) {
  return GeminiService(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});

final authServiceProvider = Provider((ref) => AuthService());
final adServiceProvider = Provider((ref) => AdService());

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final firebaseStorageProvider = Provider((ref) => FirebaseStorage.instance);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return FirestoreProductRepository(
    ref.watch(geminiServiceProvider),
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseStorageProvider),
  );
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirestoreUserRepository(ref.watch(firestoreProvider));
});

final favoritesStreamProvider = StreamProvider<List<Product>>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return Stream.value([]);

  return ref.watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  });
});

final userProfileStreamProvider = StreamProvider.family<UserProfile?, String>((ref, uid) {
  return ref.watch(firestoreProvider)
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists && snapshot.data() != null) {
      return UserProfile.fromMap(snapshot.data()!);
    }
    return null;
  });
});

final historyStreamProvider = StreamProvider<List<Product>>((ref) {
  final user = ref.watch(authServiceProvider).currentUser;
  if (user == null) return Stream.value([]);

  return ref.watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .collection('history')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  });
});

final onboardingCompletedProvider = StateProvider<bool>((ref) => false);
