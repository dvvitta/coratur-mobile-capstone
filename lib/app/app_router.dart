import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/structure_placeholder_page.dart';
import '../features/authentication/models/auth_tab.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/splash/screens/splash_screen.dart';

/// Peta rute konseptual. Halaman penuh belum diimplementasikan;
/// setiap rute mengarah ke placeholder struktur sampai UI dibuat.
class AppRouter {
  const AppRouter();

  String get initialRoute => AppRoutes.splash;

  Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.login: (_) => const AuthScreen(),
    AppRoutes.register: (_) =>
        const AuthScreen(initialTab: AuthTab.register),
    AppRoutes.forgotPassword: (_) => const StructurePlaceholderPage(
      title: 'Lupa Password',
      routeName: AppRoutes.forgotPassword,
    ),
    AppRoutes.home: (_) => const StructurePlaceholderPage(
      title: 'Beranda',
      routeName: AppRoutes.home,
    ),
    AppRoutes.sketchChallenge: (_) => const StructurePlaceholderPage(
      title: 'Sketch Challenge',
      routeName: AppRoutes.sketchChallenge,
    ),
    AppRoutes.jelajahCilik: (_) => const StructurePlaceholderPage(
      title: 'Jelajah Cilik',
      routeName: AppRoutes.jelajahCilik,
    ),
    AppRoutes.sketchToStory: (_) => const StructurePlaceholderPage(
      title: 'Sketch-to-Story',
      routeName: AppRoutes.sketchToStory,
    ),
    AppRoutes.history: (_) => const StructurePlaceholderPage(
      title: 'Riwayat',
      routeName: AppRoutes.history,
    ),
    AppRoutes.profile: (_) => const StructurePlaceholderPage(
      title: 'Profil',
      routeName: AppRoutes.profile,
    ),
    AppRoutes.teacher: (_) => const StructurePlaceholderPage(
      title: 'Area Guru',
      routeName: AppRoutes.teacher,
    ),
  };
}
