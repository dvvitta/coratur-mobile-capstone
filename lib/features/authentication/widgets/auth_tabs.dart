import 'package:flutter/material.dart';

import '../models/auth_tab.dart';
import 'auth_colors.dart';

class AuthTabs extends StatelessWidget {
  const AuthTabs({super.key, required this.tab, required this.onChanged});

  final AuthTab tab;
  final ValueChanged<AuthTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 2, 1, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 231, 245),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color.fromARGB(255, 232, 224, 250)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            height: 48,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  alignment: tab == AuthTab.login
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF4F0FF)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x4D8B74FF),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Color(0x338B74FF),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    AuthTabChip(
                      key: const Key('auth_tab_login'),
                      label: 'Masuk',
                      icon: Icons.email_rounded,
                      selected: tab == AuthTab.login,
                      onTap: () => onChanged(AuthTab.login),
                    ),
                    AuthTabChip(
                      key: const Key('auth_tab_register'),
                      label: 'Daftar',
                      icon: Icons.person_rounded,
                      selected: tab == AuthTab.register,
                      onTap: () => onChanged(AuthTab.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTabChip extends StatelessWidget {
  const AuthTabChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: selected ? AuthColors.accent : const Color(0xFFB0ADC0),
                ),
                const SizedBox(width: 8),
              ],
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selected ? AuthColors.accent : const Color(0xFFB0ADC0),
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
