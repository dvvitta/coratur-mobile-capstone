import 'package:flutter/material.dart';

import '../../../core/constants/asset_paths.dart';

class ForgotPasswordElephant extends StatelessWidget {
  const ForgotPasswordElephant({super.key, this.width = 230});

  final double width;

  @override
  Widget build(BuildContext context) {
    // ponytail: scale static asset, upgrade path: SVG if vector asset available
    final height = width * (1536 / 1024);
    return SizedBox(
      width: width,
      height: height * 0.72,
      child: OverflowBox(
        maxHeight: height,
        alignment: const Alignment(0, -0.2),
        child: Image.asset(
          AssetPaths.forgotPasswordElephant,
          key: const Key('forgot_password_elephant'),
          width: width,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          semanticLabel: 'Gajah Lupa Sandi',
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
