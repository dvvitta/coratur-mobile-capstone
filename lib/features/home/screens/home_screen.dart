import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/breakpoints.dart';
import '../../missions/models/mission_item.dart';
import '../../missions/repositories/mission_repository.dart';
import '../widgets/home_adventure_card.dart';
import '../widgets/home_background.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_learning_section.dart';
import '../widgets/home_missions_section.dart';
import '../widgets/home_sketch_to_story_banner.dart';

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
  List<MissionItem> _missions = const [];
  var _missionsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    try {
      final missions = await widget.missionRepository.fetchMissions();
      if (!mounted) return;
      setState(() {
        _missions = missions;
        _missionsLoading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _missionsLoading = false;
      });
    }
  }

  void _onNotification() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Belum ada notifikasi baru.')));
  }

  void _onOpenMissions() {
    Navigator.of(context).pushNamed(AppRoutes.missions);
  }

  void _onOpenMission(MissionItem mission) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Buka ${mission.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF8F7FF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: HomeBackground.baseColor,
        extendBody: !widget.isEmbedded,
        bottomNavigationBar: widget.isEmbedded
            ? null
            : HomeBottomNav(
                onHistoryTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.history),
                onProfileTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profile),
              ),
        body: HomeBackground(
          child: SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      HomeHeader(
                        userName: widget.userName,
                        onNotification: _onNotification,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const HomeAdventureCard(),
                            const SizedBox(height: 28),
                            HomeLearningSection(
                              onSketchChallengeTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.sketchChallengeLevels);
                              },
                              onJelajahCilikTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.jelajahCilik);
                              },
                            ),
                            const SizedBox(height: 20),
                            HomeSketchToStoryBanner(
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.sketchToStory);
                              },
                            ),
                            const SizedBox(height: 26),
                            HomeMissionsSection(
                              missions: _missions,
                              loading: _missionsLoading,
                              onSeeAll: _onOpenMissions,
                              onOpenMission: _onOpenMission,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 112),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
