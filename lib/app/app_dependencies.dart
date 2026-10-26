import '../data/mock/mock_auth_repository.dart';
import '../data/remote/remote_auth_repository.dart';
import '../features/authentication/repositories/auth_repository.dart';
import 'session_store.dart';

/// Titik konfigurasi dependensi aplikasi.
enum AppEnvironment { mock, remote }

class AppDependencies {
  AppDependencies({
    required this.environment,
    required this.authRepository,
    this.apiBaseUrl = '',
    SessionStore? sessionStore,
  }) : sessionStore = sessionStore ?? SessionStore();

  final AppEnvironment environment;
  final AuthRepository authRepository;
  final String apiBaseUrl;
  final SessionStore sessionStore;

  factory AppDependencies.mock() {
    return AppDependencies(
      environment: AppEnvironment.mock,
      authRepository: const MockAuthRepository(),
    );
  }

  factory AppDependencies.remote({required String apiBaseUrl}) {
    return AppDependencies(
      environment: AppEnvironment.remote,
      authRepository: RemoteAuthRepository(baseUrl: apiBaseUrl),
      apiBaseUrl: apiBaseUrl,
    );
  }

  factory AppDependencies.development({String? apiBaseUrl}) {
    if (apiBaseUrl != null && apiBaseUrl.isNotEmpty) {
      return AppDependencies.remote(apiBaseUrl: apiBaseUrl);
    }
    return AppDependencies.mock();
  }

  factory AppDependencies.production({required String apiBaseUrl}) {
    return AppDependencies.remote(apiBaseUrl: apiBaseUrl);
  }

  bool get isMock => environment == AppEnvironment.mock;
}
