import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/widgets/glass_surface.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotification,
  });

  final String userName;
  final VoidCallback onNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          GlassSurface(
            radius: 30,
            blur: 16,
            padding: const EdgeInsets.all(3),
            shadows: const [
              BoxShadow(
                color: Color(0x1443309A),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
            child: ClipOval(
              child: Image.asset(
                AssetPaths.userAvatar,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  width: 52,
                  height: 52,
                  child: ColoredBox(
                    color: Color(0xFFFDF3DC),
                    child: Icon(
                      Icons.face_rounded,
                      color: Color(0xFF7042F5),
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Halo, '),
                          TextSpan(
                            text: userName,
                            style: const TextStyle(color: Color(0xFF7042F5)),
                          ),
                          const TextSpan(text: '!'),
                        ],
                      ),
                      key: const Key('home_user_greeting'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF19162F),
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('✨', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _NotificationButton(onTap: onNotification),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 26,
      blur: 18,
      padding: EdgeInsets.zero,
      shadows: const [
        BoxShadow(
          color: Color(0x147042F5),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          key: const Key('home_notification_button'),
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Stack(
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF4B3BA8),
                  size: 24,
                ),
              ),
              Positioned(
                top: 12,
                right: 13,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5A6E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.4),
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
