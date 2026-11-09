import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';
import '../../../core/widgets/glass_surface.dart';

class HomeSketchToStoryBanner extends StatelessWidget {
  const HomeSketchToStoryBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 30,
      blur: 22,
      padding: EdgeInsets.zero,
      borderColor: const Color(0xE6FFFFFF),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFDCEBFF), Color(0xFFE9F3FF), Color(0xFFE9E4FF)],
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x125B8DEF),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('home_banner_sketch_to_story'),
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(top: 14, right: 14, child: IgnorePointer()),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 112,
                        child: Image.asset(
                          AssetPaths.sketchToStory,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.auto_stories_rounded,
                            color: Color(0xFF7042F5),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _scaledText(
                            'Sketch-to-Story',
                            const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF19162F),
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _scaledText(
                            'Ubah gambarmu jadi cerita',
                            const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B6880),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  18,
                                  10,
                                  14,
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF8B5CF6),
                                      Color(0xFF6D3FE0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4D7042F5),
                                      blurRadius: 14,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Mulai Bercerita',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scaledText(String text, TextStyle style) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(text, maxLines: 1, style: style),
      ),
    );
  }
}
