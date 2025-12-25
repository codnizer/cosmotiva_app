import 'dart:io';
import 'package:cosmotiva/core/errors/exceptions.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/repositories/product_repository.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:cosmotiva/services/image_processing_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cosmotiva/domain/repositories/user_repository.dart';
import 'package:cosmotiva/services/auth_service.dart';

final scanViewModelProvider = StateNotifierProvider<ScanViewModel, ScanState>((ref) {
  return ScanViewModel(
    ref.watch(productRepositoryProvider),
    ImageProcessingService(),
    ref.watch(userRepositoryProvider),
    ref.watch(authServiceProvider),
  );
});

abstract class ScanState {}

class ScanInitial extends ScanState {}
class ScanLoading extends ScanState {}
class ScanSuccess extends ScanState {
  final Product product;
  ScanSuccess(this.product);
}
class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}

class ScanViewModel extends StateNotifier<ScanState> {
  final ProductRepository _repository;
  final ImageProcessingService _imageProcessingService;
  final UserRepository _userRepository;
  final AuthService _authService;
  final ImagePicker _picker = ImagePicker();

  ScanViewModel(
    this._repository,
    this._imageProcessingService,
    this._userRepository,
    this._authService,
  ) : super(ScanInitial());

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        state = ScanLoading();
        final File imageFile = File(pickedFile.path);
        
        // 1. Check User & Credits
        final user = _authService.currentUser;
        if (user == null) {
          state = ScanError("Please login to scan products.");
          return;
        }

        final hasCredits = await _userRepository.checkAndDecrementCredits(user.uid);
        if (!hasCredits) {
          state = ScanError("Daily scan limit reached. Come back tomorrow!");
          return;
        }

        // 2. Fetch User Profile for Personalization
        final userProfile = await _userRepository.getUserProfile(user.uid);
        if (userProfile == null) {
          state = ScanError("User profile not found.");
          return;
        }

        // 3. Process Image
        final processedImage = await _imageProcessingService.processImage(imageFile);
        
        // 4. Analyze with Personalization
        final product = await _repository.analyzeImage(processedImage, userProfile);
        state = ScanSuccess(product);
      }
    } catch (e) {
      if (e is ApiKeyMissingException) {
        state = ScanError('Gemini API Key is missing. Please set it in settings.');
      } else if (e is GeminiAnalysisException) {
        state = ScanError(e.message);
      } else {
        state = ScanError('An unexpected error occurred: $e');
      }
    }
  }
  
  void reset() {
    state = ScanInitial();
  }
}
