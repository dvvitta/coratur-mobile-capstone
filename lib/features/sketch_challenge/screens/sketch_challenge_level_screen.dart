import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/errors/app_failure.dart';
import '../models/level_item_model.dart';
import '../repositories/sketch_challenge_repository.dart';

class SketchChallengeLevelScreen extends StatefulWidget {
  const SketchChallengeLevelScreen({super.key, this.repository});

  final SketchChallengeLevelRepository? repository;

  @override
  State<SketchChallengeLevelScreen> createState() =>
      _SketchChallengeLevelScreenState();
}

class _SketchChallengeLevelScreenState
    extends State<SketchChallengeLevelScreen> {
  // --- state ---
  List<LevelItem>? _levels;
  bool _loading = true;
  String? _error;

  // Titik hadiah kuning di paling atas (Node 6)
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
        // tanpa repository → fallback statis (user baru = level 1 active)
        levels = _defaultLevels();
      } else {
        levels = await repo.fetchLevels();
        // Jika BE kembalikan list kosong, pakai fallback
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
                        painter: _LevelPathDotsPainter(
                          nodeCenters: allNodeCenters,
                        ),
                      ),
                      ...levels.map(
                        (level) => _buildNodeWidget(level, w, contentH),
                      ),
                      _buildGiftNodeWidget(w, contentH),
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
                    _buildHeader(context),
                    const SizedBox(height: 14),
                    _buildWorldBanner(completedCount, levels.length),
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
                child: _buildActionCard(_selectedLevel),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGiftNodeWidget(double screenW, double contentH) {
    final cx = _giftXRatio * screenW;
    final cy = _giftYRatio * contentH;
    return Positioned(
      left: cx - 40,
      top: cy - 40,
      child: GestureDetector(
        key: const Key('level_gift_node'),
        behavior: HitTestBehavior.opaque,
        onTap: _onGiftTap,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCE31),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x38B45309),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0xFFF59E0B), width: 3.5),
          ),
          child: const Center(
            child: Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFF854D0E),
              size: 38,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeWidget(LevelItem level, double screenW, double contentH) {
    final cx = level.xRatio * screenW;
    final cy = level.yRatio * contentH;
    final isSelected = _selectedLevel.levelNumber == level.levelNumber;

    Widget nodeCircle;
    List<Widget> starsUnderneath = [];
    String labelText = level.title;

    switch (level.status) {
      case LevelStatus.completed:
        nodeCircle = Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF4EDE94),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            border: isSelected
                ? Border.all(color: const Color(0xFF7546F8), width: 3.5)
                : null,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
        );
        // Gunakan high_stars dari BE; fallback 1 kalau 0 (setidaknya 1 bintang untuk selesai)
        final starCount = level.highStars.clamp(1, 3);
        starsUnderneath = List.generate(
          starCount,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Image.asset(
              AssetPaths.star,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
        );
        break;

      case LevelStatus.active:
        nodeCircle = Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0x337546F8),
                border: Border.all(color: const Color(0x557546F8), width: 2.5),
              ),
            ),
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: Color(0xFF7546F8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x447546F8),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        );
        break;

      case LevelStatus.locked:
        nodeCircle = Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFFDDD2FB),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_rounded,
            color: Color(0xFF7546F8),
            size: 26,
          ),
        );
        labelText = '';
        break;
    }

    return Positioned(
      left: cx - 43,
      top: cy - 43,
      child: GestureDetector(
        key: Key('level_node_${level.levelNumber}'),
        behavior: HitTestBehavior.opaque,
        onTap: () => _onLevelTap(level),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 86, height: 86, child: Center(child: nodeCircle)),
            if (labelText.isNotEmpty) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF3730A3),
                      ),
                    ),
                  ),
                  if (starsUnderneath.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: starsUnderneath,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final levels = _levels ?? [];
    final totalStars = levels.fold(0, (sum, l) => sum + l.highStars);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            key: const Key('level_back_button'),
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
        const Expanded(
          child: Text(
            'Sketch Challenge',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3730A3),
              letterSpacing: -0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAE4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.star,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Skor',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6B4DFF),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$totalStars',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3730A3),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorldBanner(int completedCount, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E0FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1243309A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Dunia 1',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF7546F8),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hewan & Alam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF7546F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$completedCount/$total Selesai',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(LevelItem level) {
    return Container(
      key: const Key('level_bottom_action_card'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2243309A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Level ${level.levelNumber} ${level.title}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  level.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7546F8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 42,
            child: FilledButton(
              key: const Key('level_start_button'),
              onPressed: level.status == LevelStatus.locked
                  ? null
                  : _openCanvas,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B4DFF),
                disabledBackgroundColor: const Color(0xFFDDD2FB),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Mulai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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

class _LevelPathDotsPainter extends CustomPainter {
  const _LevelPathDotsPainter({required this.nodeCenters});

  final List<Offset> nodeCenters;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCenters.length < 2) return;
    final dotPaint = Paint()
      ..color = const Color(0xFFBCA7FB)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < nodeCenters.length - 1; i++) {
      final p1 = nodeCenters[i];
      final p2 = nodeCenters[i + 1];
      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      final midY = (p1.dy + p2.dy) / 2;
      final controlPoint = Offset(
        (p1.dx + p2.dx) / 2 + ((i.isEven ? 1 : -1) * 20),
        midY,
      );
      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);

      for (final metric in path.computeMetrics()) {
        final totalLength = metric.length;
        const step = 18.0;
        const dotRadius = 4.5;
        for (double d = 44; d < totalLength - 44; d += step) {
          final tangent = metric.getTangentForOffset(d);
          if (tangent != null) {
            canvas.drawCircle(tangent.position, dotRadius, dotPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LevelPathDotsPainter oldDelegate) =>
      oldDelegate.nodeCenters != nodeCenters;
}
