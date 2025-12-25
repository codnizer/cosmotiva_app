import 'package:cosmotiva/core/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/presentation/pages/main_page.dart';
import 'package:cosmotiva/presentation/widgets/auth_wrapper.dart';
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cosmotiva/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  MobileAds.instance.initialize();

  const secureStorage = FlutterSecureStorage();
  await secureStorage.write(
      key: AppConstants.GEMINI_API_KEY_STORAGE_KEY,
      value: AppConstants.HARDCODED_API_KEY);

  runApp(const ProviderScope(child: CosmotivaApp()));
}

class CosmotivaApp extends StatelessWidget {
  const CosmotivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmotiva',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AuthWrapper(),
    );
  }
}
