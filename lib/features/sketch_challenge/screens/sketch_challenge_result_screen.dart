import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/asset_paths.dart';
import '../models/sketch_challenge_models.dart';
import '../widgets/result_drawing_card.dart';
import '../widgets/result_stars_display.dart';

class SketchChallengeResultScreen extends StatelessWidget {
  const SketchChallengeResultScreen({
    super.key,
    required this.prompt,
    required this.lines,
    required this.canvasSize,
    required this.scoreAdded,
    required this.starsEarned,
    required this.feedbackMessage,
    this.onNext,
    this.onRetry,
  });

  final SketchChallengePrompt prompt;
  final List<DrawnLine> lines;
  final Size canvasSize;
  final int scoreAdded;
  final int starsEarned; // 1–3 dari BE
  final String feedbackMessage;
  final VoidCallback? onNext;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF43309A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF43309A),
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Hebat!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF5B2EE0),
                          letterSpacing: -1.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        feedbackMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ResultStarsDisplay(starsEarned: starsEarned),
                      ResultDrawingCard(lines: lines, canvasSize: canvasSize),
                      const SizedBox(height: 18),
                      _buildScoreBadge(),
                      const SizedBox(height: 24),
                      _buildNextButton(context),
                      const SizedBox(height: 12),
                      _buildRetryButton(context),
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

  Widget _buildScoreBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAE4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE8A5), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AssetPaths.star, width: 34, height: 34),
          const SizedBox(width: 8),
          Text(
            '+$scoreAdded Skor',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B4B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        key: const Key('result_next_button'),
        onPressed: onNext ?? () => Navigator.of(context).pop(),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF7546F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Gambar Berikutnya →',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        key: const Key('result_retry_button'),
        onPressed: onRetry ?? () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF6B33EB), width: 1.5),
          backgroundColor: const Color(0xFFF9F9FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Ulangi Gambar Ini',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B33EB),
          ),
        ),
      ),
    );
  }
}
