import 'package:flutter/material.dart';

import 'profile_setting_card.dart';

class ProfileJoinedClassroomCard extends StatelessWidget {
  const ProfileJoinedClassroomCard({
    super.key,
    required this.className,
    required this.teacherName,
    required this.onTap,
  });

  final String className;
  final String teacherName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('profile_joined_classroom_card'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xCCFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xE6FFFFFF), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F7042F5),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF4D5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 23,
                  color: Color(0xFFF2B51B),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      className,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF19162F),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      teacherName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF77758A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const ProfileConnectedPill(),
              const SizedBox(width: 4),
              const ProfileChevronButton(),
            ],
          ),
        ),
      ),
    );
  }
}
