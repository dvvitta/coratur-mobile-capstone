import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/errors/app_failure.dart';
import '../models/level_item_model.dart';
import '../repositories/sketch_challenge_repository.dart';
import '../widgets/level_action_card.dart';
import '../widgets/level_gift_node.dart';
import '../widgets/level_header.dart';
import '../widgets/level_node_widget.dart';
import '../widgets/level_path_dots_painter.dart';
import '../widgets/level_world_banner.dart';

class SketchChallengeLevelScreen extends StatefulWidget {
  const SketchChallengeLevelScreen({super.key, this.repository});

  final SketchChallengeLevelRepository? repository;

  @override
  State<SketchChallengeLevelScreen> createState() =>
      _SketchChallengeLevelScreenState();
}

class _SketchChallengeLevelScreenState
    extends State<SketchChallengeLevelScreen> {
  List<LevelItem>? _levels;
  bool _loading = true;
  String? _error;

  static const _giftXRatio = 0.32;
  static const _giftYRatio = 0.21;

  late LevelItem _selectedLevel;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchLevels();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchLevels() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = widget.repository;
      List<LevelItem> levels;
      if (repo == null) {
        levels = _defaultLevels();
      } else {
        levels = await repo.fetchLevels();
        if (levels.isEmpty) levels = _defaultLevels();
      }
      setState(() {
        _levels = levels;
        _loading = false;
        _selectedLevel = levels.firstWhere(
          (l) => l.status == LevelStatus.active,
          orElse: () => levels.first,
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent * 0.4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } on AppFailure catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'Tidak bisa memuat level. Periksa jaringan kamu.';
        _loading = false;
      });
    }
  }

  List<LevelItem> _defaultLevels() => const [
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

  void _onLevelTap(LevelItem level) {
    if (level.status == LevelStatus.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Level ini masih terkunci! Selesaikan level sebelumnya.',
          ),
          backgroundColor: Color(0xFF6B4DFF),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedLevel = level;
    });
    if (level.status == LevelStatus.active ||
        level.status == LevelStatus.completed) {
      _openCanvas();
    }
  }

  void _onGiftTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selesaikan semua level untuk membuka hadiah misteri! 🎁',
        ),
        backgroundColor: Color(0xFFEAB308),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openCanvas() async {
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.sketchChallenge, arguments: _selectedLevel.promptId);
    if (mounted && widget.repository != null) {
      await _fetchLevels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFD4C2FC),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF7546F8)),
              )
            : _error != null
            ? _buildError()
            : _buildMap(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: Color(0xFF7546F8),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF3730A3),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _fetchLevels,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B4DFF),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    final levels = _levels!;
    final completedCount = levels
        .where((l) => l.status == LevelStatus.completed)
        .length;
    final totalStars = levels.fold(0, (sum, l) => sum + l.highStars);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final contentH = (constraints.maxHeight * 1.35).clamp(1000.0, 1400.0);

        final allNodeCenters = [
          ...levels.map((l) => Offset(l.xRatio * w, l.yRatio * contentH)),
          Offset(_giftXRatio * w, _giftYRatio * contentH),
        ];

        return Stack(
          fit: StackFit.expand,
          children: [
            ScrollConfiguration(
              behavior: const _NoStretchScrollBehavior(),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: w,
                  height: contentH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AssetPaths.levelBackground,
                        width: w,
                        height: contentH,
                        fit: BoxFit.cover,
                      ),
                      CustomPaint(
                        size: Size(w, contentH),
                        painter: LevelPathDotsPainter(
                          nodeCenters: allNodeCenters,
                        ),
                      ),
                      ...levels.map(
                        (level) => LevelNodeWidget(
                          level: level,
                          isSelected:
                              _selectedLevel.levelNumber == level.levelNumber,
                          screenWidth: w,
                          contentHeight: contentH,
                          onTap: () => _onLevelTap(level),
                        ),
                      ),
                      LevelGiftNode(
                        xRatio: _giftXRatio,
                        yRatio: _giftYRatio,
                        screenWidth: w,
                        contentHeight: contentH,
                        onTap: _onGiftTap,
                      ),
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(height: 120),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    LevelHeader(
                      totalStars: totalStars,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 14),
                    LevelWorldBanner(
                      completedCount: completedCount,
                      totalLevels: levels.length,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: LevelActionCard(
                  level: _selectedLevel,
                  onStart: _openCanvas,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}
