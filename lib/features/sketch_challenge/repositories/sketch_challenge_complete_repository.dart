abstract interface class SketchChallengeCompleteRepository {
  /// Kirim hasil gambar ke BE, terima reward.
  Future<SketchCompleteResult> completeLevel({
    required String levelId,
    required int strokeCount,
    required int totalPoints,
    required int durationSeconds,
    String? artworkImageUrl,
  });
}

class SketchCompleteResult {
  const SketchCompleteResult({
    required this.starsEarned,
    required this.scoreAdded,
    required this.totalStars,
    this.unlockedLevelId,
    required this.feedbackMessage,
  });

  final int starsEarned;   // 1–3
  final int scoreAdded;    // +10 / +15 / +20
  final int totalStars;
  final String? unlockedLevelId;
  final String feedbackMessage;
}
