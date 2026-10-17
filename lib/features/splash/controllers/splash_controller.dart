import '../../../core/constants/app_routes.dart';

/// Keputusan rute setelah splash. Persistence onboarding/sesi belum ada,
/// jadi alur development selalu ke onboarding (MOCK).
class SplashController {
  const SplashController();

  String get nextRoute => AppRoutes.onboarding;
}
