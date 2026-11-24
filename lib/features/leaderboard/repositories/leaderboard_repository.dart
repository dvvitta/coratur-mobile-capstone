import '../../../core/constants/asset_paths.dart';
import '../models/leaderboard_entry.dart';

/// Kontrak pengambilan data papan peringkat.
abstract interface class LeaderboardRepository {
  Future<List<LeaderboardEntry>> fetchGlobal();
  Future<List<LeaderboardEntry>> fetchFriends();
}

/// Mock statis untuk dev/preview — tidak memerlukan network.
///
/// Setiap siswa memiliki avatar unik (simulasi foto profil per akun).
/// Saat integrasi backend, [avatarAsset] akan diisi dari URL backend.
class MockLeaderboardRepository implements LeaderboardRepository {
  const MockLeaderboardRepository();

  static const _global = [
    LeaderboardEntry(rank: 1,  name: 'Rafa',  score: 1250, avatarIndex: 0, avatarAsset: AssetPaths.avatarKucing),
    LeaderboardEntry(rank: 2,  name: 'Cinta', score: 1080, avatarIndex: 1, avatarAsset: AssetPaths.avatarPanda),
    LeaderboardEntry(rank: 3,  name: 'Dimas', score: 980,  avatarIndex: 2, avatarAsset: AssetPaths.avatarDinosaurus),
    LeaderboardEntry(rank: 4,  name: 'Nadia', score: 920,  avatarIndex: 3, avatarAsset: AssetPaths.avatarBebek),
    LeaderboardEntry(rank: 5,  name: 'Bima',  score: 860,  avatarIndex: 4, avatarAsset: AssetPaths.avatarPinguin),
    LeaderboardEntry(rank: 6,  name: 'Salsa', score: 800,  avatarIndex: 5, avatarAsset: AssetPaths.avatarHamster),
    LeaderboardEntry(rank: 7,  name: 'Arka',  score: 760,  avatarIndex: 6, avatarAsset: AssetPaths.avatarBeruang),
    LeaderboardEntry(rank: 8,  name: 'Dinda', score: 720,  avatarIndex: 7, avatarAsset: AssetPaths.avatarRubah),
    LeaderboardEntry(rank: 9,  name: 'Rizky', score: 690,  avatarIndex: 0, avatarAsset: AssetPaths.avatarKucing),
    LeaderboardEntry(rank: 10, name: 'Alya',  score: 650,  avatarIndex: 1, avatarAsset: AssetPaths.avatarPanda),
    LeaderboardEntry(
      rank: 147, name: 'Kamu', score: 120,
      avatarIndex: 2, avatarAsset: AssetPaths.avatarDinosaurus, isCurrentUser: true,
    ),
  ];

  static const _friends = [
    LeaderboardEntry(rank: 1,  name: 'Rafa',  score: 1250, avatarIndex: 0, avatarAsset: AssetPaths.avatarKucing),
    LeaderboardEntry(rank: 2,  name: 'Bima',  score: 860,  avatarIndex: 4, avatarAsset: AssetPaths.avatarPinguin),
    LeaderboardEntry(rank: 3,  name: 'Arka',  score: 760,  avatarIndex: 6, avatarAsset: AssetPaths.avatarBeruang),
    LeaderboardEntry(rank: 4,  name: 'Dinda', score: 720,  avatarIndex: 7, avatarAsset: AssetPaths.avatarRubah),
    LeaderboardEntry(
      rank: 5, name: 'Kamu', score: 120,
      avatarIndex: 2, avatarAsset: AssetPaths.avatarDinosaurus, isCurrentUser: true,
    ),
  ];

  @override
  Future<List<LeaderboardEntry>> fetchGlobal() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _global;
  }

  @override
  Future<List<LeaderboardEntry>> fetchFriends() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _friends;
  }
}
