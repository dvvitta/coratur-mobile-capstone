import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../models/history_artwork_model.dart';

enum HistoryFilter {
  semua,
  selesai,
  proses,
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    this.initialFilter = HistoryFilter.semua,
    this.userName = 'Arka',
    this.isEmbedded = false,
    this.initialArtworks,
  });

  final HistoryFilter initialFilter;
  final String userName;
  final bool isEmbedded;
  final List<HistoryArtwork>? initialArtworks;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryFilter _currentFilter;
  late final List<HistoryArtwork> _allArtworks;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    // Mock artworks dari desain frame 'history full isi.png'
    _allArtworks = widget.initialArtworks ??
        const [
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
            status: ArtworkStatus.completed,
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
  }

  void _onFilterChanged(HistoryFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
  }

  void _onStartDrawing() {
    Navigator.of(context).pushNamed(AppRoutes.sketchChallengeLevels);
  }

  List<HistoryArtwork> get _filteredArtworks {
    switch (_currentFilter) {
      case HistoryFilter.semua:
        return _allArtworks;
      case HistoryFilter.selesai:
        return _allArtworks
            .where((art) => art.status == ArtworkStatus.completed)
            .toList();
      case HistoryFilter.proses:
        return _allArtworks
            .where((art) => art.status == ArtworkStatus.inProgress)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedArtworks = _filteredArtworks;
    final hasArtworks = displayedArtworks.isNotEmpty;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F6FF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FF),
        bottomNavigationBar: widget.isEmbedded ? null : _buildBottomNav(context),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header (Back button + 'Karya Hebatku')
              _buildHeader(context),
              const SizedBox(height: 12),

              // 2. Greeting Banner Card ('Hebat, Arka!') with stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildGreetingCard(hasArtworks: _allArtworks.isNotEmpty),
              ),
              const SizedBox(height: 16),

              // 3. Filter Tabs ('Semua', 'Selesai', 'Proses')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildFilterTabs(),
              ),
              const SizedBox(height: 16),

              // 4. Content Area: Grid karya jika ada isi, atau Empty State krayon jika kosong
              Expanded(
                child: hasArtworks
                    ? _buildArtworkGrid(displayedArtworks)
                    : _buildEmptyState(),
              ),

              // 5. Bottom Action Button jika kosong ('Mulai Menggambar')
              if (!hasArtworks)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      key: const Key('history_start_drawing_button'),
                      onPressed: _onStartDrawing,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7546F8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Mulai Menggambar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          // Circular Purple Back Button
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('history_back_button'),
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF8F6AF7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3343309A),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Header Title
          const Text(
            'Karya Hebatku',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3730A3),
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingCard({required bool hasArtworks}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4B8),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hebat, ${widget.userName}!',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Yuk selesaikan gambar Pohon-mu!',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6B558B),
            ),
          ),
          if (hasArtworks) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                // Badge 1: '4 selesai'
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: Color(0xFF10BD8A),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '4 selesai',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Badge 2: '8 bintang'
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AssetPaths.star,
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        '8 bintang',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        Expanded(
          child: _buildTabItem(
            filter: HistoryFilter.semua,
            label: 'Semua',
            icon: Icons.grid_view_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTabItem(
            filter: HistoryFilter.selesai,
            label: 'Selesai',
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTabItem(
            filter: HistoryFilter.proses,
            label: 'Proses',
            icon: Icons.timelapse_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required HistoryFilter filter,
    required String label,
    required IconData icon,
  }) {
    final isActive = _currentFilter == filter;

    return GestureDetector(
      key: Key('history_tab_${filter.name}'),
      behavior: HitTestBehavior.opaque,
      onTap: () => _onFilterChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6C42F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isActive
              ? null
              : Border.all(
                  color: const Color(0xFFE2E4F0),
                  width: 1.2,
                ),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: Color(0x336C42F5),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : const Color(0xFF645091),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : const Color(0xFF645091),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtworkGrid(List<HistoryArtwork> artworks) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.65,
        ),
        itemCount: artworks.length,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          return _buildArtworkCard(artwork);
        },
      ),
    );
  }

  Widget _buildArtworkCard(HistoryArtwork artwork) {
    return Container(
      key: Key('history_card_${artwork.id}'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFECEEF8), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A43309A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar / Artwork box dengan spacing dari card & rounded tersendiri
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    artwork.imageAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
                // Badge Selesai centang hijau di pojok kanan atas gambar
                if (artwork.status == ArtworkStatus.completed)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C888),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Detail teks: Judul
          Text(
            artwork.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Pill tag Level
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEBFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              artwork.levelLabel,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B21B6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),

          // Tanggal
          Text(
            artwork.dateLabel,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 6),

          // Baris Bintang (3 bintang)
          Row(
            children: List.generate(artwork.totalStars, (index) {
              final isEarned = index < artwork.earnedStars;
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: isEarned
                      ? const Color(0xFFFFB800)
                      : const Color(0xFFE2E0F5),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Crayon illustration mascot with purple oval ground shadow
            SizedBox(
              width: 270,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Purple ground shadow oval
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 210,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB5A9F9),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(210, 38),
                        ),
                      ),
                    ),
                  ),
                  // Crayon mascot
                  Positioned(
                    top: 0,
                    bottom: 10,
                    child: Image.asset(
                      AssetPaths.historyCrayon,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Empty State Title
            const Text(
              'Belum ada karya, nih!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1B4B),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),

            // Empty State Subtitle
            const Text(
              'Yuk, mulai buat karya\npertamamu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF756F86),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4DFF).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Tab (Navigate back to /home)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('history_nav_home_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.home_rounded,
                      color: Color(0xFF6D3FE0),
                      size: 28,
                    ),
                  ),
                ),
              ),

              // 2. History Tab (Active Pill)
              Container(
                width: 74,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6D3FE0),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x336D3FE0),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              // 3. Profile Tab (Navigate to /profile)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('history_nav_profile_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profile);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF6D3FE0),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
