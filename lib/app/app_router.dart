import 'package:flutter/material.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/structure_placeholder_page.dart';
import '../features/authentication/controllers/auth_controller.dart';
import '../features/authentication/models/auth_tab.dart';
import '../features/authentication/screens/auth_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/verify_email_screen.dart';
import '../features/authentication/screens/verify_reset_code_screen.dart';
import '../features/jelajah/screens/hitung_hewan_screen.dart';
import '../features/jelajah/screens/jelajah_screen.dart';
import '../features/jelajah/screens/kenali_huruf_screen.dart';
import '../features/jelajah/screens/tts_voice_debug_screen.dart';
import '../features/main/screens/main_navigation_shell.dart';
import '../features/missions/repositories/mission_repository.dart';
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

  AuthController? _authController() {
    final current = dependencies;
    if (current == null) return null;
    return AuthController(
      repository: current.authRepository,
      onUserAuthenticated: (user, accessToken) =>
          current.sessionStore.setSession(user: user, accessToken: accessToken),
    );
  }

  Widget _mainRoute(int initialIndex) {
    final current = dependencies;
    return AnimatedBuilder(
      animation: current?.sessionStore ?? Listenable.merge([]),
      builder: (context, child) => MainNavigationShell(
        initialIndex: initialIndex,
        userName: current?.sessionStore.displayName,
        missionRepository:
            current?.missionRepository ?? const MockMissionRepository(),
        historyRepository: current?.historyRepository,
        onLogout: () => current?.sessionStore.clear(),
      ),
    );
  }

  Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.onboarding: (_) => const OnboardingScreen(),
    AppRoutes.login: (context) => AuthScreen(
      initialEmail: ModalRoute.of(context)?.settings.arguments as String?,
      rememberedEmailStore: dependencies?.rememberedEmailStore,
      controller: _authController(),
    ),
    AppRoutes.register: (_) =>
        AuthScreen(initialTab: AuthTab.register, controller: _authController()),
    AppRoutes.verifyEmail: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return VerifyEmailScreen(
        email: email ?? '',
        authRepository: dependencies?.authRepository,
      );
    },
    AppRoutes.forgotPassword: (_) =>
        ForgotPasswordScreen(authRepository: dependencies?.authRepository),
    AppRoutes.verifyResetCode: (context) {
      final email = ModalRoute.of(context)?.settings.arguments as String?;
      return VerifyResetCodeScreen(
        email: email ?? 'psyy@gmail.com',
        authRepository: dependencies?.authRepository,
      );
    },
    AppRoutes.home: (_) => _mainRoute(0),
    AppRoutes.missions: (_) => MissionsScreen(
      repository:
          dependencies?.missionRepository ?? const MockMissionRepository(),
    ),
    AppRoutes.sketchChallenge: (context) {
      final promptId = ModalRoute.of(context)?.settings.arguments as String?;
      return SketchChallengeScreen(
        initialPromptId: promptId,
        completeRepository: dependencies?.sketchChallengeCompleteRepository,
      );
    },
    AppRoutes.sketchChallengeLevels: (_) => SketchChallengeLevelScreen(
      repository: dependencies?.sketchChallengeLevelRepository,
    ),
    AppRoutes.jelajahCilik: (_) => const JelajahScreen(),
    AppRoutes.hitungHewan: (_) => const HitungHewanScreen(),
    AppRoutes.kenaliHuruf: (_) => const KenaliHurufScreen(),
    AppRoutes.ttsVoiceDebug: (_) => const TtsVoiceDebugScreen(),
    AppRoutes.sketchToStory: (_) => const StructurePlaceholderPage(
      title: 'Sketch-to-Story',
      routeName: AppRoutes.sketchToStory,
    ),
    AppRoutes.history: (_) => _mainRoute(1),
    AppRoutes.profile: (_) => _mainRoute(2),
    AppRoutes.teacher: (_) => const StructurePlaceholderPage(
      title: 'Area Guru',
      routeName: AppRoutes.teacher,
    ),
  };
}
