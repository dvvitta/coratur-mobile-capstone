import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/widgets/glass_surface.dart';
import '../../missions/models/mission_item.dart';

class HomeMissionsSection extends StatelessWidget {
  const HomeMissionsSection({
    super.key,
    required this.missions,
    required this.loading,
    required this.onSeeAll,
    required this.onOpenMission,
  });

  final List<MissionItem> missions;
  final bool loading;
  final VoidCallback onSeeAll;
  final ValueChanged<MissionItem> onOpenMission;

  @override
  Widget build(BuildContext context) {
    final completedCount = missions.where((mission) => mission.isCompleted).length;
    final progress = missions.isEmpty ? 0.0 : completedCount / missions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF6D6), Color(0xFFFFE49B)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1AFFB800),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  AssetPaths.star,
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFB800),
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Misi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF19162F),
                  letterSpacing: -0.6,
                ),
              ),
            ),
            GestureDetector(
              key: const Key('home_see_all_missions'),
              behavior: HitTestBehavior.opaque,
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7042F5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0x99FFFFFF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x147042F5),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF7042F5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(height: 7, color: const Color(0xFFE9E3FA)),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 7,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFA78BFA), Color(0xFF7042F5)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildList(context),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 64,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }

    final preview = missions.take(3).toList();
    if (preview.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Belum ada misi hari ini.',
          style: TextStyle(fontSize: 13, color: Color(0xFFA19DB3)),
        ),
      );
    }

    return Column(
      children: [
        for (var index = 0; index < preview.length; index++) ...[
          if (index > 0) const SizedBox(height: 12),
          if (preview[index].status == MissionStatus.completed)
            HomeMissionDoneCard(mission: preview[index])
          else if (preview[index].status == MissionStatus.inProgress)
            HomeMissionColorsCard(
              mission: preview[index],
              onTap: () => onOpenMission(preview[index]),
            )
          else
            HomeMissionAppleCard(
              mission: preview[index],
              onTap: () => onOpenMission(preview[index]),
            ),
        ],
      ],
    );
  }
}

class HomeMissionAppleCard extends StatelessWidget {
  const HomeMissionAppleCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  final MissionItem mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _MissionTile(
      mission: mission,
      iconBackground: const Color(0xFFFFF5E0),
      iconSize: 34,
      subtitle: _MissionSubtitle(mission: mission),
      trailing: _PlayButton(onTap: onTap),
    );
  }
}

class HomeMissionColorsCard extends StatelessWidget {
  const HomeMissionColorsCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  final MissionItem mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _MissionTile(
      mission: mission,
      iconBackground: const Color(0xFFF1ECFF),
      iconSize: 34,
      subtitle: _MissionSubtitle(mission: mission),
      belowSubtitle: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Container(height: 5, color: const Color(0xFFE9E3FA)),
                  FractionallySizedBox(
                    widthFactor: mission.progressRatio,
                    child: Container(
                      height: 5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFA78BFA), Color(0xFF7042F5)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${mission.currentProgress}/${mission.totalProgress}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF77758A),
            ),
          ),
        ],
      ),
      trailing: _PlayButton(onTap: onTap),
    );
  }
}

class HomeMissionDoneCard extends StatelessWidget {
  const HomeMissionDoneCard({super.key, required this.mission});

  final MissionItem mission;

  @override
  Widget build(BuildContext context) {
    return _MissionTile(
      mission: mission,
      iconBackground: const Color(0xFFE7FAEE),
      iconSize: 34,
      subtitle: Text(
        '${mission.category} • Selesai · +${mission.reward}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF16A34A),
        ),
      ),
      trailing: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4016A34A),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.mission,
    required this.iconBackground,
    required this.iconSize,
    required this.subtitle,
    required this.trailing,
    this.belowSubtitle,
  });

  final MissionItem mission;
  final Color iconBackground;
  final double iconSize;
  final Widget subtitle;
  final Widget trailing;
  final Widget? belowSubtitle;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 24,
      blur: 16,
      tint: const Color(0xBFFFFFFF),
      borderColor: const Color(0xE6FFFFFF),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      shadows: const [
        BoxShadow(
          color: Color(0x0F7042F5),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Image.asset(
                mission.iconPath,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.brush_rounded,
                  size: 26,
                  color: Color(0xFF7042F5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mission.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF19162F),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                subtitle,
                if (belowSubtitle != null) ...[
                  const SizedBox(height: 8),
                  belowSubtitle!,
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }
}

class _MissionSubtitle extends StatelessWidget {
  const _MissionSubtitle({required this.mission});

  final MissionItem mission;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '${mission.category} • ',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF77758A),
        ),
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Image.asset(
              AssetPaths.star,
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
          TextSpan(
            text: ' +${mission.reward}',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5835D5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8B5CF6), Color(0xFF6D3FE0)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x527042F5),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
