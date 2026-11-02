import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
import '../../../core/errors/app_failure.dart';
import '../models/mission_item.dart';
import '../repositories/mission_repository.dart';
import '../widgets/mission_card.dart';

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
                    _buildHeader(),
                    const SizedBox(height: 16),
                    if (_loading)
                      _buildLoading()
                    else if (_failure != null)
                      _buildError(_failure!)
                    else if (_missions.isEmpty)
                      _buildEmpty()
                    else ...[
                      _buildProgressCard(),
                      const SizedBox(height: 20),
                      ..._missions.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final mission = entry.value;
                        final bgColors = [
                          const Color(0xFFFEF8E3),
                          const Color(0xFFEDFBF1),
                          const Color(0xFFEDF9FE),
                          const Color(0xFFF7F3FF),
                        ];
                        final borderColors = [
                          const Color(0xFFFDE8A5),
                          const Color(0xFFC7F2D5),
                          const Color(0xFFC5EDFB),
                          const Color(0xFFE2D6FE),
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: MissionCard(
                            key: Key('mission_item_${mission.id}'),
                            mission: mission,
                            backgroundColor: bgColors[idx % bgColors.length],
                            borderColor:
                                borderColors[idx % borderColors.length],
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
                      _buildSurpriseBanner(),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Misi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
        TextButton(
          key: const Key('missions_back_button'),
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF5B34EA),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kembali'),
              SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Padding(
      key: Key('missions_loading'),
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.6),
        ),
      ),
    );
  }

  Widget _buildError(AppFailure failure) {
    return Container(
      key: const Key('missions_error'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 36,
            color: Color(0xFFB91C1C),
          ),
          const SizedBox(height: 10),
          Text(
            failure.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF7F1D1D),
            ),
          ),
          const SizedBox(height: 14),
          if (_sessionExpired)
            FilledButton(
              key: const Key('missions_login'),
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B34EA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Masuk lagi'),
            )
          else
            OutlinedButton(
              key: const Key('missions_retry'),
              onPressed: _load,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF5B34EA),
                side: const BorderSide(color: Color(0xFF5B34EA)),
              ),
              child: const Text('Coba lagi'),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      key: const Key('missions_empty'),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FC),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_circle_outlined, size: 40, color: Color(0xFF9A97B0)),
          SizedBox(height: 10),
          Text(
            'Belum ada misi hari ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Misi baru akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final progress = _missions.isNotEmpty
        ? _completedCount / _missions.length
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDFE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(
                AssetPaths.star,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '$_completedCount dari ${_missions.length} misi selesai',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
              ),
              Text(
                '+$_earnedPoints',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5B34EA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5B34EA),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurpriseBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1248),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2266),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFFFFB020),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selesaikan semua misi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'untuk buka kejutan hari ini!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF948BB8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
