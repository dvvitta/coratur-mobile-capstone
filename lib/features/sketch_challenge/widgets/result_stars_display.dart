import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class ResultStarsDisplay extends StatelessWidget {
  const ResultStarsDisplay({super.key, required this.starsEarned});

  final int starsEarned;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (starsEarned >= 1)
            Positioned(
              left: starsEarned == 1 ? null : 20,
              bottom: starsEarned == 1 ? 5 : 0,
              child: Image.asset(
                AssetPaths.star,
                width: starsEarned == 1 ? 120 : 90,
                height: starsEarned == 1 ? 120 : 90,
              ),
            ),
          if (starsEarned >= 2)
            Positioned(
              top: -20,
              child: Image.asset(AssetPaths.star, width: 120, height: 120),
            ),
          if (starsEarned >= 3)
            Positioned(
              right: 20,
              bottom: 0,
              child: Image.asset(AssetPaths.star, width: 90, height: 90),
            ),
        ],
      ),
    );
  }
}
