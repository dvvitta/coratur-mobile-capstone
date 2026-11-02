import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../models/jelajah_models.dart';

/// Scroll behavior yang mengizinkan drag dengan mouse, trackpad, dan stylus,
/// bukan hanya sentuhan. Penting agar deretan chip tetap bisa digeser saat
/// aplikasi dijalankan di macOS/Chrome maupun di perangkat sentuh.
class _JelajahScrollBehavior extends MaterialScrollBehavior {
  const _JelajahScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}

class JelajahScreen extends StatefulWidget {
  const JelajahScreen({
    super.key,
    this.items = defaultItems,
    this.initialCategory,
  });

  final List<JelajahItem> items;

  /// null berarti chip "Semua" aktif.
  final JelajahCategory? initialCategory;

  static const List<JelajahItem> defaultItems = [
    JelajahItem(
      id: 'hutan',
      title: 'Petualangan di Hutan',
      description: 'Baca cerita pendek dan jawab pertanyaannya!',
      category: JelajahCategory.membaca,
      levelLabel: 'Level 1 • Mudah',
    ),
    JelajahItem(
      id: 'hutan-2',
      title: 'Petualangan di Hutan',
      description: 'Baca cerita pendek dan jawab pertanyaannya!',
      category: JelajahCategory.membaca,
      levelLabel: 'Level 1 • Mudah',
    ),
    JelajahItem(
      id: 'kenali-huruf',
      title: 'Kenali Huruf',
      description: 'Yuk belajar mengenal huruf bersama harimau!',
      category: JelajahCategory.membaca,
      levelLabel: 'Level 1 • Mudah',
      routeName: AppRoutes.kenaliHuruf,
    ),
    JelajahItem(
      id: 'hitung-buah',
      title: 'Hitung Buah',
      description: 'Hitung jumlah buah sambil belajar angka!',
      category: JelajahCategory.berhitung,
      levelLabel: 'Level 1 • Mudah',
    ),
    JelajahItem(
      id: 'hitung-hewan',
      title: 'Hitung Hewan',
      description: 'Yuk hitung hewan di kebun binatang!',
      category: JelajahCategory.berhitung,
      levelLabel: 'Level 2 • Sedang',
      routeName: AppRoutes.hitungHewan,
    ),
    JelajahItem(
      id: 'warnai-bunga',
      title: 'Warnai Bunga',
      description: 'Warnai bunga dengan krayon warna warni!',
      category: JelajahCategory.menggambar,
      levelLabel: 'Level 1 • Mudah',
    ),
    JelajahItem(
      id: 'gambar-kucing',
      title: 'Gambar Kucing',
      description: 'Ikuti garis lalu gambar kucing lucu!',
      category: JelajahCategory.menggambar,
      levelLabel: 'Level 2 • Sedang',
      routeName: AppRoutes.sketchChallenge,
    ),
  ];

  @override
  State<JelajahScreen> createState() => _JelajahScreenState();
}

class _JelajahScreenState extends State<JelajahScreen> {
  JelajahCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  List<JelajahItem> get _visibleItems {
    final category = _selectedCategory;
    if (category == null) return widget.items;
    return widget.items.where((item) => item.category == category).toList();
  }

  void _onSelectCategory(JelajahCategory? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onOpenItem(JelajahItem item) {
    if (item.id == 'gambar-kucing') {
      Navigator.of(context)
          .pushNamed(AppRoutes.sketchChallenge, arguments: 'cat');
      return;
    }

    final routeName = item.routeName;
    if (routeName != null) {
      Navigator.of(context).pushNamed(routeName);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} segera hadir!'),
        backgroundColor: const Color(0xFF6C42F5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _visibleItems;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F6FF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5FD),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              _buildTtsDebugButton(context),
              const SizedBox(height: 14),
              _buildCategoryChips(),
              const SizedBox(height: 14),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const _JelajahScrollBehavior().copyWith(
                    overscroll: false,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        key: const Key('jelajah_grid'),
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 16,
                          mainAxisExtent: _cardHeight(constraints.maxWidth),
                        ),
                        itemCount: visibleItems.length,
                        itemBuilder: (context, index) {
                          final item = visibleItems[index];
                          return _buildCard(item);
                        },
                      );
                    },
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
    final pencilHeight = MediaQuery.sizeOf(context).width * 0.36;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Tombol kembali
                  Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      key: const Key('jelajah_back_button'),
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                            AppRoutes.home,
                            (route) => false,
                          ),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6C42F5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x336C42F5),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Jelajah Cilik',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4632AB),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(right: 96),
                child: Text(
                  'Yuk, jelajahi dunia baru lewat membaca, '
                  'berhitung, dan banyak lagi!',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF564F85),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Maskot krayon di pojok kanan atas
        Positioned(
          top: -10,
          right: -16,
          child: IgnorePointer(
            child: Image.asset(
              AssetPaths.jelajahPencil,
              key: const Key('jelajah_pencil_asset'),
              height: pencilHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTtsDebugButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          key: const Key('jelajah_tts_debug_button'),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.ttsVoiceDebug),
          icon: const Icon(Icons.record_voice_over_rounded, size: 17),
          label: const Text('Tes Suara TalkingTiger'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6C42F5),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ScrollConfiguration(
        behavior: const _JelajahScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          key: const Key('jelajah_chip_scroll'),
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildChip(
                key: const Key('jelajah_chip_semua'),
                label: 'Semua',
                isActive: _selectedCategory == null,
                background: const Color(0xFF6C42F5),
                accent: Colors.white,
                icon: Icons.grid_view_rounded,
                onTap: () => _onSelectCategory(null),
              ),
              for (final category in JelajahCategory.values) ...[
                const SizedBox(width: 8),
                _buildChip(
                  key: Key('jelajah_chip_${category.name}'),
                  label: category.label,
                  isActive: _selectedCategory == category,
                  background: category.chipBackground,
                  accent: category.accent,
                  icon: category.icon,
                  glyph: category.glyph,
                  onTap: () => _onSelectCategory(category),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip({
    required Key key,
    required String label,
    required bool isActive,
    required Color background,
    required Color accent,
    required IconData icon,
    required VoidCallback onTap,
    String? glyph,
  }) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(13),
          boxShadow: isActive
              ? const [
                  BoxShadow(
                    color: Color(0x336C42F5),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (glyph != null)
              Text(
                glyph,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: accent,
                ),
              )
            else
              Icon(icon, size: 15, color: accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tinggi kartu dihitung dari isi kartu agar tidak ada ruang kosong
  /// berlebih dan tetap aman saat ukuran teks sistem diperbesar.
  double _cardHeight(double availableWidth) {
    const horizontalPadding = 20.0;
    const crossSpacing = 14.0;
    const cardPadding = 10.0;

    final cardWidth =
        (availableWidth - horizontalPadding * 2 - crossSpacing) / 2;
    final thumbnailHeight = (cardWidth - cardPadding * 2) / 1.62;

    final scaler = MediaQuery.textScalerOf(context);
    final titleHeight = scaler.scale(15) * 1.15 * 2;
    final descriptionHeight = scaler.scale(10.5) * 1.35 * 2;

    return cardPadding * 2 +
        thumbnailHeight +
        9 +
        titleHeight +
        3 +
        descriptionHeight +
        8 +
        26 +
        4;
  }

  Widget _buildCard(JelajahItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('jelajah_card_${item.id}'),
        borderRadius: BorderRadius.circular(22),
        onTap: () => _onOpenItem(item),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEDEDF8), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D43309A),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(item),
              const SizedBox(height: 9),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF5A48B5),
                  height: 1.15,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA79EE3),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 8),
              _buildLevelPill(item.levelLabel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(JelajahItem item) {
    final category = item.category;

    return AspectRatio(
      aspectRatio: 1.62,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: item.imageAssetPath != null
                  ? Image.asset(item.imageAssetPath!, fit: BoxFit.cover)
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            category.chipBackground,
                            Color.lerp(
                              category.chipBackground,
                              Colors.white,
                              0.45,
                            )!,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          category.icon,
                          size: 38,
                          color: category.accent.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
            ),
          ),

          // Badge kategori
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: category.badgeColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, size: 11, color: Colors.white),
                  const SizedBox(width: 3),
                  Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol panah
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFE9E3FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF6C42F5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPill(String label) {
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4C5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFFFC93C)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7B7DBE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
