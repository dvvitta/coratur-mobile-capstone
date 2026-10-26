import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/structure_placeholder_page.dart';
import '../features/authentication/controllers/auth_controller.dart';
import '../features/authentication/models/auth_tab.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/verify_reset_code_screen.dart';
import '../features/main/screens/main_navigation_shell.dart';
import '../features/missions/screens/missions_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/sketch_challenge/screens/sketch_challenge_level_screen.dart';
import '../features/sketch_challenge/screens/sketch_challenge_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import 'app_dependencies.dart';

/// Peta rute konseptual. Halaman penuh belum diimplementasikan;
/// setiap rute mengarah ke placeholder struktur sampai UI dibuat.
class AppRouter {
  const AppRouter({this.dependencies});

  final AppDependencies? dependencies;

  String get initialRoute => AppRoutes.splash;

  Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.login: (_) => AuthScreen(
      controller: dependencies != null
          ? AuthController(
              repository: dependencies!.authRepository,
              onUserAuthenticated: (user) =>
                  dependencies!.sessionStore.setUser(user),
            )
          : null,
    ),
    AppRoutes.register: (_) => AuthScreen(
      initialTab: AuthTab.register,
      controller: dependencies != null
          ? AuthController(
              repository: dependencies!.authRepository,
              onUserAuthenticated: (user) =>
                  dependencies!.sessionStore.setUser(user),
            )
          : null,
    ),
    AppRoutes.forgotPassword: (_) => ForgotPasswordScreen(
      authRepository: dependencies?.authRepository,
    ),
    AppRoutes.verifyResetCode: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return VerifyResetCodeScreen(
        email: email ?? 'psyy@gmail.com',
        authRepository: dependencies?.authRepository,
      );
    },
    AppRoutes.home: (_) => AnimatedBuilder(
      animation: dependencies?.sessionStore ?? Listenable.merge([]),
      builder: (_, __) => MainNavigationShell(
        userName: dependencies?.sessionStore.displayName,
      ),
    ),
    AppRoutes.missions: (_) => const MissionsScreen(),
    AppRoutes.sketchChallenge: (_) => const SketchChallengeScreen(),
    AppRoutes.sketchChallengeLevels: (_) => const SketchChallengeLevelScreen(),
    AppRoutes.jelajahCilik: (_) => const StructurePlaceholderPage(
      title: 'Jelajah Cilik',
      routeName: AppRoutes.jelajahCilik,
    ),
    AppRoutes.sketchToStory: (_) => const StructurePlaceholderPage(
      title: 'Sketch-to-Story',
      routeName: AppRoutes.sketchToStory,
    ),
    AppRoutes.history: (_) => AnimatedBuilder(
      animation: dependencies?.sessionStore ?? Listenable.merge([]),
      builder: (_, __) => MainNavigationShell(
        initialIndex: 1,
        userName: dependencies?.sessionStore.displayName,
      ),
    ),
    AppRoutes.profile: (_) => AnimatedBuilder(
      animation: dependencies?.sessionStore ?? Listenable.merge([]),
      builder: (_, __) => MainNavigationShell(
        initialIndex: 2,
        userName: dependencies?.sessionStore.displayName,
      ),
    ),
    AppRoutes.teacher: (_) => const StructurePlaceholderPage(
      title: 'Area Guru',
      routeName: AppRoutes.teacher,
    ),
  };
}
