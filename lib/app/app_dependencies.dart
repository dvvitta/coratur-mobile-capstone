import '../data/mock/mock_auth_repository.dart';
import '../data/remote/remote_auth_repository.dart';
import '../data/remote/remote_mission_repository.dart';
import '../data/remote/remote_history_repository.dart';
import '../features/history/models/history_artwork_model.dart';
import '../features/history/repositories/history_repository.dart';
import '../data/remote/remote_sketch_challenge_complete_repository.dart';
import '../data/remote/remote_sketch_challenge_repository.dart';
import '../features/authentication/repositories/auth_repository.dart';
import '../features/authentication/services/remembered_email_store.dart';
import '../features/missions/repositories/mission_repository.dart';
import '../features/sketch_challenge/models/level_item_model.dart';
import '../features/sketch_challenge/repositories/sketch_challenge_complete_repository.dart';
import '../features/sketch_challenge/repositories/sketch_challenge_repository.dart';
import 'session_store.dart';

/// Titik konfigurasi dependensi aplikasi.
enum AppEnvironment { mock, remote }

class AppDependencies {
  AppDependencies({
    required this.environment,
    required this.authRepository,
    required this.missionRepository,
    required this.historyRepository,
    required this.sketchChallengeLevelRepository,
    required this.sketchChallengeCompleteRepository,
    this.rememberedEmailStore = const SharedPreferencesRememberedEmailStore(),
    this.apiBaseUrl = '',
    SessionStore? sessionStore,
  }) : sessionStore = sessionStore ?? SessionStore();

  final AppEnvironment environment;
  final AuthRepository authRepository;
  final MissionRepository missionRepository;
  final HistoryRepository historyRepository;
  final SketchChallengeLevelRepository sketchChallengeLevelRepository;
  final SketchChallengeCompleteRepository sketchChallengeCompleteRepository;
  final RememberedEmailStore rememberedEmailStore;
  final String apiBaseUrl;
  final SessionStore sessionStore;

  factory AppDependencies.mock() {
    return AppDependencies(
      environment: AppEnvironment.mock,
      authRepository: const MockAuthRepository(),
      missionRepository: const MockMissionRepository(),
      historyRepository: _MockHistoryRepository(),
      sketchChallengeLevelRepository: _MockSketchChallengeLevelRepository(),
      sketchChallengeCompleteRepository:
          _MockSketchChallengeCompleteRepository(),
      rememberedEmailStore: InMemoryRememberedEmailStore(),
    );
  }

  factory AppDependencies.remote({required String apiBaseUrl}) {
    final sessionStore = SessionStore();
    return AppDependencies(
      environment: AppEnvironment.remote,
      authRepository: RemoteAuthRepository(baseUrl: apiBaseUrl),
      historyRepository: RemoteHistoryRepository(
        baseUrl: apiBaseUrl,
        tokenProvider: () => sessionStore.accessToken,
      ),
      missionRepository: RemoteMissionRepository(
        baseUrl: apiBaseUrl,
        tokenProvider: () => sessionStore.accessToken,
      ),
      sketchChallengeLevelRepository: RemoteSketchChallengeLevelRepository(
        baseUrl: apiBaseUrl,
        tokenProvider: () => sessionStore.accessToken,
      ),
      sketchChallengeCompleteRepository:
          RemoteSketchChallengeCompleteRepository(
            baseUrl: apiBaseUrl,
            tokenProvider: () => sessionStore.accessToken,
          ),
      apiBaseUrl: apiBaseUrl,
      sessionStore: sessionStore,
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

// Fallback in-memory untuk mode mock / test — level 1 active, sisanya locked
class _MockHistoryRepository implements HistoryRepository {
  @override
  Future<List<HistoryArtwork>> fetchHistory() async => const [];
}

class _MockSketchChallengeLevelRepository
    implements SketchChallengeLevelRepository {
  @override
  Future<List<LevelItem>> fetchLevels() async => const [
    LevelItem(
      levelNumber: 1,
      title: 'Bebek',
      subtitle: '+20 Bintang',
      status: LevelStatus.active,
      promptId: 'bebek',
      xRatio: 0.58,
      yRatio: 0.84,
    ),
    LevelItem(
      levelNumber: 2,
      title: 'Kucing',
      subtitle: '+20 Bintang',
      status: LevelStatus.locked,
      promptId: 'kucing',
      xRatio: 0.30,
      yRatio: 0.70,
    ),
    LevelItem(
      levelNumber: 3,
      title: 'Ikan',
      subtitle: '+20 Bintang',
      status: LevelStatus.locked,
      promptId: 'ikan',
      xRatio: 0.56,
      yRatio: 0.58,
    ),
    LevelItem(
      levelNumber: 4,
      title: 'Kupu-Kupu',
      subtitle: '+20 Bintang',
      status: LevelStatus.locked,
      promptId: 'kupu_kupu',
      xRatio: 0.28,
      yRatio: 0.45,
    ),
    LevelItem(
      levelNumber: 5,
      title: 'Kura-Kura',
      subtitle: '+20 Bintang',
      status: LevelStatus.locked,
      promptId: 'kura_kura',
      xRatio: 0.58,
      yRatio: 0.32,
    ),
  ];
}

class _MockSketchChallengeCompleteRepository
    implements SketchChallengeCompleteRepository {
  @override
  Future<SketchCompleteResult> completeLevel({
    required String levelId,
    required int strokeCount,
    required int totalPoints,
    required int durationSeconds,
    String? artworkImageUrl,
  }) async => const SketchCompleteResult(
    starsEarned: 3,
    scoreAdded: 20,
    totalStars: 20,
    unlockedLevelId: null,
    feedbackMessage: 'Wah, hebat sekali! Kamu berhasil!',
  );
}
