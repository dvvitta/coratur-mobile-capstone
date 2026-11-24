import 'package:flutter/foundation.dart';

import '../models/leaderboard_entry.dart';
import '../repositories/leaderboard_repository.dart';

/// Tab filter papan peringkat.
enum LeaderboardTab { global, teman }

/// State loading data.
enum LeaderboardLoadState { idle, loading, loaded, error }

/// Controller OOP untuk halaman Leaderboard.
///
/// Mengelola tab aktif, fetch data, dan state loading.
/// Tidak menyentuh UI — emit perubahan via [ChangeNotifier].
class LeaderboardController extends ChangeNotifier {
  LeaderboardController({required this._repository});

  final LeaderboardRepository _repository;

  // ── State ────────────────────────────────────────────────────────────────

  LeaderboardTab _activeTab = LeaderboardTab.global;
  LeaderboardLoadState _loadState = LeaderboardLoadState.idle;
  List<LeaderboardEntry> _entries = [];
  String? _errorMessage;

  LeaderboardTab get activeTab => _activeTab;
  LeaderboardLoadState get loadState => _loadState;
  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  String? get errorMessage => _errorMessage;

  bool get isLoading => _loadState == LeaderboardLoadState.loading;
  bool get hasError => _loadState == LeaderboardLoadState.error;

  /// Top-3 untuk podium (rank 1–3). Bisa kosong jika data belum ada.
  List<LeaderboardEntry> get podiumEntries =>
      _entries.where((e) => e.rank <= 3).toList()
        ..sort((a, b) => a.rank.compareTo(b.rank));

  /// Rank 4+ dan current user (untuk list di bawah podium).
  List<LeaderboardEntry> get listEntries =>
      _entries.where((e) => e.rank > 3).toList()
        ..sort((a, b) {
          // Current user selalu di bawah sekali
          if (a.isCurrentUser) return 1;
          if (b.isCurrentUser) return -1;
          return a.rank.compareTo(b.rank);
        });

  /// Entry current user, null jika tidak ada.
  LeaderboardEntry? get currentUserEntry =>
      _entries.where((e) => e.isCurrentUser).firstOrNull;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) return;
    super.notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Muat data sesuai tab aktif. Panggil sekali dari [initState].
  Future<void> load() => _fetchForTab(_activeTab);

  /// Ganti tab dan muat data tab baru.
  Future<void> switchTab(LeaderboardTab tab) async {
    if (_activeTab == tab && _loadState == LeaderboardLoadState.loaded) return;
    _activeTab = tab;
    notifyListeners();
    await _fetchForTab(tab);
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _fetchForTab(LeaderboardTab tab) async {
    _loadState = LeaderboardLoadState.loading;
    _entries = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final result = tab == LeaderboardTab.global
          ? await _repository.fetchGlobal()
          : await _repository.fetchFriends();
      if (_disposed) return;
      _entries = result;
      _loadState = LeaderboardLoadState.loaded;
    } catch (e) {
      if (_disposed) return;
      _errorMessage = e.toString();
      _loadState = LeaderboardLoadState.error;
    }

    notifyListeners();
  }
}
