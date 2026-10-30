enum MissionStatus {
  notStarted,
  inProgress,
  completed,
}

class MissionItem {
  const MissionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.currentProgress,
    required this.totalProgress,
    required this.reward,
    required this.status,
    required this.iconPath,
    this.actionLabel = 'Mulai',
  });

  final String id;
  final String title;
  final String category;
  final int currentProgress;
  final int totalProgress;
  final int reward;
  final MissionStatus status;
  final String iconPath;
  final String actionLabel;

  bool get isCompleted => status == MissionStatus.completed || currentProgress >= totalProgress;
  double get progressRatio => totalProgress > 0 ? (currentProgress / totalProgress).clamp(0.0, 1.0) : 0.0;
}
