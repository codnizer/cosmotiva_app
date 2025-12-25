import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:cosmotiva/presentation/viewmodels/profile_viewmodel.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:cosmotiva/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    final profileAsync = user != null 
        ? ref.watch(userProfileStreamProvider(user.uid))
        : const AsyncValue.data(null);
        
    final controller = ref.read(profileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      appBar: AppBar(
        title: const Text('Profile & Preferences'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text("User not logged in"));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Info
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.neonViolet,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(profile.name, style: AppTextStyles.headerMedium),
                    Text(profile.email, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.neonTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.neonTeal),
                      ),
                      child: Text(
                        "Credits: ${profile.dailyCredits}/5",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neonTeal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Skin Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['Normal', 'Oily', 'Dry', 'Combination', 'Sensitive'].map((type) {
                  final isSelected = profile.skinType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        controller.updateSkinType(profile, type);
                      }
                    },
                    selectedColor: AppColors.neonViolet,
                    backgroundColor: AppColors.glassBorder,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Allergies / Avoid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: profile.allergies.map((allergy) {
                  return Chip(
                    label: Text(allergy),
                    onDeleted: () => controller.removeAllergy(profile, allergy),
                    backgroundColor: AppColors.glassBorder,
                    labelStyle: const TextStyle(color: AppColors.textPrimary),
                    deleteIconColor: Colors.white70,
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddAllergyDialog(context, controller, profile);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Allergy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.glassBorder,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              
              // Logout Button
              ElevatedButton(
                onPressed: () async {
                  await controller.logout();
                  // AuthWrapper will handle navigation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Logout"),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.neonViolet)),
        error: (e, st) => Center(child: Text("Error: $e", style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  void _showAddAllergyDialog(BuildContext context, ProfileController controller, UserProfile profile) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.midnightBlue,
        title: const Text('Add Allergy', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g. Parabens',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.neonViolet)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              final controllerText = textController.text;
              if (controllerText.isNotEmpty) {
                controller.addAllergy(profile, controllerText);
                Navigator.pop(context);
              }
            },
            child: const Text('Add', style: TextStyle(color: AppColors.neonViolet)),
          ),
        ],
      ),
    );
  }
}
