/// Titik konfigurasi dependensi aplikasi.
///
/// Mode default adalah [AppEnvironment.mock] sampai backend/auth
/// benar-benar terhubung. Jangan mengaktifkan [AppEnvironment.remote]
/// tanpa kontrak dan credential yang valid.
enum AppEnvironment { mock, remote }

class AppDependencies {
  const AppDependencies({required this.environment});

  final AppEnvironment environment;

  factory AppDependencies.development() {
    return const AppDependencies(environment: AppEnvironment.mock);
  }

  factory AppDependencies.production() {
    return const AppDependencies(environment: AppEnvironment.remote);
  }

  bool get isMock => environment == AppEnvironment.mock;
}
