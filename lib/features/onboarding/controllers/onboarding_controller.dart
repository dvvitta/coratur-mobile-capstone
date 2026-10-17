import '../../../core/constants/app_routes.dart';
import '../models/onboarding_page_data.dart';

/// Onboarding belum disimpan lokal. Lewati dan CTA akhir menuju login (MOCK).
class OnboardingController {
  const OnboardingController();

  int get pageCount => OnboardingPages.pages.length;

  String get completedRoute => AppRoutes.login;

  bool isLastPage(int index) => index >= pageCount - 1;
}
