import 'package:flutter/material.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({
    super.key,
    required this.title,
    required this.gradient,
    required this.accentColor,
    this.icon,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final List<Color> gradient;
  final Color accentColor;
  final IconData? icon;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xD9FFFFFF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.14),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Center(
                      child: Icon(
                        icon ?? Icons.school_rounded,
                        size: 38,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (icon != null) ...[
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xCCFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 15, color: accentColor),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF19162F),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0x8CFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: accentColor,
                      ),
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
