import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';

class HistoryBottomNav extends StatelessWidget {
  const HistoryBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
              // 1. Home Tab (Navigate back to /home)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('history_nav_home_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.home);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.home_rounded,
                      color: Color(0xFF6D3FE0),
                      size: 28,
                    ),
                  ),
                ),
              ),

              // 2. History Tab (Active Pill)
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
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              // 3. Profile Tab (Navigate to /profile)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const Key('history_nav_profile_button'),
                  customBorder: const CircleBorder(),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.profile);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.person_rounded,
                      color: Color(0xFF6D3FE0),
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
