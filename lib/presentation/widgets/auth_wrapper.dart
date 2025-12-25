import 'package:cosmotiva/presentation/pages/auth_page.dart';
import 'package:cosmotiva/presentation/pages/main_page.dart';
import 'package:cosmotiva/presentation/pages/onboarding_page.dart';
import 'package:cosmotiva/presentation/pages/profile_setup_page.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          final userProfileAsync = ref.watch(userProfileStreamProvider(user.uid));
          
          return userProfileAsync.when(
            data: (profile) {
              if (profile == null) {
                return const ProfileSetupPage();
              } else {
                return const MainPage();
              }
            },
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (e, s) => Scaffold(body: Center(child: Text('Error: $e'))),
          );
        } else {
          final onboardingCompleted = ref.watch(onboardingCompletedProvider);
          if (onboardingCompleted) {
            return const AuthPage();
          } else {
            return const OnboardingPage();
          }
        }
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

final authStateChangesProvider = StreamProvider<dynamic>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
