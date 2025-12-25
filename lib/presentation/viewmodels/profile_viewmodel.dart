import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:cosmotiva/domain/repositories/user_repository.dart';
import 'package:cosmotiva/services/auth_service.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<void>>((ref) {
  return ProfileController(
    ref.watch(userRepositoryProvider),
    ref.watch(authServiceProvider),
  );
});

class ProfileController extends StateNotifier<AsyncValue<void>> {
  final UserRepository _userRepository;
  final AuthService _authService;

  ProfileController(this._userRepository, this._authService) : super(const AsyncValue.data(null));

  Future<void> updateSkinType(UserProfile currentProfile, String skinType) async {
    final updatedProfile = currentProfile.copyWith(skinType: skinType);
    state = const AsyncValue.loading();

    try {
      await _userRepository.saveUserProfile(updatedProfile);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAllergy(UserProfile currentProfile, String allergy) async {
    final updatedAllergies = List<String>.from(currentProfile.allergies)..add(allergy);
    final updatedProfile = currentProfile.copyWith(allergies: updatedAllergies);
    state = const AsyncValue.loading();

    try {
      await _userRepository.saveUserProfile(updatedProfile);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeAllergy(UserProfile currentProfile, String allergy) async {
    final updatedAllergies = List<String>.from(currentProfile.allergies)..remove(allergy);
    final updatedProfile = currentProfile.copyWith(allergies: updatedAllergies);
    state = const AsyncValue.loading();

    try {
      await _userRepository.saveUserProfile(updatedProfile);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}
