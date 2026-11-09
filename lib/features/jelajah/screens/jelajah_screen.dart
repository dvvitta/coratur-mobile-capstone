import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../models/jelajah_models.dart';
import '../widgets/jelajah_card.dart';
import '../widgets/jelajah_category_chips.dart';
import '../widgets/jelajah_header.dart';

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
              JelajahHeader(
                onBack: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
              ),
              Padding(
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
              ),
              const SizedBox(height: 14),
              JelajahCategoryChips(
                selectedCategory: _selectedCategory,
                onSelectCategory: _onSelectCategory,
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const JelajahScrollBehavior().copyWith(
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
                          return JelajahCard(
                            item: item,
                            onTap: () => _onOpenItem(item),
                          );
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
}
