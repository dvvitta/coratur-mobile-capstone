import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class AuthElephant extends StatelessWidget {
  const AuthElephant({super.key, this.width = 312});

  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width * 1.5;
    return Image.asset(
      AssetPaths.authElephant,
      key: const Key('auth_elephant'),
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      semanticLabel: 'Gajah SKETCHOO',
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }
}
