import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:cosmotiva/presentation/pages/main_page.dart';
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  final _nameController = TextEditingController();
  final _allergyController = TextEditingController();
  
  bool _isLoading = false;
  String _selectedSkinType = 'Normal';
  final List<String> _skinTypes = ['Normal', 'Oily', 'Dry', 'Combination', 'Sensitive'];
  final List<String> _allergies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.voidBlack, AppColors.midnightBlue],
                ),
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      border: Border.all(color: AppColors.glassBorder),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Complete Profile",
                          style: AppTextStyles.headerMedium,
                        ),
                        const SizedBox(height: 24),
                        
                        _buildTextField(
                          controller: _nameController,
                          label: "Full Name",
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 24),

                        Text("Skin Type", style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _skinTypes.map((type) {
                            final isSelected = _selectedSkinType == type;
                            return ChoiceChip(
                              label: Text(type),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedSkinType = type;
                                });
                              },
                              selectedColor: AppColors.neonViolet,
                              backgroundColor: AppColors.glassBorder,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text("Allergies", style: AppTextStyles.bodyLarge),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _allergyController,
                                label: "Add Allergy",
                                icon: Icons.warning,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: AppColors.neonTeal),
                              onPressed: () {
                                if (_allergyController.text.isNotEmpty) {
                                  setState(() {
                                    _allergies.add(_allergyController.text);
                                    _allergyController.clear();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _allergies.map((allergy) {
                            return Chip(
                              label: Text(allergy),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  _allergies.remove(allergy);
                                });
                              },
                              backgroundColor: AppColors.glassBorder,
                              labelStyle: const TextStyle(color: AppColors.textPrimary),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator(color: AppColors.neonViolet))
                        else
                          _buildButton(
                            text: "Finish Setup",
                            onTap: _submitProfile,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonViolet),
        ),
        filled: true,
        fillColor: AppColors.glassWhite,
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.neonViolet,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonViolet.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonText,
          ),
        ),
      ),
    );
  }

  Future<void> _submitProfile() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw "User not found";

      final userProfile = UserProfile(
        uid: user.uid,
        email: user.email!,
        name: _nameController.text.trim(),
        skinType: _selectedSkinType,
        allergies: _allergies,
        dailyCredits: 5,
        lastResetDate: DateTime.now(),
      );

      await ref.read(userRepositoryProvider).saveUserProfile(userProfile);
      
      // No manual navigation needed, AuthWrapper will see the profile and switch to MainPage
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
