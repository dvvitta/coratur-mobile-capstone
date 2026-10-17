import 'package:flutter/material.dart';

import '../models/onboarding_page_data.dart';
import 'onboarding_colors.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({super.key, required this.page});

  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          child: Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [OnboardingColors.glow, Color(0x00FFFFFF)],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image.asset(
            page.illustrationPath,
            key: Key('onboarding_illustration_${page.illustrationPath}'),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            semanticLabel: page.title.replaceAll('\n', ' '),
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
