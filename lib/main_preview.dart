/// Entry point khusus preview UI — JANGAN dipakai di production.
/// Jalankan dengan: flutter run -t lib/main_preview.dart
library;

import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/curator_bottom_nav.dart';
import 'features/main/screens/main_navigation_shell.dart';

void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preview — Leaderboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MainNavigationShell(initialIndex: NavIndex.leaderboard),
    );
  }
}
