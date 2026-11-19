enum ArtworkStatus { completed, inProgress }

class HistoryArtwork {
  const HistoryArtwork({
    required this.id,
    required this.title,
    required this.levelLabel,
    required this.dateLabel,
    required this.imageAssetPath,
    this.imageUrl,
    required this.status,
    this.earnedStars = 3,
    this.totalStars = 3,
  });

  final String id;
  final String title;
  final String levelLabel;
  final String dateLabel;
  final String imageAssetPath;
  final String? imageUrl;
  final ArtworkStatus status;
  final int earnedStars;
  final int totalStars;
}
