import 'package:flutter/material.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.submitting = false,
    this.height = 56,
    this.fontSize = 18,
  });

  final String label;
  final VoidCallback onPressed;
  final bool submitting;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        child: Opacity(
          opacity: submitting ? 0.72 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFB9A4FF),
                  Color(0xFF8B6CFF),
                  Color(0xFF6E4DFF),
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x338B74FF),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: submitting ? null : onPressed,
                borderRadius: radius,
                overlayColor: WidgetStatePropertyAll(
                  Colors.white.withValues(alpha: 0.1),
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: -8,
                        right: 18,
                        width: 90,
                        height: 28,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.28),
                                  Colors.white.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (submitting)
                        const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      else
                        Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (!submitting)
                        const Positioned(
                          right: 22,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
