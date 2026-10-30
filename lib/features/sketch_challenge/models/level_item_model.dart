enum LevelStatus {
  completed,
  active,
  locked,
}

class LevelItem {
  const LevelItem({
    required this.levelNumber,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.promptId,
    required this.xRatio,
    required this.yRatio,
  });

  final int levelNumber;
  final String title;
  final String subtitle;
  final LevelStatus status;
  final String promptId;
  final double xRatio;
  final double yRatio;
}
