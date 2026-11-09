import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../features/home/widgets/home_background.dart';
import '../models/history_artwork_model.dart';
import '../repositories/history_repository.dart';
import '../widgets/history_artwork_card.dart';
import '../widgets/history_bottom_nav.dart';
import '../widgets/history_empty_state.dart';
import '../widgets/history_filter_tabs.dart';
import '../widgets/history_greeting_card.dart';

export '../widgets/history_filter_tabs.dart' show HistoryFilter;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    this.initialFilter = HistoryFilter.semua,
    this.userName = 'Arka',
    this.isEmbedded = false,
    this.initialArtworks,
    this.repository,
  });

  final HistoryFilter initialFilter;
  final String userName;
  final bool isEmbedded;
  final List<HistoryArtwork>? initialArtworks;
  final HistoryRepository? repository;

  // ── Mock data (tidak diubah) ──────────────────────────────────────────────
  static const List<HistoryArtwork> mockArtworks = [
    HistoryArtwork(
      id: 'matahari',
      title: 'Matahari',
      levelLabel: 'Level 3 • Kupu-kupu',
      dateLabel: '12 Apr 2025',
      imageAssetPath: AssetPaths.historyArtMatahari,
      status: ArtworkStatus.completed,
      earnedStars: 3,
      totalStars: 3,
    ),
    HistoryArtwork(
      id: 'mobil',
      title: 'Mobil',
      levelLabel: 'Level 2 • Kendaraan',
      dateLabel: '10 Apr 2025',
      imageAssetPath: AssetPaths.historyArtMobil,
      status: ArtworkStatus.inProgress,
      earnedStars: 2,
      totalStars: 3,
    ),
    HistoryArtwork(
      id: 'kucing',
      title: 'Kucing',
      levelLabel: 'Level 2 • Hewan',
      dateLabel: '8 Apr 2025',
      imageAssetPath: AssetPaths.historyArtKucing,
      status: ArtworkStatus.completed,
      earnedStars: 2,
      totalStars: 3,
    ),
    HistoryArtwork(
      id: 'bunga',
      title: 'Bunga',
      levelLabel: 'Level 1 • Benda Sekitar',
      dateLabel: '6 Apr 2025',
      imageAssetPath: AssetPaths.historyArtBunga,
      status: ArtworkStatus.completed,
      earnedStars: 1,
      totalStars: 3,
    ),
  ];

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryFilter _currentFilter;
  late List<HistoryArtwork> _allArtworks;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _allArtworks =
        widget.initialArtworks ??
        (widget.userName == 'Arka' ? HistoryScreen.mockArtworks : const []);
    if (widget.repository != null && widget.initialArtworks == null) {
      _loadHistory();
    }
  }

  // ── Logic (tidak diubah) ──────────────────────────────────────────────────

  Future<void> _loadHistory() async {
    try {
      final artworks = await widget.repository!.fetchHistory();
      if (mounted) setState(() => _allArtworks = artworks);
    } catch (_) {
      // Pertahankan state lokal jika request gagal.
    }
  }

  void _onFilterChanged(HistoryFilter filter) =>
      setState(() => _currentFilter = filter);

  void _onStartDrawing() =>
      Navigator.of(context).pushNamed(AppRoutes.sketchChallengeLevels);

  List<HistoryArtwork> get _filteredArtworks {
    switch (_currentFilter) {
      case HistoryFilter.semua:
        return _allArtworks;
      case HistoryFilter.selesai:
        return _allArtworks
            .where((a) => a.status == ArtworkStatus.completed)
            .toList();
      case HistoryFilter.proses:
        return _allArtworks
            .where((a) => a.status == ArtworkStatus.inProgress)
            .toList();
    }
  }

  // Kalkulasi dari data real — bukan hardcode.
  int get _totalStars =>
      _allArtworks.fold(0, (sum, a) => sum + a.earnedStars);

  int get _totalArtworks => _allArtworks.length;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final displayed = _filteredArtworks;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: HomeBackground.baseColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: HomeBackground.baseColor,
        extendBody: true,
        bottomNavigationBar:
            widget.isEmbedded ? null : const HistoryBottomNav(),
        body: HomeBackground(
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ─────────────────────────────────────────────
                _HistoryHeader(onBack: () => Navigator.of(context).pop()),
                const SizedBox(height: 12),

                // ── Achievement card ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HistoryGreetingCard(
                    userName: widget.userName,
                    hasArtworks: _allArtworks.isNotEmpty,
                    totalStars: _totalStars,
                    totalArtworks: _totalArtworks,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Filter ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: HistoryFilterTabs(
                    currentFilter: _currentFilter,
                    onFilterChanged: _onFilterChanged,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Grid / Empty state ─────────────────────────────────
                Expanded(
                  child: displayed.isNotEmpty
                      ? _ArtworkGrid(
                          artworks: displayed,
                          isEmbedded: widget.isEmbedded,
                        )
                      : HistoryEmptyState(
                          onStartDrawing:
                              _allArtworks.isEmpty ? _onStartDrawing : null,
                          isEmbedded: widget.isEmbedded,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HistoryHeader
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button kiri
          Align(
            alignment: Alignment.centerLeft,
            child: _CircleBackButton(onTap: onBack),
          ),

          // Title + subtitle tengah
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Karya Hebatku',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Semua hasil kreativitasmu ada di sini',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7C719C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF7C4DFF),
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ArtworkGrid
// ─────────────────────────────────────────────────────────────────────────────

class _ArtworkGrid extends StatelessWidget {
  const _ArtworkGrid({
    required this.artworks,
    required this.isEmbedded,
  });

  final List<HistoryArtwork> artworks;
  final bool isEmbedded;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(20, 4, 20, isEmbedded ? 110 : 100),
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          mainAxisExtent: 270,
        ),
        itemCount: artworks.length,
        itemBuilder: (_, i) => HistoryArtworkCard(artwork: artworks[i]),
      ),
    );
  }
}
