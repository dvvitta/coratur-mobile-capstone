import 'package:flutter/material.dart';

class ProfileSettingCard extends StatelessWidget {
  const ProfileSettingCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 23, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF19162F),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCustomSwitch extends StatelessWidget {
  const ProfileCustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: value
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D3FE0)],
                )
              : null,
          color: value ? null : const Color(0xFFE3DFF2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: value
              ? const [
                  BoxShadow(
                    color: Color(0x387042F5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileChevronButton extends StatelessWidget {
  const ProfileChevronButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.chevron_right_rounded,
      size: 26,
      color: Color(0xFF7C719C),
    );
  }
}

/// Badge kecil "Terhubung" untuk status kelas.
class ProfileConnectedPill extends StatelessWidget {
  const ProfileConnectedPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F8EA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 16, color: Color(0xFF20B879)),
          SizedBox(width: 4),
          Text(
            'Terhubung',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20B879),
            ),
          ),
        ],
      ),
    );
  }
}
