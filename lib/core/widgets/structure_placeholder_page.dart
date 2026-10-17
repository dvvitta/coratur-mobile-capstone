import 'package:flutter/material.dart';

import '../responsive/responsive_page_container.dart';

/// Halaman sementara untuk menandai folder/rute yang sudah ada.
/// Bukan layar produk; akan diganti saat UI masing-masing fitur dibuat.
class StructurePlaceholderPage extends StatelessWidget {
  const StructurePlaceholderPage({
    super.key,
    required this.title,
    required this.routeName,
  });

  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsivePageContainer(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SKETCHOO',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(title, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(routeName, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  const Text('Mode pengembangan: struktur folder'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
