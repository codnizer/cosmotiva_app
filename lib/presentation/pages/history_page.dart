import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/presentation/pages/product_page.dart';
import 'package:cosmotiva/presentation/viewmodels/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: historyAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No scan history'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imagePath != null
                    ? SizedBox(
                        width: 50,
                        height: 50,
                        child: product.imagePath!.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: product.imagePath!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              )
                            : Image.file(File(product.imagePath!), fit: BoxFit.cover),
                      )
                    : const Icon(Icons.image),
                title: Text(product.name),
                subtitle: Text(product.timestamp.toString().split('.')[0]),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductPage(product: product)),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

