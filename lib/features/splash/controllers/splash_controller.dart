import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_routes.dart';

/// Pilih onboarding untuk user baru, login untuk user lama.
class SplashController {
  const SplashController();

  Future<String> get nextRoute async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('onboarding_completed') == true
        ? AppRoutes.login
        : AppRoutes.onboarding;
  }
}
