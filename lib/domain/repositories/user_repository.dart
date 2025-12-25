import 'package:cosmotiva/domain/entities/user_profile.dart';

abstract class UserRepository {
  Future<void> saveUserProfile(UserProfile user);
  Future<UserProfile?> getUserProfile(String uid);
  Future<bool> checkAndDecrementCredits(String uid);
  Future<void> incrementCredits(String uid);
}
