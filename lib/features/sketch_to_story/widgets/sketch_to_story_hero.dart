import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

/// Ilustrasi utama di halaman Sketch to Story.
class SketchToStoryHero extends StatelessWidget {
  const SketchToStoryHero({super.key, this.height = 240});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        AssetPaths.creativeElephant,
        fit: BoxFit.contain,
      ),
    );
  }
}
