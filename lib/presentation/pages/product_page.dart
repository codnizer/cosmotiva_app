import 'dart:io';
import 'dart:ui';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/presentation/theme/app_theme.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:cosmotiva/presentation/widgets/ingredient_list.dart';
import 'package:cosmotiva/presentation/widgets/neo_glass.dart';
import 'package:cosmotiva/presentation/widgets/risk_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductPage extends ConsumerWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesStreamProvider);
    final isFavorite = favoritesAsync.maybeWhen(
      data: (products) => products.any((p) => p.id == product.id),
      orElse: () => false,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('ANALYSIS RESULT', style: AppTextStyles.headerMedium.copyWith(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? AppColors.neonViolet : Colors.white,
            onPressed: () {
              ref.read(productRepositoryProvider).toggleFavorite(product);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {
              // Share logic
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.midnightBlue, AppColors.voidBlack],
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: product.id,
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonViolet.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: -10,
                          ),
                        ],
                        image: product.imagePath != null
                            ? DecorationImage(
                                image: product.imagePath!.startsWith('http')
                                    ? CachedNetworkImageProvider(product.imagePath!)
                                    : FileImage(File(product.imagePath!)) as ImageProvider, 
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: product.imagePath == null
                          ? const Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.white54)
                          : null,
                    ),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 30),
                
                Text(
                  product.name,
                  style: AppTextStyles.headerLarge,
                ).animate().fadeIn().slideX(),
                
                const SizedBox(height: 20),
                
                NeoGlassContainer(
                  child: RiskBar(score: product.score, riskLevel: product.riskLevel),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 20),
                
                NeoGlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INGREDIENTS', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neonTeal, letterSpacing: 1.5)),
                      const SizedBox(height: 10),
                      IngredientList(ingredients: product.ingredients),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 20),
                
                Text(
                  'SKIN COMPATIBILITY',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54, letterSpacing: 1.5),
                ).animate().fadeIn(delay: 600.ms),
                
                const SizedBox(height: 10),
                
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: product.skinCompatibility.map((type) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.neonTeal.withOpacity(0.1),
                        border: Border.all(color: AppColors.neonTeal.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neonTeal),
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 700.ms),
                
                const SizedBox(height: 30),
                
                if (product.alternatives.isNotEmpty) ...[
                  Text(
                    'BETTER ALTERNATIVES',
                    style: AppTextStyles.headerMedium.copyWith(fontSize: 20),
                  ).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 15),
                  ...product.alternatives.map((alt) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NeoGlassContainer(
                        padding: const EdgeInsets.all(12),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.thumb_up, color: Colors.green, size: 20),
                          ),
                          title: Text(alt.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text(alt.reason, style: AppTextStyles.bodyMedium),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                        ),
                      ),
                    );
                  }).toList().animate(interval: 100.ms).fadeIn().slideX(begin: 0.2, end: 0),
                ],
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
