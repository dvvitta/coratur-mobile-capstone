import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/breakpoints.dart';
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
  late final List<MissionItem> _missions;

  @override
  void initState() {
    super.initState();
    _missions = widget.repository.getMissions();
  }

  int get _completedCount => _missions.where((m) => m.isCompleted).length;

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
                          borderColor: borderColors[idx % borderColors.length],
                          onAction: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Mulai ${mission.title}')),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    _buildSurpriseBanner(),
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

  Widget _buildProgressCard() {
    final progress = _missions.isNotEmpty ? _completedCount / _missions.length : 0.0;

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
              const Text(
                '+20',
                style: TextStyle(
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
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B34EA)),
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
