import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
import '../../missions/models/mission_item.dart';
import '../../missions/repositories/mission_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = 'Arka',
    this.missionRepository = const MockMissionRepository(),
    this.isEmbedded = false,
  });

  final String userName;
  final MissionRepository missionRepository;
  final bool isEmbedded;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<MissionItem> _missions;

  @override
  void initState() {
    super.initState();
    _missions = widget.missionRepository.getMissions();
  }

  void _onNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Belum ada notifikasi baru.')),
    );
  }

  void _onOpenMissions() {
    Navigator.of(context).pushNamed(AppRoutes.missions);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: widget.isEmbedded ? null : _buildBottomNav(),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
              child: Column(
                children: [
                  _buildStickyHeader(),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          const SizedBox(height: 12),
                          _buildAdventureCard(),
                          const SizedBox(height: 24),
                          _buildSectionTitle('Mau Belajar apa hari ini?'),
                          const SizedBox(height: 14),
                          _buildLearningCards(),
                          const SizedBox(height: 16),
                          _buildSketchToStoryBanner(),
                          const SizedBox(height: 24),
                          _buildMissionsHeader(),
                          const SizedBox(height: 14),
                          _buildMissionsSegmentBars(),
                          const SizedBox(height: 16),
                          _buildMissionsList(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFBFCEF),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                AssetPaths.userAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(
                    Icons.face_rounded,
                    color: Color(0xFF5B34EA),
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Halo, ${widget.userName}!',
                  key: const Key('home_user_greeting'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1B4B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '✨',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              key: const Key('home_notification_button'),
              customBorder: const CircleBorder(),
              onTap: _onNotification,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF5B34EA),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdventureCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD6CEF0),
          width: 1.2,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF1E6EE),
            Color(0xFFE2EFF3),
            Color(0xFFD5F3EA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AssetPaths.palette,
            width: 86,
            height: 86,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.palette_outlined,
              color: Color(0xFF6B4DFF),
              size: 48,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Petualangan Hari ini',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kamu sudah menyelesaikan\n3 permainan hari ini',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF2E2A4A),
      ),
    );
  }

  Widget _buildLearningCards() {
    return Row(
      children: [
        Expanded(
          child: _LearningCard(
            key: const Key('home_learning_sketch_challenge'),
            title: 'Sketch Challenge',
            backgroundColor: const Color(0xFFFFF4C7),
            textColor: const Color(0xFF4E2C05),
            imagePath: AssetPaths.sketchChallenge,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.sketchChallengeLevels);
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _LearningCard(
            key: const Key('home_learning_jelajah_cilik'),
            title: 'Jelajah Cilik',
            backgroundColor: const Color(0xFFE2F9DD),
            textColor: const Color(0xFF0C563F),
            imagePath: AssetPaths.jelajahCilik,
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.jelajahCilik);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSketchToStoryBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFA2DCF8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('home_banner_sketch_to_story'),
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.sketchToStory);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    AssetPaths.sketchToStory,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.auto_stories_rounded,
                      color: Color(0xFF6B4DFF),
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sketch-to-Story',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Ubah gambarmu jadi cerita',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Mulai Bercerita',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF00A3FF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Misi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        GestureDetector(
          key: const Key('home_see_all_missions'),
          onTap: _onOpenMissions,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B34EA),
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF5B34EA),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMissionsSegmentBars() {
    return Row(
      children: List.generate(4, (index) {
        final isFilled = index == 0;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 4,
              right: index == 3 ? 0 : 4,
            ),
            height: 6,
            decoration: BoxDecoration(
              color: isFilled
                  ? const Color(0xFF5B34EA)
                  : const Color(0xFFDDD6FE),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMissionsList() {
    // 3 item untuk beranda sesuai Gambar 1:
    // 1. Menggambar apel merah (Sketch Challenge • ★ +20) -> Purple filled button
    // 2. Pakai 5 warna berbeda (Progress 3/5) -> White circular play button
    // 3. Selesaikan 3 permainan (Selesai · bintang sudah didapatkan) -> Solid green check
    final previewList = [
      _missions[0], // Menggambar apel merah
      _missions[3], // Pakai 5 warna berbeda
      _missions[1], // Selesaikan 3 permainan
    ];

    return Column(
      children: [
        _HomeMissionAppleCard(
          mission: previewList[0],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Buka ${previewList[0].title}')),
            );
          },
        ),
        const SizedBox(height: 12),
        _HomeMissionColorsCard(
          mission: previewList[1],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Buka ${previewList[1].title}')),
            );
          },
        ),
        const SizedBox(height: 12),
        _HomeMissionDoneCard(
          mission: previewList[2],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
              // 1. Home Tab (Active)
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
                  Icons.home_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              // 2. History Tab (Navigate to /history)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('nav_history_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.history);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.history_rounded,
                      color: Color(0xFFB5A1F7),
                      size: 28,
                    ),
                  ),
                ),
              ),

              // 3. Profile Tab (Navigate to /profile)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('nav_profile_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profile);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFFB5A1F7),
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

class _LearningCard extends StatelessWidget {
  const _LearningCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final Color backgroundColor;
  final Color textColor;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1.45,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Center(
                      child: Icon(Icons.brush_rounded, size: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    letterSpacing: -0.2,
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

class _HomeMissionAppleCard extends StatelessWidget {
  const _HomeMissionAppleCard({
    required this.mission,
    required this.onTap,
  });

  final MissionItem mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                AssetPaths.missionApple,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Sketch Challenge • ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          AssetPaths.star,
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const TextSpan(
                        text: ' +20',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF5B34EA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMissionColorsCard extends StatelessWidget {
  const _HomeMissionColorsCard({
    required this.mission,
    required this.onTap,
  });

  final MissionItem mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2D6FE), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                AssetPaths.missionPalette,
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: mission.progressRatio,
                          minHeight: 5,
                          backgroundColor: Colors.white,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF5B34EA),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${mission.currentProgress}/${mission.totalProgress}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF5B34EA), width: 2),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Color(0xFF5B34EA),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMissionDoneCard extends StatelessWidget {
  const _HomeMissionDoneCard({
    required this.mission,
  });

  final MissionItem mission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDFBF1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFC7F2D5), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                AssetPaths.missionGames,
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Selesai · bintang sudah didapatkan',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
