import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:cosmotiva/domain/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserRepository(this._firestore);

  @override
  Future<void> saveUserProfile(UserProfile user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  @override
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Future<bool> checkAndDecrementCredits(String uid) async {
    final userRef = _firestore.collection('users').doc(uid);
    
    return await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      
      if (!snapshot.exists) return false;
      
      final data = snapshot.data()!;
      final currentCredits = data['dailyCredits'] as int;
      final lastResetString = data['lastResetDate'] as String;
      final lastResetDate = DateTime.parse(lastResetString);
      final now = DateTime.now();
      
      // Check if we need to reset (if last reset was not today)
      bool needsReset = lastResetDate.year != now.year ||
          lastResetDate.month != now.month ||
          lastResetDate.day != now.day;
          
      if (needsReset) {
        // Reset to 5 credits (minus 1 for this scan)
        transaction.update(userRef, {
          'dailyCredits': 4,
          'lastResetDate': now.toIso8601String(),
        });
        return true;
      } else {
        if (currentCredits > 0) {
          transaction.update(userRef, {
            'dailyCredits': currentCredits - 1,
          });
          return true;
        } else {
          return false;
        }
      }
    });
  }

  @override
  Future<void> incrementCredits(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'dailyCredits': FieldValue.increment(1),
    });
  }
}
