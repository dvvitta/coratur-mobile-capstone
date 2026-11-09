import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../models/mission_item.dart';
import '../repositories/mission_repository.dart';
import '../widgets/mission_card.dart';
import '../widgets/missions_header.dart';
import '../widgets/missions_progress_card.dart';
import '../widgets/missions_state_views.dart';
import '../widgets/missions_surprise_banner.dart';

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({
    super.key,
    this.repository = const MockMissionRepository(),
  });

  final MissionRepository repository;

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  static const _bgColors = [
    Color(0xFFFEF8E3),
    Color(0xFFEDFBF1),
    Color(0xFFEDF9FE),
    Color(0xFFF7F3FF),
  ];

  static const _borderColors = [
    Color(0xFFFDE8A5),
    Color(0xFFC7F2D5),
    Color(0xFFC5EDFB),
    Color(0xFFE2D6FE),
  ];

  var _loading = true;
  AppFailure? _failure;
  List<MissionItem> _missions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final missions = await widget.repository.fetchMissions();
      if (!mounted) return;
      setState(() {
        _missions = missions;
        _loading = false;
      });
    } on AppFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _failure = failure;
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _failure = const AppFailure(
          message: 'Misi gagal dimuat. Coba lagi ya.',
          isRetryable: true,
        );
        _loading = false;
      });
    }
  }

  int get _completedCount => _missions.where((m) => m.isCompleted).length;

  int get _earnedPoints => _missions
      .where((m) => m.isCompleted)
      .fold(0, (total, mission) => total + mission.reward);

  bool get _sessionExpired => _failure?.code == 'UNAUTHENTICATED';

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
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Breakpoints.compact),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 12),
                    MissionsHeader(onBack: () => Navigator.of(context).pop()),
                    const SizedBox(height: 16),
                    if (_loading)
                      const MissionsLoadingView()
                    else if (_failure != null)
                      MissionsErrorView(
                        failure: _failure!,
                        isSessionExpired: _sessionExpired,
                        onRetry: _load,
                      )
                    else if (_missions.isEmpty)
                      const MissionsEmptyView()
                    else ...[
                      MissionsProgressCard(
                        completedCount: _completedCount,
                        totalCount: _missions.length,
                        earnedPoints: _earnedPoints,
                      ),
                      const SizedBox(height: 20),
                      ..._missions.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final mission = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: MissionCard(
                            key: Key('mission_item_${mission.id}'),
                            mission: mission,
                            backgroundColor: _bgColors[idx % _bgColors.length],
                            borderColor:
                                _borderColors[idx % _borderColors.length],
                            onAction: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mulai ${mission.title}'),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      const MissionsSurpriseBanner(),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
